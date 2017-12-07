
//
//  MutipleFilterVC.m
//  GPUImageDemo
//
//  Created by LiYang on 2017/12/6.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "MutipleFilterVC.h"
#import  <GPUImage.h>

@interface MutipleFilterVC ()

@property (nonatomic, strong) GPUImagePicture    *pic1;
@property (nonatomic, strong) GPUImagePicture    *pic2;
@property (nonatomic, strong) GPUImagePicture    *pic3;

@property (nonatomic, strong)GPUImageView      *imageView;

@end

@implementation MutipleFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(30, 100, 300, 350)];
    [self.view addSubview:self.imageView];


}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self generatePic];
    
}
- (void)generatePic {
    
    UIImage * img1 = [UIImage imageNamed:@"girl1"];
    UIImage * img2 = [UIImage imageNamed:@"girl3"];
    UIImage * img3 = [UIImage imageNamed:@"girl1"];

    self.pic1 = [[GPUImagePicture alloc] initWithImage:img1];
    self.pic2 = [[GPUImagePicture alloc] initWithImage:img2];
    self.pic3 = [[GPUImagePicture alloc] initWithImage:img3];
    
    
    //经过的渠道(filter)
   GPUImageBrightnessFilter * brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
    [brightnessFilter setBrightness:0.2];
    
    GPUImageSoftLightBlendFilter *  softLightBlendFilter = [[GPUImageSoftLightBlendFilter alloc] init];
    
    GPUImageiOSBlurFilter * blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    [blurFilter setBlurRadiusInPixels:-12.0f];
    
    [_pic1 addTarget:brightnessFilter];
    
    [brightnessFilter addTarget:blurFilter];
    [_pic3 addTarget:blurFilter];
    [blurFilter addTarget:softLightBlendFilter];
    [_pic2 addTarget:softLightBlendFilter];
    
    [softLightBlendFilter addTarget:_imageView];//imageview是一个GPUImageView,用来显示结果的
    
    [_pic3 processImage];
    [_pic2 processImage];
    [_pic1 processImage];
    
    
    
}




@end
