#import "GPUImageOutput.h"

//
//与GPUImagePicture类似可以作为响应链源。
//与GPUImagePicture不同的是，它的数据不是来自图片，而是来自于UIView或CALayer的渲染结果，类似于对UIView或CALayer截图。
//GPUImageUIElement继承自GPUImageOutput，从而可以知道它能够作为输出，由于它没有实现GPUImageInput协议，不能处理输入。


//GPUImagePicture、 GPUImageView、GPUImageUIElement 这几类在处理图片、处理截屏、以及显示图片方面会经常用到。
//因此，熟悉这几类对了解GPUImage框架有着重要的作用。


@interface GPUImageUIElement : GPUImageOutput

// Initialization and teardown
- (id)initWithView:(UIView *)inputView;
- (id)initWithLayer:(CALayer *)inputLayer;

// Layer management
- (CGSize)layerSizeInPixels;
- (void)update;
- (void)updateUsingCurrentTime;
- (void)updateWithTimestamp:(CMTime)frameTime;

@end
