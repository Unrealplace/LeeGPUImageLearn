//
//  ManulFilterVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/4.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "ManulFilterVC.h"
#import <GPUImage.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ManulFilterVC ()

@end

@implementation ManulFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"点我试试看";

    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self manulFilter];
    [self SingleimageFilter];
    
    
}
//这是手动操作滤镜，可以添加多个滤镜

- (void) manulFilter {
    UIImage *inputImage = [UIImage imageNamed:@"girl1"];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];//告诉滤镜以后用它，节省内存
    [stillImageSource processImage];//滤镜渲染
    
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];//从当前滤镜缓冲区获取滤镜图片
    
    UIImageView *imagev=[[UIImageView alloc]initWithImage:currentFilteredVideoFrame];
    imagev.frame=self.view.frame;
    [self.view addSubview:imagev];
}

//给图片添加单个滤镜，自动添加滤镜
- (void)SingleimageFilter {
    UIImage *inputImage = [UIImage imageNamed:@"girl2"];
    GPUImageSepiaFilter *stillImageFilter2 = [[GPUImageSepiaFilter alloc] init];
    UIImage *currentFilteredVideoFrame = [stillImageFilter2 imageByFilteringImage:inputImage];
    UIImageView *imagev=[[UIImageView alloc]initWithImage:currentFilteredVideoFrame];
    imagev.frame=self.view.frame;
    [self.view addSubview:imagev];
    
}


@end
