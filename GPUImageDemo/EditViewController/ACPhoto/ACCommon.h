//
//  ACCommonMacro.h
//  ArtCamera
//
//  Created by NicoLin on 2016/11/23.
//  Copyright © 2016年 NicoLin. All rights reserved.
//

#ifndef ACCommon_h
#define ACCommon_h
//#import <GLKit/GLKit.h>
//////////////神策

// Debug 模式选项
//   SensorsAnalyticsDebugOff - 关闭 Debug 模式
//   SensorsAnalyticsDebugOnly - 打开 Debug 模式，校验数据，但不进行数据导入
//   SensorsAnalyticsDebugAndTrack - 打开 Debug 模式，校验数据，并将数据导入到 Sensors Analytics 中
// 注意！请不要在正式发布的 App 中使用 Debug 模式！
//#ifndef DEBUG
//    #define SA_DEBUG_MODE SensorsAnalyticsDebugAndTrack
//// 数据接收的 URL
//    #define SA_SERVER_URL @"http://tj.adnonstop.com:8106/sa?project=hcq_project_test"
//// 配置分发的 URL
//    #define SA_CONFIGURE_URL @"http://tj.adnonstop.com:8106/config/?project=hcq_project_test"

//#else


//
//#endif

/////////////百度

//--------------------------相关的key(测试版本)--------------------
//static NSString *const ShareSDKAppKey = @"19d2b99a8f155";
//static NSString *const SinaRedirectUri = @"http://www.poco.cn";
//static NSString *const SinaAppKey = @"2486392712";
//static NSString *const SinaAppSecret = @"48479bfdb4e4be0a5862c4a86133c446";
//static NSString *const WXAppKey = @"wxf9e55bbf17161d6b";
//static NSString *const WXAppSecret = @"714ff046ec315d579f30c4920baf9144";
//static NSString *const QQAppKey = @"1105804921";
//static NSString *const QQAppSecret = @"8Z9gS8J4P19q0dGm";

//--------------------------相关的key(正式版本)--------------------


typedef void(^requestHandler)(BOOL isSucceed, id responseObject);

typedef struct IrregularRect {
    CGPoint L_T;
    CGPoint R_T;
    CGPoint L_B;
    CGPoint R_B;
} ACIrregularMeshVertex;

//typedef NS_ENUM(NSInteger, ACVertexAttrib) {
//    ACVertexAttribPosition,
//    ACVertexAttribNormal,
//    ACVertexAttribTexCoord
//};

//typedef struct ACVertex {
//    GLKVector3 position;
//    GLKVector3 normal;
//    GLKVector2 uv;
//} ACVertex;

//Notification Name
static NSString *const ACEraseUndoNotification = @"ACEraseUndoNotification";


#define KEY_APP_VERSION @"KEY_APP_VERSION"
#define KEY_APP_OPEN_TIMES @"KEY_APP_OPEN_TIMES"
#define AppCurrentVersion ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ? [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] : @"")
#define AppDebugVersion    @"88.8.8"
#define ACCurrentVersionKey @"currentVersion"

//是否为pad
#define DeviceIsPad                     [UIDevice currentDevice].isPad
#define DeviceIsX                       (SCREEN_HEIGHT == 812.0f)

//适配
#define ACWindow                        [[[UIApplication sharedApplication] delegate] window]
#define ACScoreAlert                    [ACProgressHUD showWithContents:message position:CGPointMake(kScreenWidth / 2, NAVI_TOP_PADDING + NAVI_HEIGHT+ 40) animateEffect:ACProgressHUDAnimateEffectNormal];
#define NAVI_TOP_PADDING                (DeviceIsX ? 44.0f : 0.0f)
#define NAVI_HEIGHT                     (DeviceIsX ? 60.0f : 44.0f)
#define EDIT_BOTTOM_PADDING             (DeviceIsX ? 34.0f : 0.0f)

#define adjustValue(a)                  (DeviceIsX ? a : (a) * [UIScreen mainScreen].bounds.size.height / 667.0f)
#define adjustValueByWidth(a)           (a) * [UIScreen mainScreen].bounds.size.width / 375.0f

#define PANEL_PADDING                   (DeviceIsPad ? 82.0f : 0.0f)
#define PANEL_SAVE_PADDING              (DeviceIsPad ? 48.0f : 30.0f)

#define SCREEN_BOUNDS                   [[UIScreen mainScreen] bounds]
#define SCREEN_SIZE                     [[UIScreen mainScreen] bounds].size
#define SCREEN_SCALE                    [UIScreen  mainScreen].scale
#define SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height
#define PANEL_SIZE                      CGSizeMake(SCREEN_WIDTH - PANEL_PADDING * 2, SCREEN_WIDTH - PANEL_PADDING * 2)
#define SINGLE_PIXEL                    (1.0 / [UIScreen mainScreen].scale)
//RGBA颜色基础宏
#define ACRGBAColor(r,g,b,a)            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define ACRGBColor(r,g,b)               [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(1.0f)]
#define ACBlackColor(h)                 [UIColor colorWithRed:(h)/255.0 green:(h)/255.0 blue:(h)/255.0 alpha:(1.0f)]

//字体
#define ACFont(size)                    [UIFont systemFontOfSize:size]
#define ACBoldFont(size)                [UIFont boldSystemFontOfSize:size]

//由角度转换弧度 由弧度转换角度
#define ACDegreesToRadian(x)            (M_PI * (x) / 180.0)
#define ACRadianToDegrees(radian)       (radian*180.0)/(M_PI)

//动画
#define EditorFirstAnimateDuration 0.16f //编辑界面一级工具栏切换动画时间
#define EditorSecondAnimateDuration 0.15f //编辑界面二级工具栏切换动画时间
#define EditorCardAnimateDuration 0.25f //混合模式、滤镜、遮罩列表cell选中动画时间
#define EditorDropAnimateDuration 0.2f //编辑界面出现玩法展示、照片界面出现相册列表

//橡皮擦
#define DefaultMaxEraseSize 90.0f
#define DefaultMinEraseSize 5.0f
#define DefaultMaxEraseOpacity 1.0f
#define DefaultMinEraseOpacity 0.0f
#define MagnifyScale  1.35f //放大镜比例
#define MagnifyByTouchScale  0.65f //放大镜触发时机为笔触实际大小占最大尺寸的比例


//编辑流程图片质量
#define EditorMaskSize CGSizeMake(512.0f, 512.0f)
#define EditorInputSize CGSizeMake(1024.0f, 1024.0f)
#define EditorOutputSize CGSizeMake(2048.0f, 2048.0f)

//本App的下载的url
#define AppShareURL @"https://wap.adnonstop.com/topic/photomixer/intro.php?appname=share"
#define AppShareTitle @"我觉得图片合成器其实可以。"
#define AppShareUrlImage @"shareUrlImage.jpg"
#define AppShareImage @"shareImage.jpg" //关于页、样片展示页分享至微博、QQ空间时图片内容

#ifdef DEBUG
#define ACLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define ACLog(...) NSLog(@"%@\n",[NSString stringWithFormat:__VA_ARGS__])
#endif

static NSString * const OpenWoosh =
@"               \\`.     ___\n                 \\ \\   / __>0\n             /\\  /  |/' / \n            /  \\/   `  ,`'--.\n           / /(___________)_ \\\n           |/ //.-.   .-.\\\\ \\ \\\n           0 // :@___ @:  \\\\ \\/\n             ( o ^(___)^ o ) 0\n              \\ \\_______/ /'\\ /\n         \\     '._______.'--.\n          \\ /|  |<_____>    |\n           \\ \\__|<_____>____/|__\n            \\____<_____>_______/\n                |<_____>    |\n                |<_____>    |\n                :<_____>____:\n               / <_____>   /|\n              /  <_____>  / |\n             /___________/  |\n             |           | _|__\n             |           | ---||_\n             |  ART      |  | [__]\n             |  CAMERA   |  /\n             |           | /\n             |___________|/";
#endif /* ACCommonMacro_h */
