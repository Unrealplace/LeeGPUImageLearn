//
//  OLCameraManager.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraManager.h"
#import <GPUImage.h>
#import "OLImageBeautyFilter.h"
#import "OLCameraRecordManager.h"

@interface OLCameraManager ()<GPUImageVideoCameraDelegate>

@property (nonatomic,assign)CGRect frame;

@property (nonatomic,strong)GPUImageVideoCamera *videoCamera;

@property (nonatomic,strong)GPUImageView *videoShowImageView;

@property (nonatomic,strong)OLImageBeautyFilter *beautyFilter;

@property (nonatomic,strong)OLCameraRecordManager *recordManager;

@end

@implementation OLCameraManager

- (void)dealloc {
    [self.videoCamera stopCameraCapture];
}

- (instancetype)init {
    if (self = [super init]) {
        
        [self.recordManager addTargetToRecordManager:self.beautyFilter];
        
    }
    return self;
}

- (void)showVideoViewWith:(CGRect)frame superView:(UIView *)superView {
    
    _frame = frame;
    [self.videoCamera addTarget:self.beautyFilter];
    [self.beautyFilter addTarget:self.videoShowImageView];
    [superView addSubview:self.videoShowImageView];
    [self.videoCamera stopCameraCapture];
    [self.videoCamera startCameraCapture];
}

- (GPUImageVideoCamera*)videoCamera {

    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
                                                           cameraPosition:AVCaptureDevicePositionFront];
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

- (OLImageBeautyFilter*)beautyFilter {
    if (!_beautyFilter) {
        _beautyFilter = [[OLImageBeautyFilter alloc] init];
    }
    return _beautyFilter;
}

- (OLCameraRecordManager*)recordManager {
    if (!_recordManager) {
        _recordManager = [[OLCameraRecordManager alloc] init];
    }
    return _recordManager;
}

- (void)startRecordVideo {
    
    [self.recordManager startRecord];
    
}

- (void)stopRecordVideo {
    
    [self.recordManager stopRecord];
    
}

#pragma mark videoCamera 代理方法
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    
}

@end
