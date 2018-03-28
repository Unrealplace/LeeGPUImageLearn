//
//  OLCameraView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraView.h"
#import <GPUImage.h>

@interface OLCameraView()

/**
 视频采集镜头
 */
@property (nonatomic,strong)GPUImageVideoCamera *videoCamera;

/**
 显示渲染后的视频
 */
@property (nonatomic,strong)GPUImageView *videoShowView;

@end
@implementation OLCameraView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


@end
