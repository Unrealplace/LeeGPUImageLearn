#import <UIKit/UIKit.h>
#import "GPUImageContext.h"

typedef enum {
    kGPUImageFillModeStretch,                       //拉伸以填充整个视图，这可能会使图像在正常高宽比之外变形
    kGPUImageFillModePreserveAspectRatio,           // 保持源图像的宽高比，添加指定背景色的条在上面
    kGPUImageFillModePreserveAspectRatioAndFill     // 保持源图像的宽高比，放大其中心以填充视图
} GPUImageFillModeType; 


//从名称就可以知道GPUImageView是GPUImage框架中显示图片相关的类。
//GPUImageView实现了GPUImageInput协议，从而可以知道它能够接受GPUImageFramebuffer的输入。
//因此，常常作为响应链的终端节点，用于显示处理后的帧缓存。
//GPUImageView这个涉及了比较多的OpenGL ES的知识，在这里不会说太多OpenGL ES的知识。


@interface GPUImageView : UIView <GPUImageInput>
{
    GPUImageRotationMode inputRotation; // 输入的方向
}

/** 填充模式决定图像如何适合视图，默认为kGPUImageFillModePreserveAspectRatio
 The fill mode dictates how images are fit in the view, with the default being kGPUImageFillModePreserveAspectRatio
 */
@property(readwrite, nonatomic) GPUImageFillModeType fillMode;

/**
 这将计算当前的显示大小（以像素为单位），同时考虑视网膜比例因子
 This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;

@property(nonatomic) BOOL enabled;

/** Handling fill mode
 
 @param redComponent Red component for background color
 @param greenComponent Green component for background color
 @param blueComponent Blue component for background color
 @param alphaComponent Alpha component for background color
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

@end
