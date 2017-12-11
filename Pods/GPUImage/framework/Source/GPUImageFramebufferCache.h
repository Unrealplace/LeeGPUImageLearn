#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "GPUImageFramebuffer.h"

@interface GPUImageFramebufferCache : NSObject

//方法列表。主要涉及到在缓存中查找 GPUImageFramebuffer，
//将 GPUImageFramebuffer 加入缓存，清空缓存等相关方法。
// Framebuffer management
- (GPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(GPUTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
- (GPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
- (void)returnFramebufferToCache:(GPUImageFramebuffer *)framebuffer;
//清除所有的缓存
- (void)purgeAllUnassignedFramebuffers;
- (void)addFramebufferToActiveImageCaptureList:(GPUImageFramebuffer *)framebuffer;
- (void)removeFramebufferFromActiveImageCaptureList:(GPUImageFramebuffer *)framebuffer;

@end
