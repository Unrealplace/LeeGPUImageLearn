//
//  OLRouter.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/3/30.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum: NSInteger{
    OLRouterAppearTypePush = 0,
    OLRouterAppearTypePresent,
    OLRouterAppearTypePresetWithNavigation,
}OLRouterAppearType;

@interface OLRouter : NSObject

+ (void)OpenURL:(NSString*)UrlString configureHandler:(void(^)(id))configureHandler appearType:(OLRouterAppearType)appearType;

@end
