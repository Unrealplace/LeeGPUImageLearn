#import "GPUImageOutput.h"

//GPUImageTextureInput继承自GPUImageOutput，
//可以用传入的纹理生成帧缓存对象。因此，可以作为响应链源使用。
@interface GPUImageTextureInput : GPUImageOutput
{
    CGSize textureSize;
}

//构造方法。构造方法只有一个，接收的参数是纹理对象和纹理大小。
- (id)initWithTexture:(GLuint)newInputTexture size:(CGSize)newTextureSize;

// Image rendering
- (void)processTextureWithFrameTime:(CMTime)frameTime;

@end
