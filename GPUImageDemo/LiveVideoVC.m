//
//  LiveVideoVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/4.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "LiveVideoVC.h"
#import <GPUImage.h>

@interface LiveVideoVC ()<GPUImageMovieDelegate,GPUImageMovieWriterDelegate>

@property (nonatomic, strong)GPUImageStillCamera * stillCamera;

@property (nonatomic, strong)GPUImageVideoCamera * videoCamera;



@end

@implementation LiveVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self liveVideo];

}

- (void)liveVideo {
    
    //第一个参数：相机捕获视屏或图片的质量.有一次啊选项
    /*AVCaptureSessionPresetPhoto
     AVCaptureSessionPresetHigh
     AVCaptureSessionPresetMedium
     AVCaptureSessionPresetLow
     AVCaptureSessionPreset320x240
     AVCaptureSessionPreset352x288
     AVCaptureSessionPreset640x480
     AVCaptureSessionPreset960x540
     AVCaptureSessionPreset1280x720
     AVCaptureSessionPreset1920x1080
     AVCaptureSessionPreset3840x2160
     AVCaptureSessionPresetiFrame960x540
     AVCaptureSessionPresetiFrame1280x720
     */
    //第二个参数相机的位置
    /*typedef NS_ENUM(NSInteger, AVCaptureDevicePosition) {
     AVCaptureDevicePositionUnspecified         = 0,
     AVCaptureDevicePositionBack                = 1,
     AVCaptureDevicePositionFront               = 2
     } NS_AVAILABLE(10_7, 4_0) __TVOS_PROHIBITED;
     */
    GPUImageVideoCamera * videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera = videoCamera;//这个相机一定要用一个强引用，防止销毁
    //设置下面这个后，倒转手机后，画面也会跟着倒过来
    videoCamera.horizontallyMirrorRearFacingCamera = NO;
    videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    /*捕获画面的方向设置，
     typedef NS_ENUM(NSInteger, UIInterfaceOrientation) {
     UIInterfaceOrientationUnknown            = UIDeviceOrientationUnknown,
     UIInterfaceOrientationPortrait           = UIDeviceOrientationPortrait,
     UIInterfaceOrientationPortraitUpsideDown = UIDeviceOrientationPortraitUpsideDown,
     UIInterfaceOrientationLandscapeLeft      = UIDeviceOrientationLandscapeRight,
     UIInterfaceOrientationLandscapeRight     = UIDeviceOrientationLandscapeLeft
     } __TVOS_PROHIBITED;
     */
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //创建滤镜
    GPUImageSepiaFilter * filter = [[GPUImageSepiaFilter alloc] init];
    //相机添加滤镜对象
    [videoCamera addTarget:filter];
    //创建滤镜显示的view
    GPUImageView *filterView=[[GPUImageView alloc]initWithFrame:CGRectMake(10,10, 300,300)];
    filterView.center = self.view.center;
    //如果要用控制器本身的view作滤镜显示view要把控制器的view强转成GPUIMageView，如果用的是storyBoard，storyboard中的相应地view类型名要改成GPUIMageview
    //    GPUImageView *filterView = (GPUImageView *)self.view;
    [self.view addSubview:filterView];//添加滤镜view到view上
    [filter addTarget:filterView];
    [videoCamera startCameraCapture];
    
    
    
    
}





@end
