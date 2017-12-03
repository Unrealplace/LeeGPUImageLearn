//
//  FilteringlivevideoVC.m
//  GPUImageDemo
//
//  Created by LiYang on 2017/12/3.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "FilteringlivevideoVC.h"
#import <GPUImage.h>

@interface FilteringlivevideoVC ()

@end

@implementation FilteringlivevideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    GPUImageVideoCamera *videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    GPUImageFilter *customFilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"CustomShader"];
    GPUImageView *filteredVideoView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 200)];
    
    // Add the view somewhere so it's visible
    
    [videoCamera addTarget:customFilter];
    [customFilter addTarget:filteredVideoView];
    
    [videoCamera startCameraCapture];

}




@end
