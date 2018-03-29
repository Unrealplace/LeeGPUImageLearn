//
//  OLCameraManager.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraManager.h"
#import "OLImageBeautyFilter.h"
#import "OLCameraSaveManager.h"
#import "OLCamearSettingManager.h"

#import <GPUImage.h>

@interface OLCameraManager ()<GPUImageVideoCameraDelegate,GPUImageMovieWriterDelegate>

@property (nonatomic,assign)CGRect frame;

/**
 捕获镜头
 */
@property (nonatomic,strong)GPUImageStillCamera *videoCamera;

/**
 输出显示层
 */
@property (nonatomic,strong)GPUImageView *videoShowImageView;

/**
 录制滤镜
 */
@property (nonatomic,strong)GPUImageMovieWriter *movieWriter;

@property (nonatomic,strong)OLImageBeautyFilter *beautyFilter;

/**
 镜头的代理对象
 */
@property (nonatomic,weak)id <OLCameraManagerDelegate> delegate;

@end

@implementation OLCameraManager

- (void)dealloc {
    [self.videoCamera stopCameraCapture];
    self.movieWriter.delegate = nil;
    self.videoCamera.delegate = nil;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeToFront) name:UIApplicationWillEnterForegroundNotification object:nil];
        
    }return self;
}

- (void)backToGround {
    [self.videoCamera pauseCameraCapture];
}

- (void)comeToFront {
    [self.videoCamera resumeCameraCapture];
}

- (void)showVideoViewWith:(CGRect)frame target:(id<OLCameraManagerDelegate>)delegate superView:(UIView *)superView {
    _frame = frame;
    _delegate = delegate;
    [self.videoCamera addTarget:self.beautyFilter];
    [self.beautyFilter addTarget:self.videoShowImageView];
    [superView addSubview:self.videoShowImageView];
    [self.videoCamera stopCameraCapture];
    [self.videoCamera startCameraCapture];
    
    
}

- (GPUImageVideoCamera*)videoCamera {

    if (!_videoCamera) {
        _videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
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


- (void)startRecordVideo {
    
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[OLCameraSaveManager pathURLToWriter]
                                                                size:[OLCamearSettingManager shareInstance].getMovieRecordSize];
        _movieWriter.encodingLiveVideo = YES;
        [_beautyFilter addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        [_movieWriter startRecording];
    
}

- (void)stopRecordVideo {
    
    [_movieWriter finishRecordingWithCompletionHandler:^{
        
        NSLog(@"finish");
    }];
    
}

- (void)captureSinglePhoto {
    
    [self.videoCamera capturePhotoAsJPEGProcessedUpToFilter:self.beautyFilter withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        UIImage * image = [UIImage imageWithData:processedJPEG];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cameraCapturePhoto:)]) {
            [self.delegate cameraCapturePhoto:image];
        }
    }];
    
}


#pragma mark movieWriter 代理方法
- (void)movieRecordingCompleted {
    
}

- (void)movieRecordingFailedWithError:(NSError*)error {
    
}
#pragma mark videoCamera 代理方法
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
    
}

@end
