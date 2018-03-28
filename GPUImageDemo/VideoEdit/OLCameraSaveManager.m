//
//  OLCameraSaveManager.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraSaveManager.h"

#define OL_COMPRESS_PATH [NSHomeDirectory() stringByAppendingFormat:@"/Documents/OLCompress"]
#define OL_SAVE_PATH [NSHomeDirectory() stringByAppendingFormat:@"/Documents/OLSave"]


@implementation OLCameraSaveManager



/**
 视频写入地址URL
 */
+ (NSURL*)pathURLToWriter {
    
    NSURL * pathUrl = [NSURL fileURLWithPath:[OL_SAVE_PATH stringByAppendingPathComponent:@"video.mp4"]];
    NSLog(@"writer--->%@",pathUrl);
    return pathUrl;
//    return [NSURL fileURLWithPath:[OL_SAVE_PATH stringByAppendingPathComponent:@"video.mp4"]];
}

/**
 视频写入的路径
 */
+ (NSString*)pathToWriter {
    return nil;

}
/**
 压缩视频成功后的路径
 
 */
+ (NSString*)pathOfCompressMovie {
    return nil;

}

@end
