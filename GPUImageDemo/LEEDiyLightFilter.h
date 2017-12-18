//
//  LEEDiyLightFilter.h
//  GPUImageDemo
//
//  Created by NicoLin on 2017/12/18.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface LEEDiyLightFilter : GPUImageFilter

@property (nonatomic, assign) GLfloat radius;
- (instancetype)init ;
@end
