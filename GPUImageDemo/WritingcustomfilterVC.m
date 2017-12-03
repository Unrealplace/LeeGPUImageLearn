//
//  WritingcustomfilterVC.m
//  GPUImageDemo
//
//  Created by LiYang on 2017/12/3.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "WritingcustomfilterVC.h"
#import <GPUImage.h>

@interface WritingcustomfilterVC (){

UIImageView * showImageView;

}

@end

@implementation WritingcustomfilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    showImageView = [UIImageView new];
    [self.view addSubview:showImageView];
    showImageView.frame = CGRectMake(100, 100, 100, 200);
    
    UIImage *inputImage = [UIImage imageNamed:@"girl1.png"];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] initWithFragmentShaderFromFile:@"CustomShader"];
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentFramebuffer];
    
    
    showImageView.image = currentFilteredVideoFrame;
    
    
}




@end
