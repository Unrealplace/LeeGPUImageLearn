//
//  PanelViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/2/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "PanelViewController.h"
#import "PanelView.h"
#import "GPUImageNormalBlendFilter.h"
#import "GPUImageLookupFilter.h"
#import "GPUImageMaskFilter.h"

@interface PanelViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)PanelView * panelView;
@property (nonatomic,strong)GPUImagePicture * frontPic; // 前景
@property (nonatomic,strong)GPUImagePicture * backPic; // 背景
@property (nonatomic,strong)GPUImagePicture * lookUpPic; //色彩立方图
@property (nonatomic,strong)GPUImagePicture * maskPic;//遮罩图片

@property (nonatomic,strong)GPUImageTwoInputFilter  * blendFilter; // 混合模式
@property (nonatomic,strong)GPUImageTransformFilter * frontTransformFilter;//前景图tranform 滤镜
@property (nonatomic,strong)GPUImageLookupFilter    * lookUpFilter;//色彩立方图滤镜
@property (nonatomic,strong)GPUImageMaskFilter      * maskBlendFilter;//遮罩混合滤镜
@property (nonatomic,strong)GPUImageGrayscaleFilter * maskGrayFilter;// 将遮罩进行灰度处理，有可能从本地选择图片
@property (nonatomic,strong)GPUImageTransformFilter * maskTransformFilter;//遮罩的tranform 变换


@property (nonatomic,assign)CATransform3D   defaultFrontTransForm; // 默认的前景的tranform
@property (nonatomic,assign)CATransform3D   defaultMaskTranform; // 默认的遮罩的tranform
@property (nonatomic,assign)CGPoint     lastPoint;// 上一次的点
@property (nonatomic,assign)CGPoint     maskLastPoint;//遮罩的上次的点
@property (nonatomic,assign)BOOL        isFrontTranform;//前景能否tranform 变换
@property (nonatomic,assign)BOOL        isMaskTranform;//遮罩能否tranform 变换

@end

@implementation PanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.panelView];

    self.frontPic = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask_10000"]];
    self.backPic  = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"img_levitation_back_0"]];
    self.lookUpPic = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Normal"]];
    self.maskPic  = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask0"]];
    
    __weak typeof(self) weakself = self;
    self.frontAndMaskBlock = ^(BOOL front, BOOL mask) {
        weakself.isMaskTranform  = mask;
        weakself.isFrontTranform = front;
    };
    self.frontAndMaskBlock(YES, NO);
    [weakself initFilterLine];
    [weakself processImg];
    // 前景背景图片切换
    self.changeImgBlock = ^(UIImage *front, UIImage *back) {
         if (front) {
            weakself.frontPic = [[GPUImagePicture alloc] initWithImage:front];
         }
        if (back) {
            weakself.backPic  = [[GPUImagePicture alloc] initWithImage:back];
        }
        [weakself initFilterLine];
        [weakself processImg];
    };
    // 色彩立方图效果切换
    self.changeLkpBlock = ^(UIImage *lookUpImg) {
        weakself.isMaskTranform  = NO;
        weakself.isFrontTranform = YES;
        weakself.lookUpPic = [[GPUImagePicture alloc] initWithImage:lookUpImg];
        [weakself initFilterLine];
        [weakself processImg];
    };
    // 遮罩效果切换
    self.changeMaskBlock = ^( UIImage *maskImg) {
        weakself.isMaskTranform  = YES;
        weakself.isFrontTranform = NO;
        weakself.maskPic  = [[GPUImagePicture alloc] initWithImage:maskImg];
        [weakself initFilterLine];
        [weakself processImg];
    };
    
}

- (void)loadView {
    [super loadView];
    self.view.bounds = CGRectMake(0, 0, 375, 375);
    self.lastPoint   = CGPointZero;
    self.maskLastPoint = CGPointZero;
    self.defaultFrontTransForm  =  CATransform3DIdentity;
    self.defaultMaskTranform    =  CATransform3DIdentity;

}

- (PanelView*)panelView {
    if (!_panelView) {
        _panelView = [[PanelView alloc] initWithFrame:self.view.bounds];
        _panelView.backgroundColor = [UIColor blueColor];
        _panelView.opaque = NO;
        _panelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _panelView.fillMode  = kGPUImageFillModePreserveAspectRatioAndFill;
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_panelView addGestureRecognizer:pan];
        pan.delegate = self;
        
        UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
        [_panelView addGestureRecognizer:rotation];
        rotation.delegate = self;
        
        UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [_panelView addGestureRecognizer:pinch];
        pinch.delegate = self;
    }
    return _panelView;
}

#pragma 图片
- (void)setFrontPic:(GPUImagePicture *)frontPic {
    [_frontPic removeAllTargets];
    _frontPic = frontPic;
    [_frontPic addTarget:self.frontTransformFilter];
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

- (void)setBackPic:(GPUImagePicture *)backPic {
    [_backPic removeAllTargets];
    _backPic = backPic;
    [_backPic addTarget:self.blendFilter atTextureLocation:0];
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
}

- (void)setLookUpPic:(GPUImagePicture *)lookUpPic {
    [_lookUpPic removeAllTargets];
    _lookUpPic = lookUpPic;
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];

}

- (void)setMaskPic:(GPUImagePicture *)maskPic {
   
    [_maskPic removeAllTargets];
    _maskPic = maskPic;
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    [_maskPic addTarget:self.maskGrayFilter];

}


#pragma 滤镜
- (GPUImageLookupFilter*)lookUpFilter {
    if (!_lookUpFilter) {
        _lookUpFilter = [[GPUImageLookupFilter alloc] init];
    }
    return _lookUpFilter;
}
- (GPUImageTwoInputFilter*)blendFilter {
    if (!_blendFilter) {
        _blendFilter = [[GPUImageNormalBlendFilter alloc] init];
    }
    return _blendFilter;
}

- (GPUImageMaskFilter*)maskBlendFilter {
    if (!_maskBlendFilter) {
        _maskBlendFilter = [[GPUImageMaskFilter alloc] init];
    }
    return _maskBlendFilter;
}

- (GPUImageTransformFilter*)frontTransformFilter {
    if (!_frontTransformFilter) {
        _frontTransformFilter = [[GPUImageTransformFilter alloc] init];
    }
    return _frontTransformFilter;
}

- (GPUImageGrayscaleFilter*)maskGrayFilter {
    if (!_maskGrayFilter) {
        _maskGrayFilter = [[GPUImageGrayscaleFilter alloc] init];
    }
    return _maskGrayFilter;
}

- (GPUImageTransformFilter*)maskTransformFilter {
    if (!_maskTransformFilter) {
        _maskTransformFilter = [[GPUImageTransformFilter alloc] init];
    }
    return _maskTransformFilter;
}

#pragma mark 滤镜链
- (void)initFilterLine {
    
    [self.maskGrayFilter addTarget:self.maskTransformFilter];
    [self.maskTransformFilter addTarget:self.maskBlendFilter ];
    [self.frontTransformFilter addTarget:self.maskBlendFilter];
    [self.maskBlendFilter addTarget:self.blendFilter atTextureLocation:1];
    [self.blendFilter addTarget:self.lookUpFilter];
    [self.lookUpPic addTarget:self.lookUpFilter];
    [self.lookUpFilter addTarget:self.panelView];
    
}


- (void)processImg {

    [self.maskPic processImage];
    [self.backPic processImage];
    [self.frontPic processImage];
    [self.lookUpPic processImage];
    
}

- (void)panAction:(UIPanGestureRecognizer*)sender {
 
    
    if (self.isFrontTranform) {
        CGPoint point = [sender translationInView:sender.view];
        CATransform3D tranform = self.defaultFrontTransForm;
        tranform.m41 = tranform.m41 + (point.x - self.lastPoint.x)/375*2;
        tranform.m42 = tranform.m42 + (point.y - self.lastPoint.y)/375*2;
        self.lastPoint = point;
        self.defaultFrontTransForm = tranform;
        self.frontTransformFilter.transform3D = self.defaultFrontTransForm;

    }else {
        CGPoint point = [sender translationInView:sender.view];
        CATransform3D tranform = self.defaultMaskTranform;
        tranform.m41 = tranform.m41 + (point.x - self.maskLastPoint.x)/375*2;
        tranform.m42 = tranform.m42 + (point.y - self.maskLastPoint.y)/375*2;
        self.maskLastPoint = point;
        self.defaultMaskTranform = tranform;
        self.maskTransformFilter.transform3D = self.defaultMaskTranform;
    }
    [self processImg];
}

- (void)rotationAction:(UIRotationGestureRecognizer*)sender {
 
    if (self.isFrontTranform) {
        CATransform3D tranform = CATransform3DRotate(self.defaultFrontTransForm, sender.rotation, 0, 0, 1);
        self.defaultFrontTransForm = tranform;
        self.frontTransformFilter.transform3D = self.defaultFrontTransForm;

    }else {
        CATransform3D tranform = CATransform3DRotate(self.defaultMaskTranform, sender.rotation, 0, 0, 1);
        self.defaultMaskTranform = tranform;
        self.maskTransformFilter.transform3D = self.defaultMaskTranform;
    }
    sender.rotation = 0.0f;
    [self processImg];

}

- (void)pinchAction:(UIPinchGestureRecognizer*)sender {
 
    
    if (self.isFrontTranform) {
        
        CATransform3D tranform = CATransform3DScale(self.defaultFrontTransForm,sender.scale,sender.scale,0);
        self.defaultFrontTransForm = tranform;
        self.frontTransformFilter.transform3D = self.defaultFrontTransForm;

    } else {
        CATransform3D tranform = CATransform3DScale(self.defaultMaskTranform,sender.scale,sender.scale,0);
        self.defaultMaskTranform = tranform;
        self.maskTransformFilter.transform3D = self.defaultMaskTranform;
    }
    sender.scale = 1;
    [self processImg];
    

}

#pragma mark 手势 delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (!_frontPic || !_backPic) return NO;
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




@end
