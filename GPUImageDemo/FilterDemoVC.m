//
//  FilterDemoVC.m
//  GPUImageDemo
//
//  Created by LiYang on 2017/12/3.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "FilterDemoVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface FilterDemoVC (){
    
    UIImageView * fliterImageView;
    UIImageView * filterImageView1;
    UIButton       * filterButton;
    
}

@end

@implementation FilterDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    filterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fliterImageView  = [UIImageView new];
    [self.view addSubview:filterButton];
    [self.view addSubview:fliterImageView];
    [filterButton setTitle:@"滤镜" forState:UIControlStateNormal];
    filterButton.backgroundColor = [UIColor blueColor];
    filterButton.frame = CGRectMake(100, 100, 100, 30);
    filterImageView1  = [UIImageView new];
    filterImageView1.frame = CGRectMake(100, 300, 200, 300);
    [self.view addSubview:filterImageView1];

    fliterImageView.image = [UIImage imageNamed:@"girl1"];
    fliterImageView.frame = CGRectMake(100, 140, 200, 200*fliterImageView.image.size.height/fliterImageView.image.size.width);
    

    [[filterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        //源图
        CIImage * newCIImage = [CIImage imageWithCGImage:fliterImageView.image.CGImage];
        //
        CIFilter  * filter = [CIFilter filterWithName:@"CIColorMonochrome"];
        NSLog(@"%@",[CIFilter filterNamesInCategory:kCICategoryColorEffect]);//注意此处两个输出语句的重要作用
        NSLog(@"%@",filter.attributes);
        [filter setValue:newCIImage forKey:kCIInputImageKey];
        
        [filter setValue:[CIColor colorWithRed:1.000 green:0.165 blue:0.176 alpha:1.000] forKey:kCIInputColorKey];
        CIImage *outImage = filter.outputImage;
        [self addFilterLinkerWithImage:outImage];
        [self addFilter];
    
    }];
    
    
    
    
}
//再次添加滤镜  形成滤镜链
- (void)addFilterLinkerWithImage:(CIImage *)image{
    
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(0.5) forKey:kCIInputIntensityKey];
    
    //    在这里创建上下文  把滤镜和图片进行合并
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef resultImage = [context createCGImage:filter.outputImage fromRect:filter.outputImage.extent];
    fliterImageView.image = [UIImage imageWithCGImage:resultImage];
    
}

- (void)addFilter{
    //获取毛玻璃图片
    CIImage * newImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"girl1"].CGImage];
    //获取滤镜，并设置（使用KVO键值输入）
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputImage", newImage, @"inputRadius", @1.0f, nil];
    //从滤镜中获取图片
    CIImage *result = filter.outputImage;
    filterImageView1.image = [UIImage imageWithCIImage:result];
    //将图片添加到filterImageView上
//    self.filterImageView.image = filterImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
