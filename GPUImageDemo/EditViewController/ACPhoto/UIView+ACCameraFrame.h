//
//  UIView+ACCameraFrame.h
//  CameraDemo
//
//  Created by NicoLin on 2017/12/28.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ACCameraFrame)
@property (nonatomic, assign) CGFloat ca_x;
@property (nonatomic, assign) CGFloat ca_y;
@property (nonatomic, assign) CGFloat ca_width;
@property (nonatomic, assign) CGFloat ca_height;

@property (nonatomic, assign) CGPoint ca_origin;
@property (nonatomic, assign) CGSize  ca_size;
@property (nonatomic, assign) CGPoint ca_center;
@property (nonatomic, assign) CGFloat ca_centerX;
@property (nonatomic, assign) CGFloat ca_centerY;

@end
