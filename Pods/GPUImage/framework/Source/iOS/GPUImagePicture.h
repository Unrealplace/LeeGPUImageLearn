#import <UIKit/UIKit.h>
#import "GPUImageOutput.h"



//从名称就可以知道GPUImagePicture是GPUImage框架中处理与图片相关的类，它的主要作用是将UIImage或CGImage转化为纹理对象。
//GPUImagePicture继承自GPUImageOutput，从而可以知道它能够作为输出，由于它没有实现GPUImageInput协议，不能处理输入。
//因此，常常作为响应链源。


@interface GPUImagePicture : GPUImageOutput
{
    CGSize pixelSizeOfImage; // 图片的尺寸
    BOOL hasProcessedImage; // 是否生成图片
    
    dispatch_semaphore_t imageUpdateSemaphore; 
}

// 通过图片URL初始化
- (id)initWithURL:(NSURL *)url;

// 通过UIImage或CGImage初始化
- (id)initWithImage:(UIImage *)newImageSource;
- (id)initWithCGImage:(CGImageRef)newImageSource;

// 通过UIImage或CGImage、是否平滑缩放输出来初始化
- (id)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;
- (id)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput;

// 通过UIImage或CGImage、是否去除预乘alpha来初始化
- (id)initWithImage:(UIImage *)newImageSource removePremultiplication:(BOOL)removePremultiplication;
- (id)initWithCGImage:(CGImageRef)newImageSource removePremultiplication:(BOOL)removePremultiplication;

// 通过UIImage或CGImage、是否平滑缩放、是否去除预乘alpha来初始化
- (id)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;
- (id)initWithCGImage:(CGImageRef)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput removePremultiplication:(BOOL)removePremultiplication;


// 处理图片
- (void)processImage;
// 输出图片大小，由于图像大小可能被调整（详见初始化方法）。因此，提供了获取图像大小的方法。
- (CGSize)outputImageSize;

/**
 *异步处理所有目标和过滤器的图像
 完成处理程序在处理完成后调用
 * GPU的调度队列 - 只有当这个方法没有返回NO。
 *
 */
- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion;
- (void)processImageUpToFilter:(GPUImageOutput<GPUImageInput> *)finalFilterInChain withCompletionHandler:(void (^)(UIImage *processedImage))block;

@end
