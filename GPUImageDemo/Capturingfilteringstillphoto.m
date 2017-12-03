//
//  Capturingfilteringstillphoto.m
//  GPUImageDemo
//
//  Created by LiYang on 2017/12/3.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "Capturingfilteringstillphoto.h"
#import <GPUImage.h>

@interface Capturingfilteringstillphoto ()

@end

@implementation Capturingfilteringstillphoto

- (void)viewDidLoad {
    [super viewDidLoad];

    GPUImageStillCamera*    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
   GPUImageGammaFilter*  filter = [[GPUImageGammaFilter alloc] init];
    [stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    [filter useNextFrameForImageCapture];

    [stillCamera startCameraCapture];
    
    [stillCamera capturePhotoAsPNGProcessedUpToFilter:filter withOrientation:UIImageOrientationUp withCompletionHandler:^(NSData *processedPNG, NSError *error) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSError *error2 = nil;
        if (![processedPNG writeToFile:[documentsDirectory stringByAppendingPathComponent:@"FilteredPhoto.jpg"] options:NSAtomicWrite error:&error2])
        {
            return;
        }
    }];

}


@end
