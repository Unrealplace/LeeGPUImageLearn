//
//  PanelViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/2/28.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "PanelViewController.h"
#import "PanelView.h"
#import "GPUImageAddBlendFilter.h"

@interface PanelViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)PanelView * panelView;
@property (nonatomic,strong)GPUImagePicture * frontPic; // 前景
@property (nonatomic,strong)GPUImagePicture * backPic; // 背景
@property (nonatomic,strong)GPUImageAddBlendFilter  * blendFilter; // 混合模式
@property (nonatomic,strong)GPUImageTransformFilter * frontTransformFilter;//前景图tranform 滤镜

@property (nonatomic,assign)CATransform3D   defaultFrontTransForm; // 默认的前景的tranform
//@property (nonatomic,assign)CATransform3D   defaultFrontPinchTranFrom;// 默认的前景的捏合变化
//@property (nonatomic,assign)CATransform3D   defaultFrontRoationTranForm; //默认的前景的旋转变换
@property (nonatomic,assign)CGPoint     lastPoint;// 上一次的点

@end

@implementation PanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.panelView];

    self.frontPic = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"mask_10000"]];
    self.backPic  = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"img_levitation_back_0"]];
    [self initFilterLine];
    [self processImg];
    __weak typeof(self) weakself = self;
    self.changeImgBlock = ^(UIImage *front, UIImage *back) {
         if (front) {
            weakself.frontPic = [[GPUImagePicture alloc] initWithImage:front];
         }
        if (back) {
            weakself.backPic = [[GPUImagePicture alloc] initWithImage:back];
        }
        [weakself initFilterLine];
        [weakself processImg];
    };
    
}

- (void)loadView {
    [super loadView];
    self.view.bounds = CGRectMake(0, 0, 375, 375);
    self.lastPoint   = CGPointZero;
    self.defaultFrontTransForm  =  CATransform3DIdentity;
//    self.defaultFrontRoationTranForm = CATransform3DIdentity;
}

- (PanelView*)panelView {
    if (!_panelView) {
        _panelView = [[PanelView alloc] initWithFrame:self.view.bounds];
        _panelView.backgroundColor = [UIColor blueColor];
        
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

- (void)setFrontPic:(GPUImagePicture *)frontPic {
    
    [_frontPic removeAllTargets];
    _frontPic = frontPic;
    
}

- (void)setBackPic:(GPUImagePicture *)backPic {
    [_backPic removeAllTargets];
    _backPic = backPic;
}

- (GPUImageAddBlendFilter*)blendFilter {
    if (!_blendFilter) {
        _blendFilter = [[GPUImageAddBlendFilter alloc] init];
    }
    return _blendFilter;
}

- (GPUImageTransformFilter*)frontTransformFilter {
    if (!_frontTransformFilter) {
        _frontTransformFilter = [[GPUImageTransformFilter alloc] init];
    }
    return _frontTransformFilter;
}


- (void)initFilterLine {
    
    [self.backPic addTarget:self.blendFilter atTextureLocation:1];
    [self.frontPic addTarget:self.frontTransformFilter];
    [self.frontTransformFilter addTarget:self.blendFilter atTextureLocation:0];
    [self.blendFilter addTarget:self.panelView];
    
}

- (void)processImg {
    [self.backPic processImage];
    [self.frontPic processImage];
}

- (void)panAction:(UIPanGestureRecognizer*)sender {
 
    CGPoint point = [sender translationInView:sender.view];
    CATransform3D tranform = self.defaultFrontTransForm;
    tranform.m41 = tranform.m41 + (point.x - self.lastPoint.x)/375*2;
    tranform.m42 = tranform.m42 + (point.y - self.lastPoint.y)/375*2;
    
//   CATransform3D tranform = CATransform3DTranslate(self.defaultFrontTransForm, (point.x - self.lastPoint.x)/375*2, (point.y - self.lastPoint.y)/375*2, 0);
    self.lastPoint = point;
    self.defaultFrontTransForm = tranform;
    self.frontTransformFilter.transform3D = self.defaultFrontTransForm;
    [self processImg];
}

- (void)rotationAction:(UIRotationGestureRecognizer*)sender {
 
    CATransform3D tranform = CATransform3DRotate(self.defaultFrontTransForm, sender.rotation, 0, 0, 1);
    self.defaultFrontTransForm = tranform;
    self.frontTransformFilter.transform3D = self.defaultFrontTransForm;
    sender.rotation = 0.0f;
    [self processImg];

}

- (void)pinchAction:(UIPinchGestureRecognizer*)sender {
 
    CATransform3D tranform = CATransform3DScale(self.defaultFrontTransForm,sender.scale,sender.scale,0);
    self.defaultFrontTransForm = tranform;
    self.frontTransformFilter.transform3D = self.defaultFrontTransForm;
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
