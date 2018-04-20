//
//  OLCellOne.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/18.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLCollectionModel.h"

@class OLCellOne;

typedef void (^OLLongPressBlock)(OLCellOne *cell,UILongPressGestureRecognizer *gesture);

@interface OLCellOne : UICollectionViewCell

@property (nonatomic,copy)OLLongPressBlock longPressBlock;

@property (nonatomic,strong)UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic,strong)OLCollectionModel *model;

@end
