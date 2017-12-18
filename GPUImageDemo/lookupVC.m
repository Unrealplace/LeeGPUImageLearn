//
//  lookupVC.m
//  GPUImageDemo
//
//  Created by LiYang on 2017/12/18.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "lookupVC.h"
#import  <GPUImage.h>

@interface lookupVC ()

@property (nonatomic, strong) GPUImagePicture    *picture;
@property (nonatomic, strong) GPUImageLookupFilter    *filter;
@property (nonatomic, strong)GPUImageView      *showImageView;



@end

@implementation lookupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.showImageView];

    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setupFilter];
}

//GPUImageLookupFilter 可以做出很多风格滤镜效果，它的原理比较简单，但是功能却很强大。除了使用GPUImageLookupFilter外，还可以综合使用各种混合滤镜，做出许多很有意思的滤镜效果。在GPUImage中还内置了几种LookupFilter，它们分别是GPUImageAmatorkaFilter, GPUImageMissEtikateFilter, GPUImageSoftEleganceFilter它们的原理都是使用Color Lookup Tables，只是使用的纹理不同而已。


- (void)setupFilter {
    self.filter = [[GPUImageLookupFilter alloc] init];
    self.filter.intensity = 0.9f;
    [self.filter addTarget:self.showImageView];
    
    self.picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"test3"]];
    [self.picture addTarget:self.filter];
    [self.picture processImage];
    
    GPUImagePicture * lookup = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"lookup"]];
    [lookup addTarget:self.filter];
    [lookup processImage];
    
    
    
}
- (GPUImageView*)showImageView {
    if (!_showImageView) {
        _showImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.width)];
        _showImageView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        _showImageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    }
    return _showImageView;
}


@end
