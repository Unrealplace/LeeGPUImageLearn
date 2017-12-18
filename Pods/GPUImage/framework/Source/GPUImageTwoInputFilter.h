#import "GPUImageFilter.h"

extern NSString *const kGPUImageTwoInputTextureVertexShaderString;

//GPUImageTwoInputFilter 可以接收两个帧缓存对象的输入。
//它的作用可以将两个帧缓存对象的输入合并成一个帧缓存对象的输出。
//它继承自GPUImageFilter，因此，可以方便在滤镜链中使用。

@interface GPUImageTwoInputFilter : GPUImageFilter
{
    
//    实例变量。GPUImageTwoInputFilter最主要的特点就是增加了secondInputFramebuffer这个接收第二个帧缓存对象的实例变量，
//    同时，也增加了关于第二个帧缓存对象的其它相关参数。
    // 增加了一个 帧缓存，可以看父类中有个
    GPUImageFramebuffer *secondInputFramebuffer;

    GLint filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    GPUImageRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    // 控制两个帧缓存对象渲染的相关参数
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
}

- (void)disableFirstFrameCheck;
- (void)disableSecondFrameCheck;

@end
