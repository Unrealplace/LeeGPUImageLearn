//
//  OLReusableFooterView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/19.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLReusableFooterView.h"

@implementation OLReusableFooterView
- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor purpleColor];
    }
    return self;
}
@end
