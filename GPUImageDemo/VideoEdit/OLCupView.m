//
//  OLCupView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/9.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCupView.h"

@interface OLCupView()

@end

@implementation OLCupView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width  = CGRectGetWidth(self.frame);
    
    CGFloat Big_Offset = 40.0;
    CGFloat Small_Offset = 80.0;
    
    [[UIColor blackColor] setFill];
    [[UIColor blueColor] setStroke];
    
    /**创建椭圆形的贝塞尔曲线*/
    UIBezierPath *_ovalPath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(Big_Offset, 10, width - 2*Big_Offset, 100)];
    [_ovalPath setLineWidth:2.0f];
    [_ovalPath stroke];
    
    
    /**创建椭圆形的贝塞尔曲线*/
    UIBezierPath *_ovalPath2=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(Small_Offset, 100 + 100, width - 2*Small_Offset, 80)];
    [_ovalPath setLineWidth:2.0f];
    [_ovalPath2 stroke];
    
    [[UIColor redColor] setStroke];
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath setLineWidth:2.0];
    [linePath moveToPoint:CGPointMake(Big_Offset, 50)];
    [linePath addLineToPoint:CGPointMake(Small_Offset, 10 + 100 + 100+40)];
    [linePath stroke];
    
    UIBezierPath *linePath2 = [UIBezierPath bezierPath];
    [linePath2 setLineWidth:2.0];
    [linePath2 moveToPoint:CGPointMake(-Big_Offset+width, 50)];
    [linePath2 addLineToPoint:CGPointMake(-Small_Offset+width, 10 + 100 + 100+40)];
    [linePath2 stroke];
    
    
    UIBezierPath *_shapePath =[UIBezierPath bezierPathWithArcCenter:CGPointMake(50, 50) radius:30.0 startAngle:0 endAngle:3.14*2 clockwise:YES];
    /**创建带形状的图层*/
    CAShapeLayer *_shapeLayer=[CAShapeLayer layer];
    _shapeLayer.frame=CGRectMake(0, 0, width, height);
    _shapeLayer.position=self.center;
    
    /**注意:图层之间与贝塞尔曲线之间通过path进行关联*/
    _shapeLayer.path=_shapePath.CGPath;
    _shapeLayer.fillColor=[UIColor redColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
    
    
}
@end
