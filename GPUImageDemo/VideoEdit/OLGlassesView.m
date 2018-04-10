//
//  OLGlassesView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/9.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLGlassesView.h"

#define Glass_R 40.0

@implementation OLGlassesView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    
    //获取画板宽高
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat width  = CGRectGetWidth(self.frame);
    
    CGFloat leftGlassX = width/4.0f;
    CGFloat rightGlassX = width * 3/4.0f;
    CGFloat GlassY = height/2.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor);
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] colorWithAlphaComponent:0.8].CGColor);
    
    CGContextAddArc(context,
                    leftGlassX,
                    GlassY,
                    Glass_R,
                    0,
                    2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);

    CGContextAddArc(context,
                    rightGlassX,
                    GlassY,
                    Glass_R,
                    0,
                    2 * M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);

    CGContextSetStrokeColorWithColor(context, [UIColor purpleColor].CGColor);
    CGContextSetLineWidth(context, 2.0f);
    CGContextMoveToPoint(context, leftGlassX + Glass_R , height/2.0f - 2);
    CGContextAddLineToPoint(context, width/2.0f - 15.0f, height/2.0f - 2);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGContextMoveToPoint(context, width/2.0f + 15.0f, height/2.0f - 2);
    CGContextAddLineToPoint(context, rightGlassX - Glass_R, height/2.0f - 2);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    /*画贝塞尔曲线*/
    //二次曲线
    CGContextMoveToPoint(context, width/2.0-15, height/2.0 - 2);//设置Path的起点
    CGContextAddQuadCurveToPoint(context, width/2.0f-7, height/2.0f+6, width/2.0, height/2.0+2);//设置贝塞尔曲线的控制点坐标和终点坐标
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, width/2.0, height/2.0+2);//设置Path的起点
    CGContextAddQuadCurveToPoint(context, width/2.0 + 7, height/2.0f+6, width/2.0 + 15.0, height/2.0-2);//设置贝塞尔曲线的控制点坐标和终点坐标
    CGContextStrokePath(context);
    
    
    
}

@end
