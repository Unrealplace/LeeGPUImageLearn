//
//  TwoInputFilter.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/2/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface TwoInputFilter : GPUImageFilter
{
    GPUImageFramebuffer *secondInputFramebuffer;
    
    GLint filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    GPUImageRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
    
    GLint blendToSkyUniform;
    
}
@property(readwrite, nonatomic) BOOL blendToSky; //混合模式是否在天空效果中使用

@property (nonatomic, assign) BOOL firstInputStatic;
@property (nonatomic, assign) BOOL secondInputStatic;

- (void)disableFirstFrameCheck;
- (void)disableSecondFrameCheck;

@end
