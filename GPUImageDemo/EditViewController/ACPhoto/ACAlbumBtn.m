//
//  ACAlbumBtn.m
//  ArtCameraPro
//
//  Created by NicoLin on 2017/8/4.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "ACAlbumBtn.h"
#import "UIView+ACCameraFrame.h"

@interface NSString (Size)
- (CGFloat)widthForFont:(UIFont *)font ;
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode ;
@end

@implementation NSString (Size)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
        if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableDictionary *attr = [NSMutableDictionary new];
            attr[NSFontAttributeName] = font;
            if (lineBreakMode != NSLineBreakByWordWrapping) {
                NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                paragraphStyle.lineBreakMode = lineBreakMode;
                attr[NSParagraphStyleAttributeName] = paragraphStyle;
            }
            CGRect rect = [self boundingRectWithSize:size
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                          attributes:attr context:nil];
            result = rect.size;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
        }
    return result;
}
- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}
@end

@implementation ACAlbumBtn

- (void)setAlbumTitle:(NSString *)title {
    
    self.selected = NO;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];

    CGFloat titleWidth = [title widthForFont:self.titleLabel.font];
    self.titleLabel.ca_height = titleWidth;
    
    CGFloat imageViewWidth = CGRectGetWidth(self.imageView.frame);
    self.ca_centerX += (self.ca_width - (imageViewWidth + titleWidth + 6.0f))/2;
    self.ca_width = imageViewWidth + titleWidth + 6.0f;
    self.imageEdgeInsets = UIEdgeInsetsMake(0,0 + titleWidth + 3.0f,0,0 - titleWidth - 3.0f);
    self.titleEdgeInsets = UIEdgeInsetsMake(0,0 - imageViewWidth - 3.0f,0, 0 + imageViewWidth + 3.0f);
}



@end
