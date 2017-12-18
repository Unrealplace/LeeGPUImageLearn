#import <Foundation/Foundation.h>
#import "GPUImageContext.h"

@protocol GPUImageTextureOutputDelegate;

//GPUImageTextureOutput继承自NSObject实现了GPUImageInput协议。
//它可以获取到输入的帧缓存中的纹理对象。
@interface GPUImageTextureOutput : NSObject <GPUImageInput>
{
    GPUImageFramebuffer *firstInputFramebuffer;
}

@property(readwrite, unsafe_unretained, nonatomic) id<GPUImageTextureOutputDelegate> delegate;
// 纹理对象
@property(readonly) GLuint texture;
// 是否启用
@property(nonatomic) BOOL enabled;

// 纹理使用完，解锁纹理对象
- (void)doneWithTexture;
@end

@protocol GPUImageTextureOutputDelegate
- (void)newFrameReadyFromTextureOutput:(GPUImageTextureOutput *)callbackTextureOutput;
@end
