//
//  CoreDataManger.h
//  EncryptBox
//
//  Created by ucs on 15/1/22.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CoreDataManger : NSObject


// 快捷方法
+(NSString*)getCurrentEnterPassword;
+(BOOL)updateEnterPassword:(NSString*)passWord;  // 返回是否成功
+(BOOL)hasEnterPwd;

+(BOOL)isFirstLogin;
+(void)didLogin;
@end
