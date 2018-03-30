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
#import "OLPasterElementView.h"
#import "OLLightProgressView.h"

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
 光照调节控件
 */
@property (nonatomic,strong)OLLightProgressView *lightProgressView;

/**
 录制滤镜
 */
@property (nonatomic,strong)GPUImageMovieWriter *movieWriter;

/*******滤镜组********/
@property (nonatomic,strong)OLImageBeautyFilter *beautyFilter;//美颜滤镜
@property (nonatomic,strong)GPUImageBrightnessFilter *brightnessFilter;//亮度滤镜

@property (nonatomic,strong)OLPasterElementView *dynamicPasterElementView;//动态贴纸纹理承载图层
@property (nonatomic,strong)GPUImageUIElement  *dynamicPasterUIElementFilter;//动态贴纸的滤镜
@property (nonatomic,strong)GPUImageOutput <GPUImageInput>* blendFilter;//混合模式滤镜

/*******滤镜组********/


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
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backToGround)
                                                     name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(comeToFront)
                                                     name:UIApplicationWillEnterForegroundNotification object:nil];
        
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
        [_videoShowImageView addSubview:self.lightProgressView];
        _lightProgressView.center = CGPointMake(_lightProgressView.center.x, _videoShowImageView.bounds.size.height/2.0f);
        
        UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTap:)];
        UIPanGestureRecognizer *lightSwip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(lightSwip:)];
        UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwip:)];
        UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwip:)];
        [leftSwip setDirection:UISwipeGestureRecognizerDirectionLeft];
        [rightSwip setDirection:UISwipeGestureRecognizerDirectionRight];
        
        [lightSwip requireGestureRecognizerToFail:leftSwip];
        [lightSwip requireGestureRecognizerToFail:rightSwip];
        
        [_videoShowImageView addGestureRecognizer:leftSwip];
        [_videoShowImageView addGestureRecognizer:rightSwip];
        [_videoShowImageView addGestureRecognizer:focusTap];
        [_videoShowImageView addGestureRecognizer:lightSwip];
    }
    return _videoShowImageView;
}

- (OLLightProgressView*)lightProgressView {
    if (!_lightProgressView) {
        _lightProgressView = [[OLLightProgressView alloc] init];
        _lightProgressView.frame = CGRectMake(CGRectGetWidth(self.videoShowImageView.frame) - 26*2, 0, 26, 160);
    }
    return _lightProgressView;
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

- (void)focusTap:(UITapGestureRecognizer*)sender {
    NSLog(@"foucs");
}

- (void)lightSwip:(UIPanGestureRecognizer*)pan {
    NSLog(@"light");
    
    UIGestureRecognizerState state = pan.state;
    CGPoint translation = [pan locationInView:self.videoShowImageView];
    CGFloat light_start_y;
    
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            light_start_y = translation.y;
        }
            break;
        case UIGestureRecognizerStateChanged:{
            self.lightProgressView.value = 0.8;
//            CGFloat chang_y = translation.y - light_start_y;
//            CGFloat height  = CGRectGetHeight(self.lightToolBar.frame);
//            CGFloat temp_y  = (_preLight_y + chang_y) / (_cameraManager.containView.union_h / height);
//            CGFloat maxProcessHeight = height;
//
//            CGFloat transtion_icon_y = temp_y;
//            if (temp_y <= 0.0f) {
//                temp_y = 0.0f;
//            } else if(temp_y >= maxProcessHeight){
//                temp_y = maxProcessHeight;
//            }
//
//            if (transtion_icon_y <=13.f) {
//                transtion_icon_y = 13.f;
//            } else if (transtion_icon_y >= maxProcessHeight - 13.f) {
//                transtion_icon_y = maxProcessHeight - 13.f;
//            }
//
//            self.lightToolBar.value =  temp_y / maxProcessHeight;
//            self.lightToolBar.lightIcon.transform = CGAffineTransformMakeTranslation(0, transtion_icon_y - maxProcessHeight / 2.);
//            self.lightToolBar.tipValueIcon.transform = CGAffineTransformMakeTranslation(0, transtion_icon_y - maxProcessHeight / 2.);
        }
            break;
        case UIGestureRecognizerStateEnded:{
//            _preLight_y += translation.y - _light_start_y;
            self.lightProgressView.value = 0.3;
            [UIView animateWithDuration:1 animations:^{
//                self.lightProgressView.alpha = 0.;
            }];
        }
            break;
        default:
            break;
    }
    
}

- (void)leftSwip:(UISwipeGestureRecognizer*)sender {
    NSLog(@"left");

}

- (void)rightSwip:(UISwipeGestureRecognizer*)sender {
    NSLog(@"right");
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
