//
//  OLDataViewController.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/13.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLDataViewController.h"
#import "OLObjcDataViewModel.h"

@interface OLDataViewController ()
@property (nonatomic,strong)OLObjcDataViewModel *objcDataViewModel;

@end

@implementation OLDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (OLObjcDataViewModel*)objcDataViewModel {
    if (!_objcDataViewModel) {
        _objcDataViewModel = [[OLObjcDataViewModel alloc] init];
    }
    return _objcDataViewModel;
}

- (void)viewWillConfigureParameters {


    NSArray * array1 = @[@(1),@(3),@(5),@(4),@(6)];
    RACSequence *newSequence  =   [[array1.rac_sequence filter:^BOOL(id value) {
        return [value intValue]%2==0;
    }]map:^id(id value) {
        NSLog(@"array1----%@",value);
        return @(sqrt([value doubleValue]));
    }] ;
    NSArray * newArray = [NSArray arrayWithArray:newSequence.array];
    OLog(@"newSequence----%@",newArray);
    OLog(@"hello");
    
}



@end
