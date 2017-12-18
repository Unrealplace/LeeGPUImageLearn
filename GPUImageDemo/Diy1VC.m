//
//  Diy1VC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/18.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "Diy1VC.h"
#import "LEEDiyLightFilter.h"
#import <GPUImage.h>

@interface Diy1VC ()

@property (nonatomic,strong)GPUImageView * showImageView;

@end

@implementation Diy1VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.showImageView];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showImage];
    
}

- (void)showImage {
    // 加载图片
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"cat1"]];
    LEEDiyLightFilter *filter = [[LEEDiyLightFilter alloc] init];
    [picture addTarget:filter];
    [filter addTarget:_showImageView];
    [picture processImage];
    
}
- (GPUImageView *)showImageView {
    if (!_showImageView) {
        _showImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 74, 200, 200)];
    }
    return _showImageView;
}


@end
