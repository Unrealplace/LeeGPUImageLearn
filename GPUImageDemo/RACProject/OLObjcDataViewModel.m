//
//  OLObjcDataViewModel.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/13.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLObjcDataViewModel.h"

@implementation OLObjcDataViewModel

- (NSArray*)racArray {
    if (!_racArray) {
        _racArray = @[@"meet you",@"nice",@"hello"];
    }
    return _racArray;
}

@end
