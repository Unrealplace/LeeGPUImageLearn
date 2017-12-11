//
//  TwoPicEditVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/11.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "TwoPicEditVC.h"
#import <GPUImage.h>

@interface TwoPicEditVC ()
@property (weak, nonatomic) IBOutlet GPUImageView *showGPUImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UISlider *leftSlider;
@property (weak, nonatomic) IBOutlet UISlider *rightSlider;

@property (nonatomic, strong)GPUImagePicture  * leftPic;
@property (nonatomic, strong)GPUImagePicture  * rightPic;
@property (nonatomic, strong)GPUImageOpacityFilter * opacityFilter;
@property (nonatomic, strong)GPUImageBrightnessFilter * brightNessFilter;
@property (nonatomic, strong)GPUImageTransformFilter * transFormFilter;

@property (nonatomic, strong)GPUImageChromaKeyBlendFilter  * blendFilter;


@end

@implementation TwoPicEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showGPUImageView.opaque = NO;
    self.showGPUImageView.fillMode = kGPUImageFillModeStretch;
    
    [self setUI];
    [self initFilterChain];
    
    
}

- (void)setUI {
    self.leftImageView.image  = [UIImage imageNamed:@"cat1"];
    self.rightImageView.image = [UIImage imageNamed:@"cat2"];
    self.leftImageView.contentMode = UIViewContentModeScaleToFill;
    self.rightImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.leftPic  = [[GPUImagePicture alloc] initWithImage:_leftImageView.image];
    self.rightPic = [[GPUImagePicture alloc] initWithImage:_rightImageView.image];
    
    
}

- (void)initFilterChain {
    
    [self.brightNessFilter addTarget:self.blendFilter];
    [self.opacityFilter addTarget:self.blendFilter];
    
    [self.blendFilter addTarget:self.showGPUImageView];
    
}


- (void)setLeftPic:(GPUImagePicture *)leftPic {
    if (_leftPic == leftPic) return;
    [_leftPic removeAllTargets];
    _leftPic = leftPic;
    [_leftPic addTarget:self.brightNessFilter ];
}

- (void)setRightPic:(GPUImagePicture *)rightPic {
    if (_rightPic == rightPic) return;
    [_rightPic removeAllTargets];
    _rightPic = rightPic;
    [_rightPic addTarget:self.opacityFilter];
}

- (GPUImageOpacityFilter*)opacityFilter {
    if (!_opacityFilter) {
        _opacityFilter = [[GPUImageOpacityFilter alloc] init];
        _opacityFilter.opacity = 1.0;
    }
    return _opacityFilter;
}
- (GPUImageTransformFilter *)transFormFilter {
    if (!_transFormFilter) {
        _transFormFilter = [[GPUImageTransformFilter alloc] init];
    }
    return _transFormFilter;
}
- (GPUImageBrightnessFilter*)brightNessFilter {
    if (!_brightNessFilter) {
        _brightNessFilter = [[GPUImageBrightnessFilter alloc] init];
    }
    return _brightNessFilter;
}

- (GPUImageChromaKeyBlendFilter *)blendFilter {
    if (!_blendFilter) {
        _blendFilter = [[GPUImageChromaKeyBlendFilter alloc] init];
    }
    return  _blendFilter;
}
- (IBAction)generaterPic:(id)sender {
}


- (IBAction)selectLeftImage:(id)sender {
    
}

- (IBAction)selectRightImage:(id)sender {
}

- (IBAction)leftSliderValueChange:(id)sender {
    
    UISlider * slider = (UISlider*)sender;
    self.brightNessFilter.brightness = slider.value;
    [self prosseInput];
    
}

- (IBAction)rightSliderValueChange:(id)sender {
    UISlider * slider = (UISlider*)sender;
    self.opacityFilter.opacity = slider.value;
    [self prosseInput];
    
}
- (void)prosseInput {
    [_rightPic processImageWithCompletionHandler:^{
        NSLog(@"完成了right 。。。。");
    }];
    [_leftPic processImageWithCompletionHandler:^{
        NSLog(@"完成了left。。。。");
    }];
}

@end
