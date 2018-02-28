//
//  PhotoPickerCell.m
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

#import "ACPhotoPickerCell.h"

@interface ACPhotoPickerCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *livePhotoBadgeImageView;

@end

@implementation ACPhotoPickerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self                                       = [super initWithFrame:frame];
    if (self)
    {
        
        self.imageView                             = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        self.imageView.clipsToBounds               = YES;
        self.imageView.contentMode                 = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.imageView];
        
        self.livePhotoBadgeImageView               = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        self.livePhotoBadgeImageView.clipsToBounds = YES;
        self.livePhotoBadgeImageView.contentMode   = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:self.livePhotoBadgeImageView];
        
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.thumbnailImage                        = nil;
    self.imageView.image                       = nil;
    self.livePhotoBadgeImageView.image         = nil;

}

- (void)setThumbnailImage:(UIImage *)thumbnailImage
{
    _thumbnailImage                            = thumbnailImage;
    self.imageView.image                       = thumbnailImage;
}

- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage
{
    _livePhotoBadgeImage                       = livePhotoBadgeImage;
    self.livePhotoBadgeImageView.image         = livePhotoBadgeImage;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    self.imageView.alpha = highlighted ? 0.4f : 1.0f;
}
@end
