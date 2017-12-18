//
//  PinpleAndGroupVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/18.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "PinpleAndGroupVC.h"
#import <GPUImage.h>

@interface PinpleAndGroupVC ()
@property (nonatomic,strong)GPUImageFilterPipeline * pipleLine;
@property (nonatomic,strong)GPUImageView * pipleLineOutPutImageView;

@end

@implementation PinpleAndGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pipleLineOutPutImageView];
    

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self configFilter];
}
- (GPUImageView *)pipleLineOutPutImageView {
    if (!_pipleLineOutPutImageView) {
        _pipleLineOutPutImageView = [[GPUImageView alloc] init];
        _pipleLineOutPutImageView.frame = CGRectMake(0, 74, 100, 100);
    }
    return _pipleLineOutPutImageView;
    
}
// 直接配置滤镜。
- (void)configFilter {
    // 加载图片
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"cat1"]];
    
    // filters
    GPUImageRGBFilter *rgbFilter = [[GPUImageRGBFilter alloc] init];
    GPUImagePerlinNoiseFilter *noiseFilter = [[GPUImagePerlinNoiseFilter alloc] init];
    // 配置文件
    NSArray *filters = @[rgbFilter, noiseFilter];
    // 滤镜组合
    _pipleLine = [[GPUImageFilterPipeline alloc] initWithOrderedFilters:filters input:picture output:_pipleLineOutPutImageView];
    [picture processImage];
    
}

@end
