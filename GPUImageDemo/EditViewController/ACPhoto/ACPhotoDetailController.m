//
//  ACPhotoDetailController.m
//  ArtCameraPro
//
//  Created by BeautyHZ on 2017/11/29.
//  Copyright © 2017年 NicoLin. All rights reserved.
//

#import "ACPhotoDetailController.h"

@interface ACPhotoDetailController ()

@property (nonatomic, copy) photoPickBlock pickBlock;

@end

@implementation ACPhotoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIImageView *img = [[UIImageView alloc] initWithImage:self.photo];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.frame = self.view.bounds;
    img.backgroundColor = [UIColor blackColor];
    [self.view addSubview:img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"选择图片" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (self.pickBlock) {
            self.pickBlock(self.photo);
        }
    }];
    
    return @[action1];
}

- (void)selectTheImgWithBlock:(photoPickBlock)block {
    if (block) {
        self.pickBlock = block;
    }
}


@end
