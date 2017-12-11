
//
//  MutipleFilterVC.m
//  GPUImageDemo
//
//  Created by LiYang on 2017/12/6.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "MutipleFilterVC.h"
#import  <GPUImage.h>

@interface MutipleFilterVC ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) GPUImagePicture    *pic1;
@property (nonatomic, strong) GPUImagePicture    *pic2;
@property (nonatomic, strong) GPUImagePicture    *pic3;

@property (nonatomic, strong)GPUImageView      *imageView;

@property (nonatomic, strong)UIView            * showView;


@end

@implementation MutipleFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(30, 100, 300, 350)];
    [self.view addSubview:self.imageView];
    
    self.showView = [UIView new];
    [self.view addSubview:self.showView];
    self.showView.frame = CGRectMake(100, 100, 100, 100);
    self.showView.backgroundColor = [UIColor redColor];
    
    //rotation
    UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    rotation.cancelsTouchesInView = NO;
    rotation.delegate = self;
    self.showView.userInteractionEnabled = YES;
    [self.showView addGestureRecognizer:rotation];


}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self generatePic];
    
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

// 旋转手势事件
- (void)rotation:(UIRotationGestureRecognizer *)sender {
    
    // 注意：手势传递的旋转角度都是相对于最开始的位置
    
    CGFloat rotation = sender.rotation;
    
    self.showView.transform = CGAffineTransformRotate(self.showView.transform, rotation);
    
    // 复位
    sender.rotation = 0;
    
    NSLog(@"%s", __func__);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        return YES;
    }
    else if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        return YES;
        
    }
    else
    {
        return NO;
    }
    
}
@end
