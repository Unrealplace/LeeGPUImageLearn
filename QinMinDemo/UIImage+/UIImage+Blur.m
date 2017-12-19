//
//  UIImage+Blur.m
//
//  Created by qinmin on 2016/4/13.
//  Copyright © 2016年 qinmin. All rights reserved.
//

#import "UIImage+Blur.h"

@implementation UIImage (Blur)

- (UIImage *)gaussianBlurImageWithLevel:(CGFloat)blur
{
    CIImage *inputImage = [CIImage imageWithCGImage:self.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey, inputImage, @"inputRadius", @(blur), nil];
    
    CIImage *outputImage = filter.outputImage;
    
    CGImageRef outImage = [[CIContext contextWithOptions:nil] createCGImage:outputImage
                                             fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return image;
}


@end
