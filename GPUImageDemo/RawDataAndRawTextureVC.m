//
//  RawDataAndRawTextureVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/18.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "RawDataAndRawTextureVC.h"
#import <GPUImage.h>
#import "LEEImageHelper.h"

@interface RawDataAndRawTextureVC ()

@property (nonatomic,strong)GPUImageView * showRawDataOutPutImageView;

@property (nonatomic,strong)GPUImageView * writeDataImageView;

@property (nonatomic,strong)UIImageView  * outPutImageView;

@property (nonatomic,strong)GPUImageRawDataInput * imageDataInput;

@property (nonatomic,strong)GPUImageRawDataInput * writeDataInput;

@property (nonatomic,assign)GLuint texture;

@property (nonatomic,strong)GPUImageView * textureOutPutImageView;

@property (nonatomic,strong)GPUImageView * outPutTextureFrameView;

@property (nonatomic,strong)UIImageView  * imageFromBufferView;




@end

@implementation RawDataAndRawTextureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.showRawDataOutPutImageView];
    [self.view addSubview:self.writeDataImageView];
    [self.view addSubview:self.outPutImageView];
    [self.view addSubview:self.textureOutPutImageView];
    [self.view addSubview:self.outPutTextureFrameView];
    [self.view addSubview:self.imageFromBufferView];


}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showPic];
    [self writePicToFile];
    [self generateTexture];
    [self outPutTextureFrame];
    
}

- (UIImageView *)imageFromBufferView {
    if (!_imageFromBufferView) {
        _imageFromBufferView = [UIImageView new];
        _imageFromBufferView.frame = CGRectMake(CGRectGetMaxX(self.outPutTextureFrameView.frame)+10, CGRectGetMaxY(self.textureOutPutImageView.frame)+10, 100, 100);
    }
    return _imageFromBufferView;
}
- (GPUImageView*)outPutTextureFrameView {
    if (!_outPutTextureFrameView) {
        _outPutTextureFrameView = [[GPUImageView alloc] init];
        _outPutTextureFrameView.frame = CGRectMake(0, 10 + CGRectGetMaxY(self.outPutImageView.frame), 100, 100);
    }
    return _outPutTextureFrameView;
}

- (GPUImageView*)textureOutPutImageView {
    
    if (!_textureOutPutImageView) {
        _textureOutPutImageView = [[GPUImageView alloc] init];
        _textureOutPutImageView.frame = CGRectMake(10 + CGRectGetMaxX(self.outPutImageView.frame), 10 + CGRectGetMaxY(self.writeDataImageView.frame), 100, 100);
    }
    return _textureOutPutImageView;
}
- (UIImageView *)outPutImageView {
    if (!_outPutImageView) {
        _outPutImageView = [[UIImageView alloc] init];
        _outPutImageView.frame = CGRectMake(0, 74+110, 100, 100);
    }
    return _outPutImageView;
}
- (GPUImageView*)writeDataImageView {
    if (!_writeDataImageView) {
        _writeDataImageView = [[GPUImageView alloc] init];
        _writeDataImageView.frame = CGRectMake(110, 74, 100, 100);
        _writeDataImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _writeDataImageView;
}
- (GPUImageView *)showRawDataOutPutImageView {
    if (!_showRawDataOutPutImageView) {
        _showRawDataOutPutImageView             = [[GPUImageView alloc] init];
        _showRawDataOutPutImageView.frame       = CGRectMake(0, 10+64, 100, 100);
        _showRawDataOutPutImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _showRawDataOutPutImageView;
}

//通过GPUImageRawDataInput加载图片。
//我们将图片转换为RGBA的数据格式，然后使用GPUImageRawDataInput加载并显示。
- (void)showPic {
    UIImage * pic = [UIImage imageNamed:@"girl1"];
    size_t width = CGImageGetWidth(pic.CGImage);
    size_t height = CGImageGetHeight(pic.CGImage);
    
    unsigned char * imageData = [LEEImageHelper convertUIImageToBitmapRGBA8:pic];
    
    self.imageDataInput  = [[GPUImageRawDataInput alloc] initWithBytes:imageData size:CGSizeMake(width, height) pixelFormat:GPUPixelFormatRGBA];
    
    // 滤镜
    GPUImagePosterizeFilter *filter = [[GPUImagePosterizeFilter alloc] init];
    [self.imageDataInput addTarget:filter];
    [filter addTarget:_showRawDataOutPutImageView];
    
    // 开始处理数据
    [self.imageDataInput processData];
    
    // 清理
    if (imageData) {
        free(imageData);
        pic = NULL;
    }
}
//通过GPUImageRawDataOutput输出RGBA数据。
//首先用GPUImageRawDataOutput生成RGBA原始数据，再利用libpng编码为png图片。

- (void)writePicToFile {
    
    // 加载纹理
    UIImage *image = [UIImage imageNamed:@"girl2"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    unsigned char *imageData = [LEEImageHelper convertUIImageToBitmapRGBA8:image];
    // 初始化GPUImageRawDataInput
    self.writeDataInput = [[GPUImageRawDataInput alloc] initWithBytes:imageData size:CGSizeMake(width, height) pixelFormat:GPUPixelFormatRGBA];
    // 滤镜
    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init];
    filter.saturation = 0.3;
    
    // GPUImageRawDataOutput
    GPUImageRawDataOutput *rawDataOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:CGSizeMake(width, height) resultsInBGRAFormat:NO];
    [rawDataOutput lockFramebufferForReading];
    
    [self.writeDataInput addTarget:filter];
    [filter addTarget:self.writeDataImageView];
    [filter addTarget:rawDataOutput];
    
    // 开始处理数据
    [self.writeDataInput processData];
    
    // 生成png图片
    unsigned char *rawBytes = [rawDataOutput rawBytesForImage];
//    pic_data pngData = {(int)width, (int)height, 8, PNG_HAVE_ALPHA, rawBytes};
//    write_png_file([DOCUMENT(@"raw_data_output.png") UTF8String], &pngData);
    
    UIImage * newImage = [LEEImageHelper convertBitmapRGBA8ToUIImage:rawBytes withWidth:(int)width withHeight:(int)height];
    
    self.outPutImageView.image = newImage;
    
    // 清理
    [rawDataOutput unlockFramebufferAfterReading];
    if (imageData) {
        free(imageData);
        image = NULL;
    }
    
//    NSLog(@"%@", DOCUMENT(@"raw_data_output.png"));
    
}
//利用GPUImageTextureInput读取图片。读取图片数据，然后生成纹理对象去构造GPUImageTextureInput。
- (void)generateTexture {
    
    // 加载纹理
    UIImage *image = [UIImage imageNamed:@"cat1"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    unsigned char *imageData = [LEEImageHelper convertUIImageToBitmapRGBA8:image];
    
    glGenTextures(1, &_texture);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    GPUImageTextureInput *textureInput = [[GPUImageTextureInput alloc] initWithTexture:_texture size:CGSizeMake(width, height)];
    [textureInput addTarget:self.textureOutPutImageView];
    [textureInput processTextureWithFrameTime:kCMTimeIndefinite];
    // 清理
    if (imageData) {
        free(imageData);
        image = NULL;
    }
    
}

//使用GPUImageTextureOutput生成纹理对象。
//先由GPUImageTextureOutput生成纹理对象，然后利用OpenGL ES绘制到帧缓存对象中，最后利用帧缓存对象生成图片。

- (void)outPutTextureFrame {
    NSString *const kVertexShaderString = SHADER_STRING
    (
     attribute vec4 position;
     attribute vec4 inputTextureCoordinate;
     
     varying vec2 textureCoordinate;
     
     void main()
     {
         gl_Position = position;
         textureCoordinate = inputTextureCoordinate.xy;
     }
     );
    
    NSString *const kFragmentShaderString = SHADER_STRING
    (
     varying highp vec2 textureCoordinate;
     
     uniform sampler2D inputImageTexture;
     
     void main()
     {
         gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
     }
     );
    
    UIImage *image = [UIImage imageNamed:@"cat2"];
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    
    // GPUImagePicture
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
    
    // GPUImageTextureOutput
    GPUImageTextureOutput *output = [[GPUImageTextureOutput alloc] init];
    
    [picture addTarget:output];
    [picture addTarget:self.outPutTextureFrameView];
    
    [picture processImage];
    
    // 生成图片
    runSynchronouslyOnContextQueue([GPUImageContext sharedImageProcessingContext], ^{
        // 设置程序
        GLProgram *progam = [[GPUImageContext sharedImageProcessingContext] programForVertexShaderString:kVertexShaderString fragmentShaderString:kFragmentShaderString];
        [progam addAttribute:@"position"];
        [progam addAttribute:@"inputTextureCoordinate"];
        
        // 激活程序
        [GPUImageContext setActiveShaderProgram:progam];
        [GPUImageContext useImageProcessingContext];
        
        // GPUImageFramebuffer
        GPUImageFramebuffer *frameBuffer = [[GPUImageContext sharedFramebufferCache] fetchFramebufferForSize:CGSizeMake(width, height) onlyTexture:NO];
        [frameBuffer lock];
        
        static const GLfloat imageVertices[] = {
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
        
        glClearColor(1.0, 1.0, 1.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT);
        glViewport(0, 0, (GLsizei)width, (GLsizei)height);
        
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, output.texture);
        
        glUniform1i([progam uniformIndex:@"inputImageTexture"], 2);
        
        glVertexAttribPointer([progam attributeIndex:@"position"], 2, GL_FLOAT, 0, 0, imageVertices);
        glVertexAttribPointer([progam attributeIndex:@"inputTextureCoordinate"], 2, GL_FLOAT, 0, 0, textureCoordinates);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        CGImageRef outImage = [frameBuffer newCGImageFromFramebufferContents];
        NSData *pngData = UIImagePNGRepresentation([UIImage imageWithCGImage:outImage]);
        
        self.imageFromBufferView.image = [UIImage imageWithData:pngData];
        
//        [pngData writeToFile:DOCUMENT(@"texture_output.png") atomically:YES];
//
//        NSLog(@"%@", DOCUMENT(@"texture_output.png"));
        // unlock
        [frameBuffer unlock];
        [output doneWithTexture];
    });
    
    
}

@end
