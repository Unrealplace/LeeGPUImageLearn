//
//  OLCamearSettingManager.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OLCamearSettingManager : NSObject

+ (instancetype)shareInstance;


- (CGSize)getMovieRecordSize;



@end
