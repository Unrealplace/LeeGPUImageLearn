//
//  OLPhotoEditorToolView.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/29.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLPhotoEditorToolView.h"

@interface OLPhotoEditorToolView()

@property (nonatomic,strong)UIButton *finishBtn;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIButton *filterBtn;
@property (nonatomic,strong)UIButton *stillPasterBtn;
@property (nonatomic,strong)UIButton *tagBtn;
@end

@implementation OLPhotoEditorToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    [self addSubview:self.backBtn];
}



- (UIButton*)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        _backBtn.frame = CGRectMake(14, 0, 30, 30);
        _backBtn.center = CGPointMake(_backBtn.center.x, self.bounds.size.height/2.0f);
        [_backBtn setImage:[UIImage imageNamed:@"cam_ic_back_g"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)backBtnClick:(UIButton*)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editorToolViewClickBack)]) {
        [self.delegate editorToolViewClickBack];
    }
}
@end
