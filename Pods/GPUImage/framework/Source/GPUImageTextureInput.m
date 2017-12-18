#import "GPUImageTextureInput.h"

@implementation GPUImageTextureInput

#pragma mark -
#pragma mark Initialization and teardown

//构造的时候，主要是用传入的纹理生成帧缓存对象。

- (id)initWithTexture:(GLuint)newInputTexture size:(CGSize)newTextureSize;
{
    if (!(self = [super init]))
    {
        return nil;
    }

    // 设置上下文
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageContext useImageProcessingContext];
    });
    
    textureSize = newTextureSize;
    // 根据纹理 生产 输出的帧缓存 对象
    runSynchronouslyOnVideoProcessingQueue(^{
        outputFramebuffer = [[GPUImageFramebuffer alloc] initWithSize:newTextureSize overriddenTexture:newInputTexture];
    });
    
    return self;
}

#pragma mark -
#pragma mark Image rendering

//处理数据的过程就是将纹理生成的帧缓存对象传递给所有targets，驱动所有targets处理。

- (void)processTextureWithFrameTime:(CMTime)frameTime;
{
    runAsynchronouslyOnVideoProcessingQueue(^{
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger targetTextureIndex = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:textureSize atIndex:targetTextureIndex];
            // 传递帧缓存对象
            [currentTarget setInputFramebuffer:outputFramebuffer atIndex:targetTextureIndex];
            [currentTarget newFrameReadyAtTime:frameTime atIndex:targetTextureIndex];
        }
    });
}

@end
