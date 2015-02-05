//
//  DES3Util.h
//  EWallet
//
//  Created by tom on 14-5-21.
//  Copyright (c) 2014年 ucsmy. All rights reserved.
//

//
//  DES3Util.h
//  lx100-gz
//
//  Created by  柳峰 on 12-10-10.
//  Copyright 2012 http://blog.csdn.net/lyq8479. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


@interface DES3Util : NSObject

/****** 加密 ******/
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString*)eKey;
/****** 解密 ******/
+(NSString *) decryptUseDES:(NSString *)plainText key:(NSString*)dKey;

//nsdata转成16进制字符串
+ (NSString*)stringWithHexBytes2:(NSData *)sender;

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;


+ (NSString *)encryptWithText:(NSString *)sText key:(NSString*)ekey;//加密
+ (NSString *)decryptWithText:(NSString *)sText key:(NSString*)ekey;//解密


@end
