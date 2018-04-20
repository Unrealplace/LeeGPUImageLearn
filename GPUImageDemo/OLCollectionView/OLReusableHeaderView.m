//
//  OLReusableHeaderView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/19.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLReusableHeaderView.h"

@implementation OLReusableHeaderView

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}
@end
