//
//  OLDataShowViewController.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/11.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLRACBaseViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface OLDataShowViewController : OLRACBaseViewController

@property (nonatomic,strong)RACSubject *subject;

@end
