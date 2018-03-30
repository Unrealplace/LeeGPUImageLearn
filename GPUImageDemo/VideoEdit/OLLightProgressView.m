//
//  OLLightProgressView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/30.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLLightProgressView.h"

@interface OLLightProgressView ()
@property (nonatomic,strong)UILabel * lightLabel;
@end

@implementation OLLightProgressView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.value = 0.5;
        self.lightLabel = [UILabel new];
        self.lightLabel.textColor = [UIColor whiteColor];
        self.lightLabel.frame = CGRectMake(-22,0, 30, 20);
        self.lightLabel.font  = [UIFont systemFontOfSize:10];
        [self addSubview:self.lightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    self.lightLabel.center = CGPointMake(self.lightLabel.center.x, self.bounds.size.height/2.0f);

}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat maxWidth  = CGRectGetWidth(self.frame);
    CGFloat maxHeight = CGRectGetHeight(self.frame);
    CGFloat maxProcessHeight = maxHeight;
    CGFloat light_w   = 13.0f;
    CGFloat line_w    = 2.0f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, maxWidth/2.0f-line_w/2.0f, 0);
    CGContextAddLineToPoint(context, maxWidth/2.0f-line_w/2.0f, maxProcessHeight*self.value - light_w);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage * lightImg = [UIImage imageNamed:@"cam_sign_brightness"];
    CGRect rectImage = CGRectMake(light_w/2.0f - line_w/2.0f, maxProcessHeight*self.value - light_w, light_w, light_w);
    [lightImg drawInRect:rectImage];
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextMoveToPoint(context, maxWidth/2.0f-line_w/2.0f, maxProcessHeight*self.value);
    CGContextAddLineToPoint(context, maxWidth/2.0f-line_w/2.0f, maxProcessHeight);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
}

- (void)setValue:(float)value {
    _value = value;
    self.lightLabel.text = [NSString stringWithFormat:@"%.1lf",_value*10.0];
    [self setNeedsDisplay];
}

@end
