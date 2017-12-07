//
//  TakePhotoVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/4.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "TakePhotoVC.h"
#import <GPUImage.h>

@interface TakePhotoVC (){
    GPUImageView * filterView;
    
}

@property (nonatomic, strong)GPUImageStillCamera * stillCamera;

@end

@implementation TakePhotoVC
- (void)loadView{
    filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)];
    self.view = filterView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self takePhoto];

}

- (void)takePhoto {
    GPUImageStillCamera *  stillCamera = [[GPUImageStillCamera alloc] init];
    
    self.stillCamera=stillCamera;
    stillCamera.outputImageOrientation =UIInterfaceOrientationPortrait;
    
    GPUImageGammaFilter*  filter = [[GPUImageGammaFilter alloc] init];
    [stillCamera addTarget:filter];
//    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    [stillCamera startCameraCapture];
    
}

@end
