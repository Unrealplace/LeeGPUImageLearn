//
//  VideoEditViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "VideoEditViewController.h"
#import <GPUImage.h>

@interface VideoEditViewController ()

@property (nonatomic,strong)GPUImageVideoCamera * camera;
@property (nonatomic,strong)GPUImageView *cameraScreen;
@property (nonatomic,strong)GPUImageMovieWriter *movieWriter;
@property (nonatomic,strong)GPUImageHistogramFilter *defaultFilter;
@property (nonatomic,strong)UIButton *recordBtn;//录制用的按钮

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    //创建摄像头
    
    _camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
               
                                                  cameraPosition:AVCaptureDevicePositionBack];
    //输出图像旋转方式
    _camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    _camera.horizontallyMirrorFrontFacingCamera = YES;
    //该句可防止允许声音通过的情况下，避免录制第一帧黑屏闪屏(====)
    [_camera addAudioInputsAndOutputs];
    //创建摄像头显示视图
    _cameraScreen = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    
    //显示模式充满整个边框
    _cameraScreen.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    _cameraScreen.clipsToBounds = YES;
    [_cameraScreen.layer setMasksToBounds:YES];
    
    [_camera addTarget:self.cameraScreen];
    
    [self.camera addTarget:self.defaultFilter];
    [self.defaultFilter addTarget:self.cameraScreen];
    
    [self.view addSubview:self.cameraScreen];
    
    //配置录制器

    GPUImagePixellateFilter *  pixellateFilter = [[GPUImagePixellateFilter alloc] init];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mp4"];
    unlink([pathToMovie UTF8String]);
    NSURL *willSaveURL = [NSURL fileURLWithPath:pathToMovie];
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:willSaveURL size:CGSizeMake(640.0, 640.0)];
    
    
    
    //开启声音采集
    
    //    _movieWriter.hasAudioTrack = YES;
    
    //    [self.camera addAudioInputsAndOutputs];
    
    //    self.camera.audioEncodingTarget = _movieWriter;
    
    
    _movieWriter.encodingLiveVideo = YES;
    _movieWriter.shouldPassthroughAudio = YES;
//    _movieWriter.hasAudioTrack=YES;
    
    //设置录制视频滤镜
    
    [pixellateFilter addTarget:_movieWriter];
    
//    self.camera.audioEncodingTarget = _movieWriter;
    
    //开始录制
    
    [_movieWriter startRecording];
    
    
    
    //录制完毕回调
    
    [self.movieWriter setCompletionBlock:^{
        
        NSLog(@"finish record");
    }];
    
    [_camera startCameraCapture];

    
}

- (UIButton*)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [UIButton new];
        _recordBtn.backgroundColor = [UIColor redColor];
        _recordBtn.frame = CGRectMake(0, 0, 50, 50);
        [_recordBtn setTitle:@"开始" forState:UIControlStateNormal];
        [_recordBtn setTitle:@"停止" forState:UIControlStateSelected];
    }
    return _recordBtn;
}

- (GPUImageHistogramFilter*)defaultFilter {
    if (!_defaultFilter) {
        _defaultFilter = [[GPUImageHistogramFilter alloc] init];
    }
    return _defaultFilter;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.movieWriter finishRecording];
}


@end
