//
//  OLArcView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/9.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLArcView.h"

@interface OLArcView()
@property (nonatomic,strong)UIButton *headBtn;
@end
@implementation OLArcView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.headBtn = [UIButton new];
    self.headBtn.backgroundColor = [UIColor blueColor];
    self.headBtn.frame = CGRectMake(0, 0, 50.0, 50.0);
    self.headBtn.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height - 50.0 - 25.0);
    self.headBtn.layer.cornerRadius = 25.0f;
    self.headBtn.layer.masksToBounds = YES;
    [self addSubview:self.headBtn];
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat offset = height - 50.0f;
    // 根据公式计算半径
    CGFloat r = (pow(width / 2, 2) - pow(16.0f, 2)) / (2 * 16.0f);
    CGFloat angle = asin(sin(width / 2 / r)) * M_PI * 2; //反正旋函数计算角度
    CGFloat sector = angle * 2;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    CGContextAddArc(context,
                    width / 2 ,
                    -r + offset-16.0f,
                    r,
                    M_PI_2 - angle,
                    M_PI_2 - angle + sector,
                    NO);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}


@end
