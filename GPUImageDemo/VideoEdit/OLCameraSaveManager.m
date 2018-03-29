//
//  OLCameraSaveManager.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraSaveManager.h"

#define OL_COMPRESS_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/OLCompress"]
#define OL_SAVE_PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/OLSave"]


@implementation OLCameraSaveManager



/**
 视频写入地址URL
 */
+ (NSURL*)pathURLToWriter {
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSError  * error = nil;
    NSString * videoPath = nil;
    if ([fileManager fileExistsAtPath:OL_SAVE_PATH]) {
        videoPath = [OL_SAVE_PATH stringByAppendingPathComponent:@"record_video.mp4"] ;
        unlink([videoPath UTF8String]);
    }else {
        do {
            [fileManager createDirectoryAtPath:OL_SAVE_PATH withIntermediateDirectories:YES attributes:nil error:&error];
            videoPath = [OL_SAVE_PATH stringByAppendingPathComponent:@"record_video.mp4"] ;
        } while (error);
    }
    NSURL * pathUrl = [NSURL fileURLWithPath:videoPath];
    NSLog(@"writer--->%@",pathUrl);
    return pathUrl;
}

/**
 视频写入的路径
 */
+ (NSString*)pathToWriter {
    
    return [OL_SAVE_PATH stringByAppendingPathComponent:@"video.mp4"];

}
/**
 压缩视频成功后的路径
 
 */
+ (NSString*)pathOfCompressMovie {
    return nil;

}

@end
