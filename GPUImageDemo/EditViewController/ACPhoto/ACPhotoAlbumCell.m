//
//  PhotoAlbumCell.m
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

#import "ACPhotoAlbumCell.h"

@implementation ACPhotoAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self customedCell];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 15;
    frame.origin.y += 15;
    frame.size.height -= 15;
    frame.size.width -= 30;
    [super setFrame:frame];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _thumbImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    _albumNameLabel.frame = CGRectMake(CGRectGetMaxX(self.thumbImageView.frame)+15, 0, 120, 23);
    _albumNameLabel.center = CGPointMake(_albumNameLabel.center.x, _thumbImageView.center.y-18);
    _photoCountLabel.frame = CGRectMake(self.albumNameLabel.frame.origin.x, CGRectGetMaxY(self.albumNameLabel.frame)+18, 120, 23);
    
}
- (void)customedCell
{
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.thumbImageView.backgroundColor = ACRGBColor(51, 51, 51);
    self.thumbImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.thumbImageView];
    
    self.albumNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.albumNameLabel];
    self.albumNameLabel.textColor = [UIColor whiteColor];
    self.albumNameLabel.font = [UIFont systemFontOfSize:16];
    
    self.photoCountLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.photoCountLabel];
//    self.photoCountLabel.textColor = ACRGBColor(170, 170, 170);
    self.photoCountLabel.font = [UIFont systemFontOfSize:12];
    
//    [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.bottom.and.top.equalTo(self.contentView);
//        make.width.equalTo(self.contentView.mas_height);
//    }];
//    [_albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.thumbImageView).with.offset(-18);
//        make.left.equalTo(self.thumbImageView.mas_right).with.offset(15);
//    }];
//    
//    [_photoCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.albumNameLabel);
//        make.top.equalTo(self.albumNameLabel.mas_bottom).with.offset(18);
//    }];

    
}
@end
