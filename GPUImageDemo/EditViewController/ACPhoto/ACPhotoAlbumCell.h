//
//  PhotoAlbumCell.h
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPhotoAlbumCell : UITableViewCell

@property (nonatomic, strong) UIImageView * thumbImageView;
@property (nonatomic, strong) UILabel * albumNameLabel;
@property (nonatomic, strong) UILabel * photoCountLabel;
@property (nonatomic, copy) NSString *  localIdentifier;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
