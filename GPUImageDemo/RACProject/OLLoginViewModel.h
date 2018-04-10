//
//  OLLoginViewModel.h
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/10.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface OLLoginViewModel : NSObject

@property (nonatomic,copy)NSString *passWord;
@property (nonatomic,copy)NSString *userName;

@property (nonatomic,strong)RACCommand *loginRequestCommand;
@property (nonatomic,strong)RACSignal  *checkUserRegisterSignal;
@property (nonatomic,strong)RACSignal  *loginSuccessSignal;
@property (nonatomic,strong)RACSignal  *validateLoginInputs;

@end
