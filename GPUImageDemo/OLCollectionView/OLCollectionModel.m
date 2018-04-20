//
//  OLCollectionModel.m
//  GPUImageDemo
//
//  Created by NicoLin on 2018/4/19.
//  Copyright © 2018年 NicoLin. All rights reserved.
//

#import "OLCollectionModel.h"

@implementation OLCollectionModel


- (CGSize)modelSize {
    
    return [self calculateRowHeight:self.name fontSize:14];
    
}

- (CGSize)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    
  return [string boundingRectWithSize:CGSizeMake(375, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size;
    
}


@end
