//
//  OLViewModel.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface OLViewModel : NSObject

@property (nonatomic,strong)NSMutableArray * dataArray;

@property (nonatomic,strong)RACSubject *dataChangeSingle;

@end
