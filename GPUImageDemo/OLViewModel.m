//
//  OLViewModel.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLViewModel.h"

@implementation OLViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.dataArray = @[@"hello"].mutableCopy;
    }
    return self;
}

- (RACSubject*)dataChangeSingle {
    @weakify(self);
    if (!_dataChangeSingle) {
        _dataChangeSingle = [[RACSubject alloc] init];
        [_dataChangeSingle subscribeNext:^(id x) {
            @strongify(self);
            [self.dataArray replaceObjectAtIndex:0 withObject:x];
        }];
    }
    return _dataChangeSingle;
}

@end
