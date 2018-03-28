//
//  OLCameraSaveManager.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OLCameraSaveManager : NSObject


/**
 视频写入地址URL
 */
+ (NSURL*)pathURLToWriter;

/**
 视频写入的路径
 */
+ (NSString*)pathToWriter;
/**
 压缩视频成功后的路径
 
 */
+ (NSString*)pathOfCompressMovie;


@end
