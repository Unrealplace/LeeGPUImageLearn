//
//  NSString+ACFontSize.h
//  CameraDemo
//
//  Created by NicoLin on 2018/1/15.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ACFontSize)
- (CGFloat)widthForFont:(UIFont *)font ;
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode ;

@end
