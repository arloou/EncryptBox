//
//  userInfo.m
//  EncryptBox
//
//  Created by ucs on 15/1/22.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "userInfo.h"

@implementation userInfo
+(instancetype)shareInfo
{
    static userInfo *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}


-(void)setEnterPassWord:(NSString *)enterPassWord
{
    _enterPassWord=enterPassWord;
    [[NSUserDefaults standardUserDefaults] setValue:_enterPassWord forKey:@"EnterPassWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
