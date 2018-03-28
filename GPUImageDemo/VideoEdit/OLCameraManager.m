//
//  OLCameraManager.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraManager.h"
#import <GPUImage.h>

@interface OLCameraManager ()<GPUImageVideoCameraDelegate>

@property (nonatomic,assign)CGRect frame;

@property (nonatomic,strong)GPUImageVideoCamera *videoCamera;

@property (nonatomic,strong)GPUImageView *videoShowImageView;

@end

@implementation OLCameraManager

- (void)dealloc {
    [self.videoCamera stopCameraCapture];
}
- (void)showVideoViewWith:(CGRect)frame superView:(UIView *)superView {
    
    _frame = frame;
    [self.videoCamera addTarget:self.videoShowImageView];
    [superView addSubview:self.videoShowImageView];
    [self.videoCamera stopCameraCapture];
    [self.videoCamera startCameraCapture];
}

- (GPUImageVideoCamera*)videoCamera {

    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
        _videoCamera.delegate = self;
        // 可防止允许声音通过的情况下,避免第一帧黑屏
        [_videoCamera addAudioInputsAndOutputs];
    }
    return _videoCamera;
}

- (GPUImageView*)videoShowImageView {
    if (!_videoShowImageView) {
        _videoShowImageView = [[GPUImageView alloc] initWithFrame:self.frame];
        _videoShowImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    }
    return _videoShowImageView;
}

#pragma mark videoCamera 代理方法
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    
}

@end
