//
//  LookUpFilter.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/1.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoInputFilter.h"

@interface LookUpFilter : TwoInputFilter

{
    GLint intensityUniform;
}

@property(readwrite, nonatomic) CGFloat intensity;

@end
