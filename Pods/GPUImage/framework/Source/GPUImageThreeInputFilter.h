#import "GPUImageTwoInputFilter.h"

extern NSString *const kGPUImageThreeInputTextureVertexShaderString;

//GPUImageThreeInputFilter 可以接收三个帧缓存对象的输入。它的作用可以将三个帧缓存对象的输入合并成一个帧缓存对象的输出。
//它继承自GPUImageTwoInputFilter，与GPUImageTwoInputFilter类似，主要增加了第三个帧缓存对象处理的相关操作。
@interface GPUImageThreeInputFilter : GPUImageTwoInputFilter
{
    
    //实例变量。主要增加了与第三个帧缓存对象相关的实例变量。

    GPUImageFramebuffer *thirdInputFramebuffer;

    GLint filterThirdTextureCoordinateAttribute;
    GLint filterInputTextureUniform3;
    GPUImageRotationMode inputRotation3;
    GLuint filterSourceTexture3;
    CMTime thirdFrameTime;
    
    BOOL hasSetSecondTexture, hasReceivedThirdFrame, thirdFrameWasVideo;
    BOOL thirdFrameCheckDisabled;
}

- (void)disableThirdFrameCheck;

@end
