//
//  NSData+Function.h
//  AduroSmartSDK
//
//  Created by LiYang on 2017/6/9.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Function)

+(unsigned short) crc8:(NSData *)data;


+(UInt16) NeedTranlate:(NSData *)data;
+(UInt16) CMUnEscape:(UInt8 *)pOut and:(UInt8 *)pIn and:(UInt16) len;
+(UInt16) CMEscape:(UInt8 *)pOut and:(UInt8 *)pIn and:(UInt16) len;
+(UInt16) NeeUnTranlate:(NSData *)data;

/**
 转义
 
 @param data 要转的数据
 @return 转后的数据
 */
+(NSData*)TranlateData:(NSData*)data;

/**
 反转义
 
 @param data 要转的数据
 @return 反转义的数据
 */
+(NSData*)UnTranlateData:(NSData*)data;

/**
 CRC16 校验
 
 @param data 要校验的数据
 @return 返回校验和
 */
+(unsigned short)crc16:(NSData *)data;

/**
 10进制数转换成2字节数
 
 @param len 10进制数 可传递0xffff 或345632这样的指令
 */
+(NSData *)get2BDataFromInt:(int)len;

/**
 10进制转换成1个字节的NSData
 
 @param len 10进制数
 @return 1字节的NSData
 */
+(NSData*)get1BDataFromInt:(int)len;



/**
 2字节大端字节序转换成int型
 
 @param data 大端字节序
 @return int 型数据
 */
+(int)the2BDataToInt:(NSData*)data;



/**
 4字节大端字节序转int 型数据
 
 @param data 大端字节序列
 @return int 型数据
 */
+(int)the4BDataToInt:(NSData*)data;

/**
 1字节转int
 */
+(int)tht1BDataToInt:(NSData*)data;

/**
 通用型字节转int
 */
+(unsigned)parseIntFromData:(NSData *)data;

/**
 二进制转10进制
 
 @param binary 二进制字符串
 @return 10进制数据
 */
+(NSString *)toDecimalWithBinary:(NSString *)binary;

/**
 10 进制数转换成16进制字符串
 @param intData 10进制数
 @return 返回16进制字符串
 */
+ (NSString *)ToHex:(int)intData;

/**
 16进制字符串转换成NSdata
 
 @param hexString 16进制字符串
 @return NSdata
 */
+(NSData *)hexStringToData:(NSString *)hexString;

/**
 16进制的nsdata数原封不动转成字符串
 @param data 0011223344556677
 @return  0011223344556677
 */
+(NSString*)hexDataToString:(NSData*)data;


/**
 任意字符串转换成6字节
 
 @param string 字符串
 @return 6字节nsdata
 */
+(NSData*)stringTo6BData:(NSString*)string;


/**
 两个字节的int 型数据转换成大端字节序
 
 @param num 整形数据
 @return 2字节的NSData
 */
+(NSData*)intToBigEndianData:(uint16_t)num;

@end
