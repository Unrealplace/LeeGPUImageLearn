//
//  GroupFilterVC.m
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/4.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "GroupFilterVC.h"
#import <GPUImage.h>

@interface GroupFilterVC ()

@property (nonatomic, strong) GPUImageFilterGroup * filterGroup;


@end

@implementation GroupFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    

}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self addManyFilter];
    
}

- (void)addManyFilter {
    
    UIImage * sourceImage = [UIImage imageNamed:@"girl1"];
    
    GPUImagePicture * inputPicture = [[GPUImagePicture alloc] initWithImage:sourceImage smoothlyScaleOutput:YES];
    // 初始化 filterGroup
    GPUImageFilterGroup * filters  = [[GPUImageFilterGroup alloc] init];
    self.filterGroup = filters;
    [inputPicture addTarget:filters];
    
    GPUImageRGBFilter *filter1         = [[GPUImageRGBFilter alloc] init];
    GPUImageToonFilter *filter2        = [[GPUImageToonFilter alloc] init];
    GPUImageColorInvertFilter *filter3 = [[GPUImageColorInvertFilter alloc] init];
    GPUImageSepiaFilter       *filter4 = [[GPUImageSepiaFilter alloc] init];
    
    [self addFiltersGroups:filter1];
//    [self addFiltersGroups:filter2];
    [self addFiltersGroups:filter3];
//    [self addFiltersGroups:filter4];
    
    // 处理图片
    [inputPicture processImage];
    [_filterGroup useNextFrameForImageCapture];
    
    UIImage *imag= [_filterGroup imageFromCurrentFramebuffer];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:self.view.frame];
    imageV.image=imag;
    [self.view addSubview:imageV];

}
- (void) addFiltersGroups:(GPUImageOutput<GPUImageInput>*)filter {
    
    [self.filterGroup addFilter:filter];//滤镜组添加滤镜
    
    GPUImageOutput<GPUImageInput> *newTerminalFilter = filter;//新的结尾滤镜
    
    NSInteger count =self.filterGroup.filterCount;//滤镜组里面的滤镜数量
    
    if (count ==1)
    {
        self.filterGroup.initialFilters =@[newTerminalFilter];//在组里面处理滤镜
        self.filterGroup.terminalFilter = newTerminalFilter;//最后一个滤镜，即最上面的滤镜
        
    } else
    {
        GPUImageOutput<GPUImageInput> *terminalFilter    =self.filterGroup.terminalFilter;
        NSArray *initialFilters                          =self.filterGroup.initialFilters;
        
        [terminalFilter addTarget:newTerminalFilter];//逐层吧新的滤镜加到组里最上面
        self.filterGroup.initialFilters =@[initialFilters[0]];
        
        self.filterGroup.terminalFilter = newTerminalFilter;
    }
    
}



@end
