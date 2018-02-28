//
//  PhotoPickerCell.h
//  ArtCamera
//
//  Created by NicoLin on 2016/11/25.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACPhotoPickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImage              *thumbnailImage;
@property (nonatomic, strong) UIImage              *livePhotoBadgeImage;
@property (nonatomic, copy  ) NSString             *representedAssetIdentifier;

@property (nonatomic, strong) NSIndexPath          *indexPath;

@end
