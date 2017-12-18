#import "GPUImageRawDataOutput.h"

#import "GPUImageContext.h"
#import "GLProgram.h"
#import "GPUImageFilter.h"
#import "GPUImageMovieWriter.h"

@interface GPUImageRawDataOutput ()
{
    GPUImageFramebuffer *firstInputFramebuffer, *outputFramebuffer, *retainedFramebuffer;
    
    BOOL hasReadFromTheCurrentFrame;
    
    GLProgram *dataProgram;
    GLint dataPositionAttribute, dataTextureCoordinateAttribute;
    GLint dataInputTextureUniform;
    
    GLubyte *_rawBytesForImage;
    
    BOOL lockNextFramebuffer;
}

// Frame rendering
- (void)renderAtInternalSize;

@end

@implementation GPUImageRawDataOutput

@synthesize rawBytesForImage = _rawBytesForImage;
@synthesize newFrameAvailableBlock = _newFrameAvailableBlock;
@synthesize enabled;

#pragma mark -
#pragma mark Initialization and teardown

//初始化的时候需要指定纹理大小以及是否以BGRA形式的数据输入。
//如果是以BGRA的形式输入，则在选择片段着色器的时候会选择kGPUImageColorSwizzlingFragmentShaderString着色器来进行从BGRA-到RGBA的转换。
- (id)initWithImageSize:(CGSize)newImageSize resultsInBGRAFormat:(BOOL)resultsInBGRAFormat;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    self.enabled = YES;
    lockNextFramebuffer = NO;
    outputBGRA = resultsInBGRAFormat;
    imageSize = newImageSize;
    hasReadFromTheCurrentFrame = NO;
    _rawBytesForImage = NULL;
    inputRotation = kGPUImageNoRotation;
    
    [GPUImageContext useImageProcessingContext];
    // 如果使用了BGRA ，则选择kGPUImageColorSwizzlingFragmentShaderString着色器
    if ( (outputBGRA && ![GPUImageContext supportsFastTextureUpload]) || (!outputBGRA && [GPUImageContext supportsFastTextureUpload]) )
    {
        dataProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImageColorSwizzlingFragmentShaderString];
    }
    // 否则选用kGPUImagePassthroughFragmentShaderString着色器
    else
    {
        dataProgram = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kGPUImageVertexShaderString fragmentShaderString:kGPUImagePassthroughFragmentShaderString];
    }
    // 判断是否初始化已经成功了
    if (!dataProgram.initialized)
    {
        [dataProgram addAttribute:@"position"];
        [dataProgram addAttribute:@"inputTextureCoordinate"];
        
        if (![dataProgram link])
        {
            NSString *progLog = [dataProgram programLog];
            NSLog(@"Program link log: %@", progLog);
            NSString *fragLog = [dataProgram fragmentShaderLog];
            NSLog(@"Fragment shader compile log: %@", fragLog);
            NSString *vertLog = [dataProgram vertexShaderLog];
            NSLog(@"Vertex shader compile log: %@", vertLog);
            dataProgram = nil;
            NSAssert(NO, @"Filter shader link failed");
        }
    }
    
    // 获取统一变量和属性 ，给统一变量赋值
    dataPositionAttribute = [dataProgram attributeIndex:@"position"];
    dataTextureCoordinateAttribute = [dataProgram attributeIndex:@"inputTextureCoordinate"];
    dataInputTextureUniform = [dataProgram uniformIndex:@"inputImageTexture"];
    
    return self;
    
}

- (void)dealloc
{
    if (_rawBytesForImage != NULL && (![GPUImageContext supportsFastTextureUpload]))
    {
        free(_rawBytesForImage);
        _rawBytesForImage = NULL;
    }
}

#pragma mark -
#pragma mark Data access

- (void)renderAtInternalSize;
{
    [GPUImageContext setActiveShaderProgram:dataProgram];

    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:imageSize onlyTexture:NO];
    [outputFramebuffer activateFramebuffer];

    if(lockNextFramebuffer)
    {
        retainedFramebuffer = outputFramebuffer;
        [retainedFramebuffer lock];
        [retainedFramebuffer lockForReading];
        lockNextFramebuffer = NO;
    }

    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };
    
    static const GLfloat textureCoordinates[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
	glActiveTexture(GL_TEXTURE4);
	glBindTexture(GL_TEXTURE_2D, [firstInputFramebuffer texture]);
	glUniform1i(dataInputTextureUniform, 4);	
    
    glVertexAttribPointer(dataPositionAttribute, 2, GL_FLOAT, 0, 0, squareVertices);
	glVertexAttribPointer(dataTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glEnableVertexAttribArray(dataPositionAttribute);
	glEnableVertexAttribArray(dataTextureCoordinateAttribute);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [firstInputFramebuffer unlock];
}

// 获取特定位置的像素向量
- (GPUByteColorVector)colorAtLocation:(CGPoint)locationInImage;
{
    // 将数据转为GPUByteColorVector类型
    GPUByteColorVector *imageColorBytes = (GPUByteColorVector *)self.rawBytesForImage;
    //    NSLog(@"Row start");
    //    for (unsigned int currentXPosition = 0; currentXPosition < (imageSize.width * 2.0); currentXPosition++)
    //    {
    //        GPUByteColorVector byteAtPosition = imageColorBytes[currentXPosition];
    //        NSLog(@"%d - %d, %d, %d", currentXPosition, byteAtPosition.red, byteAtPosition.green, byteAtPosition.blue);
    //    }
    //    NSLog(@"Row end");
    
    //    GPUByteColorVector byteAtOne = imageColorBytes[1];
    //    GPUByteColorVector byteAtWidth = imageColorBytes[(int)imageSize.width - 3];
    //    GPUByteColorVector byteAtHeight = imageColorBytes[(int)(imageSize.height - 1) * (int)imageSize.width];
    //    NSLog(@"Byte 1: %d, %d, %d, byte 2: %d, %d, %d, byte 3: %d, %d, %d", byteAtOne.red, byteAtOne.green, byteAtOne.blue, byteAtWidth.red, byteAtWidth.green, byteAtWidth.blue, byteAtHeight.red, byteAtHeight.green, byteAtHeight.blue);
    
    // 控制边界，0 < x < width, 0 < y < height,
    CGPoint locationToPickFrom = CGPointZero;
    locationToPickFrom.x = MIN(MAX(locationInImage.x, 0.0), (imageSize.width - 1.0));
    locationToPickFrom.y = MIN(MAX((imageSize.height - locationInImage.y), 0.0), (imageSize.height - 1.0));
    
    // 如果是BGRA输出，则把RGBA数据转为BGRA数据
    if (outputBGRA)
    {
        GPUByteColorVector flippedColor = imageColorBytes[(int)(round((locationToPickFrom.y * imageSize.width) + locationToPickFrom.x))];
        GLubyte temporaryRed = flippedColor.red;
        
        flippedColor.red = flippedColor.blue;
        flippedColor.blue = temporaryRed;
        
        return flippedColor;
    }
    else
    {
        // 返回某个位置的像素向量
        return imageColorBytes[(int)(round((locationToPickFrom.y * imageSize.width) + locationToPickFrom.x))];
    }
}

#pragma mark -
#pragma mark GPUImageInput protocol

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
{
    hasReadFromTheCurrentFrame = NO;
    
    if (_newFrameAvailableBlock != NULL)
    {
        _newFrameAvailableBlock();
    }
}

- (NSInteger)nextAvailableTextureIndex;
{
    return 0;
}

- (void)setInputFramebuffer:(GPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
{
    firstInputFramebuffer = newInputFramebuffer;
    [firstInputFramebuffer lock];
}

- (void)setInputRotation:(GPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
{
    inputRotation = newInputRotation;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
{
}

- (CGSize)maximumOutputSize;
{
    return imageSize;
}

- (void)endProcessing;
{
}

- (BOOL)shouldIgnoreUpdatesToThisTarget;
{
    return NO;
}

- (BOOL)wantsMonochromeInput;
{
    return NO;
}

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
{
    
}

#pragma mark -
#pragma mark Accessors

// 获取RGBA数据
- (GLubyte *)rawBytesForImage;
{
    if ( (_rawBytesForImage == NULL) && (![GPUImageContext supportsFastTextureUpload]) )
    {
        // 申请空间，储存读取的数据
        _rawBytesForImage = (GLubyte *) calloc(imageSize.width * imageSize.height * 4, sizeof(GLubyte));
        hasReadFromTheCurrentFrame = NO;
    }
    
    if (hasReadFromTheCurrentFrame)
    {
        return _rawBytesForImage;
    }
    else
    {
        runSynchronouslyOnVideoProcessingQueue(^{
            // Note: the fast texture caches speed up 640x480 frame reads from 9.6 ms to 3.1 ms on iPhone 4S
            // 设置GL下文对象
            [GPUImageContext useImageProcessingContext];
            // 渲染到帧缓存
            [self renderAtInternalSize];
            
            if ([GPUImageContext supportsFastTextureUpload])
            {
                // 等待绘制结束
                glFinish();
                _rawBytesForImage = [outputFramebuffer byteBuffer];
            }
            else
            {
                // 以RGBA的形式读取数据
                glReadPixels(0, 0, imageSize.width, imageSize.height, GL_RGBA, GL_UNSIGNED_BYTE, _rawBytesForImage);
                // GL_EXT_read_format_bgra
                //            glReadPixels(0, 0, imageSize.width, imageSize.height, GL_BGRA_EXT, GL_UNSIGNED_BYTE, _rawBytesForImage);
            }
            
            hasReadFromTheCurrentFrame = YES;
            
        });
        
        return _rawBytesForImage;
    }
}
 
// 每行数据大小
- (NSUInteger)bytesPerRowInOutput;
{
    return [retainedFramebuffer bytesPerRow];
}

// 设置输出纹理大小
- (void)setImageSize:(CGSize)newImageSize {
    imageSize = newImageSize;
    if (_rawBytesForImage != NULL && (![GPUImageContext supportsFastTextureUpload]))
    {
        free(_rawBytesForImage);
        _rawBytesForImage = NULL;
    }
}


// 锁定帧缓存
- (void)lockFramebufferForReading;
{
    lockNextFramebuffer = YES;
}

// 解锁帧缓存
- (void)unlockFramebufferAfterReading;
{
    [retainedFramebuffer unlockAfterReading];
    [retainedFramebuffer unlock];
    retainedFramebuffer = nil;
}

 
@end
