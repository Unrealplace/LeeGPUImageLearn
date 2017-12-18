#import "GPUImageRawDataInput.h"

@interface GPUImageRawDataInput()
- (void)uploadBytes:(GLubyte *)bytesToUpload;
@end

@implementation GPUImageRawDataInput

@synthesize pixelFormat = _pixelFormat;
@synthesize pixelType = _pixelType;

#pragma mark -
#pragma mark Initialization and teardown

//构造的时候如果不指定像素格式和数据类型，默认会使用GPUPixelFormatBGRA和GPUPixelTypeUByte的方式。
//构造的过程是：
//1、初始化实例变量；
//2、生成只有纹理对象的GPUImageFramebuffer对象；
//3、给纹理对象绑定RawData数据。
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
{
    if (!(self = [self initWithBytes:bytesToUpload size:imageSize pixelFormat:GPUPixelFormatBGRA type:GPUPixelTypeUByte]))
    {
		return nil;
    }
	
	return self;
}

- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(GPUPixelFormat)pixelFormat;
{
    if (!(self = [self initWithBytes:bytesToUpload size:imageSize pixelFormat:pixelFormat type:GPUPixelTypeUByte]))
    {
		return nil;
    }
	
	return self;
}

- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(GPUPixelFormat)pixelFormat type:(GPUPixelType)pixelType;
{
    if (!(self = [super init]))
    {
		return nil;
    }
    
	dataUpdateSemaphore = dispatch_semaphore_create(1);

    uploadedImageSize = imageSize;
	self.pixelFormat = pixelFormat;
	self.pixelType = pixelType;
        
    [self uploadBytes:bytesToUpload];
    
    return self;
}

// ARC forbids explicit message send of 'release'; since iOS 6 even for dispatch_release() calls: stripping it out in that case is required.
- (void)dealloc;
{
#if !OS_OBJECT_USE_OBJC
    if (dataUpdateSemaphore != NULL)
    {
        dispatch_release(dataUpdateSemaphore);
    }
#endif
}

#pragma mark -
#pragma mark Image rendering

- (void)uploadBytes:(GLubyte *)bytesToUpload;
{
    // 设置上下文对象
    [GPUImageContext useImageProcessingContext];
    
    // 生成GPUImageFramebuffer // 作者说这里可能有问题
    outputFramebuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:uploadedImageSize textureOptions:self.outputTextureOptions onlyTexture:YES];
    
    // 绑定纹理数据
    glBindTexture(GL_TEXTURE_2D, [outputFramebuffer texture]);
    glTexImage2D(GL_TEXTURE_2D, 0, _pixelFormat, (int)uploadedImageSize.width, (int)uploadedImageSize.height, 0, (GLint)_pixelFormat, (GLenum)_pixelType, bytesToUpload);
}

//在其它方法中比较重要的是数据处理方法，它的主要作用是驱动响应链，也就是将读取的RawData数据传递给接下来的targets进行处理。
- (void)updateDataFromBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
{
    uploadedImageSize = imageSize;

    [self uploadBytes:bytesToUpload];
}

// 数据处理
- (void)processData;
{
    if (dispatch_semaphore_wait(dataUpdateSemaphore, DISPATCH_TIME_NOW) != 0)
    {
        return;
    }
    
    runAsynchronouslyOnVideoProcessingQueue(^{
        
        CGSize pixelSizeOfImage = [self outputImageSize];
        
        // 遍历所有的targets，将outputFramebuffer交给每个target处理
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:pixelSizeOfImage atIndex:textureIndexOfTarget];
            // 将输出的帧缓存设置给每一个target
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:textureIndexOfTarget];
            [currentTarget newFrameReadyAtTime:kCMTimeInvalid atIndex:textureIndexOfTarget];
        }
        
        dispatch_semaphore_signal(dataUpdateSemaphore);
    });
}
// 数据处理
- (void)processDataForTimestamp:(CMTime)frameTime;
{
	if (dispatch_semaphore_wait(dataUpdateSemaphore, DISPATCH_TIME_NOW) != 0)
    {
        return;
    }
	
	runAsynchronouslyOnVideoProcessingQueue(^{
        
		CGSize pixelSizeOfImage = [self outputImageSize];
        
		for (id<GPUImageInput> currentTarget in targets)
		{
			NSInteger indexOfObject = [targets indexOfObject:currentTarget];
			NSInteger textureIndexOfTarget = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
			[currentTarget setInputSize:pixelSizeOfImage atIndex:textureIndexOfTarget];
			[currentTarget newFrameReadyAtTime:frameTime atIndex:textureIndexOfTarget];
		}
        
		dispatch_semaphore_signal(dataUpdateSemaphore);
	});
}

- (CGSize)outputImageSize;
{
    return uploadedImageSize;
}

@end
