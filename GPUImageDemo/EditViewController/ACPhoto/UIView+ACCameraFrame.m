//
//  UIView+ACCameraFrame.m
//  CameraDemo
//
//  Created by NicoLin on 2017/12/28.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "UIView+ACCameraFrame.h"

@implementation UIView (ACCameraFrame)

- (void)setCa_x:(CGFloat)ca_x {
    CGRect frame = self.frame;
    frame.origin.x = ca_x;
    self.frame = frame;
}
- (void)setCa_y:(CGFloat)ca_y {
    CGRect frame = self.frame;
    frame.origin.y = ca_y;
    self.frame = frame;
}
- (void)setCa_width:(CGFloat)ca_width {
    CGRect frame = self.frame;
    frame.size.width = ca_width;
    self.frame = frame;
}
- (void)setCa_height:(CGFloat)ca_height {
    CGRect frame = self.frame;
    frame.size.height = ca_height;
    self.frame = frame;
}
- (void)setCa_size:(CGSize)ca_size {
    CGRect frame = self.frame;
    frame.size = ca_size;
    self.frame = frame;
}
- (void)setCa_origin:(CGPoint)ca_origin {
    CGRect frame = self.frame;
    frame.origin = ca_origin;
    self.frame = frame;
}
- (void)setCa_centerX:(CGFloat)ca_centerX {
    self.center = CGPointMake(ca_centerX, self.center.y);

}
- (void)setCa_centerY:(CGFloat)ca_centerY {
    self.center = CGPointMake(self.center.x, ca_centerY);

}
- (void)setCa_center:(CGPoint)ca_center {
    self.center = CGPointMake(ca_center.x, ca_center.y);

}

- (CGPoint)ca_center {
    return self.center;
}
- (CGFloat)ca_centerX{
    return self.center.x;
}
- (CGFloat)ca_centerY {
    return self.center.y;
}

- (CGFloat)ca_x{
    return self.frame.origin.x;
}
- (CGFloat)ca_y {
    return self.frame.origin.y;

}
- (CGFloat)ca_width {
    return self.frame.size.width;

}
- (CGFloat)ca_height {
    return self.frame.size.height;

}
- (CGPoint)ca_origin {
    return self.frame.origin;

}
- (CGSize)ca_size {
    return self.frame.size;
}

@end
