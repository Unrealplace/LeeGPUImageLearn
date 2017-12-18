#import "GPUImageOutput.h"


//GPUImageRawDataInput继承自GPUImageOutput，
//它可以接受RawData输入（包括：RGB、RGBA、BGRA、LUMINANCE数据）并生成帧缓存对象。

typedef enum {
	GPUPixelFormatBGRA = GL_BGRA,
	GPUPixelFormatRGBA = GL_RGBA,
	GPUPixelFormatRGB = GL_RGB,
    GPUPixelFormatLuminance = GL_LUMINANCE //亮度
} GPUPixelFormat;

typedef enum {
	GPUPixelTypeUByte = GL_UNSIGNED_BYTE,
	GPUPixelTypeFloat = GL_FLOAT
} GPUPixelType;

@interface GPUImageRawDataInput : GPUImageOutput
{
    CGSize uploadedImageSize;
	
	dispatch_semaphore_t dataUpdateSemaphore;
}

//构造方法。构造的时候主要是根据RawData数据指针，数据大小，以及数据格式进行构造。
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(GPUPixelFormat)pixelFormat;
- (id)initWithBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize pixelFormat:(GPUPixelFormat)pixelFormat type:(GPUPixelType)pixelType;

/** Input data pixel format
 */
@property (readwrite, nonatomic) GPUPixelFormat pixelFormat;
@property (readwrite, nonatomic) GPUPixelType   pixelType;

// 更新数据
- (void)updateDataFromBytes:(GLubyte *)bytesToUpload size:(CGSize)imageSize;
// 处理数据
- (void)processData;
- (void)processDataForTimestamp:(CMTime)frameTime;
// 输出纹理大小
- (CGSize)outputImageSize;


@end
