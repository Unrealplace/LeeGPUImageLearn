//
//  OLCameraRecordManager.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCameraRecordManager.h"
#import <GPUImage.h>
#import "OLCameraSaveManager.h"

@interface OLCameraRecordManager()

@property (nonatomic,strong)GPUImageMovieWriter *movieWriter;

@end

@implementation OLCameraRecordManager


- (GPUImageMovieWriter*)movieWriter {
    if (!_movieWriter) {
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[OLCameraSaveManager pathURLToWriter] size:CGSizeMake(480, 640)];
        _movieWriter.encodingLiveVideo = YES;
        _movieWriter.shouldPassthroughAudio = YES;
        
    }
    return _movieWriter;
}

- (void)addTargetToRecordManager:(id<GPUImageInput>)target {
    if (target) {
        [(GPUImageFilter*)target addTarget:self.movieWriter];
    }
}

- (void)startRecord {
    [self.movieWriter startRecording];
}

- (void)stopRecord {
    
    [self.movieWriter finishRecordingWithCompletionHandler:^{
        
    }];
    
}

@end
