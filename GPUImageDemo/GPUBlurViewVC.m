//
//  GPUBlurView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/13.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "GPUBlurViewVC.h"
#import <GPUImage.h>
#import "ProsumerAsyncQueue.h"
#import "ACBlurView.h"

@interface GPUBlurViewVC ()

@property (nonatomic, strong)GPUImageView * blurView;

@property (nonatomic, strong)GPUImagePicture * blurPic;

@property (nonatomic, strong)GPUImageGaussianBlurFilter * blurFilter;

@property (nonatomic, strong)UISlider * blurSlider;

@property (nonatomic, strong)UIImageView * backGroundImageView;

@property (nonatomic, strong)ACBlurView  * acBlurView;

@end

@implementation GPUBlurViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backGroundImageView];
    [self.view addSubview:self.blurView];
//    [self.view addSubview:self.acBlurView];
    [self.view addSubview:self.blurSlider];
    self.acBlurView.blurEnabled = NO;
    self.blurSlider.frame = CGRectMake(50, self.view.bounds.size.height-50, self.blurSlider.bounds.size.width - 100, self.blurSlider.bounds.size.height);
    [self.blurFilter addTarget:self.blurView];
    self.blurPic = [[GPUImagePicture alloc] initWithImage:self.backGroundImageView.image];

}

- (GPUImageView *)blurView {
    if (!_blurView) {
        _blurView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
        _blurView.fillMode = kGPUImageFillModeStretch;
    }
    return _blurView;
}

- (void)setBlurPic:(GPUImagePicture *)blurPic {
    if (_blurPic == blurPic)return;
    _blurPic = blurPic;
    if (blurPic.targets) {
        [blurPic addTarget:self.blurFilter];
    }
}

- (GPUImageGaussianBlurFilter *)blurFilter {
    if (!_blurFilter) {
        _blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    }
    return _blurFilter;
}
- (UISlider *)blurSlider {
    if (!_blurSlider) {
        _blurSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        [_blurSlider addTarget:self action:@selector(blurSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_blurSlider addTarget:self action:@selector(blurSliderEnd:) forControlEvents:UIControlEventTouchCancel];
    }
    return _blurSlider;
}
- (UIImageView *)backGroundImageView {
    if (!_backGroundImageView ) {
        _backGroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _backGroundImageView.contentMode = UIViewContentModeScaleToFill;
        _backGroundImageView.image = [UIImage imageNamed:@"cat2"];
    }
    return _backGroundImageView;
}
- (ACBlurView *)acBlurView {
    if (!_acBlurView) {
        _acBlurView = [[ACBlurView alloc] initWithFrame:self.view.bounds];
        _acBlurView.blurRadius = 0.0;
        _acBlurView.updateInterval = 0.2;
        _acBlurView.tintColor = [UIColor clearColor];
    }
    return _acBlurView;
}
- (void)blurSliderEnd:(UISlider*)slider {
    self.acBlurView.blurEnabled = NO;
}
- (void)blurSliderValueChanged:(UISlider*)slider {
    
    NSLog(@"%lf",slider.value);
    if (slider.value <= 0.03) {
        self.blurView.hidden = YES;
        self.acBlurView.blurEnabled = NO;
        self.acBlurView.hidden = YES;
    }else {
//        self.acBlurView.hidden = NO;
//        self.acBlurView.blurEnabled = YES;
//        self.acBlurView.blurRadius  = slider.value * 60 ;
        self.blurView.hidden = NO;
        self.blurFilter.blurRadiusInPixels = slider.value * 80;
        [self.blurPic processImage];

//        [ProsumerAsyncQueue begin:^{
//
//        } dealWithValue:slider.value * 10 process:^{
//
//        } finishEvery:^{
//        } finishOnce:^{
//
//        }];
        
        
    }
    
}

@end
