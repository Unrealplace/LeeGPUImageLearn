//
//  OLCamearSettingManager.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCamearSettingManager.h"

@implementation OLCamearSettingManager

+ (instancetype)shareInstance {
    static OLCamearSettingManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OLCamearSettingManager alloc] init];
    });
    return manager;
}

- (CGSize)getMovieRecordSize {
    return CGSizeMake(480, 640);
}
@end
