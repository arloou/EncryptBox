//
//  MyAccount.h
//  accountDemo
//
//  Created by ucs on 15/3/2.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LZZAccount : NSObject<NSCoding>
/**
 *  主公司名
 */
@property(nonatomic,copy)NSString*companyName;
/**
 *  产品名
 */
@property(nonatomic,copy)NSString*productName;
/**
 *  用户名
 */
@property(nonatomic,copy)NSString*userName;
/**
 *  密码（NSData）
 */
@property(nonatomic,copy)NSData*passWord;
/**
 *  绑定的手机（数组）
 */
@property(nonatomic,copy)NSString*bingdingPhoneNumber;
/**
 *  绑定的邮箱（数组）
 */
@property(nonatomic,copy)NSString*bingdingEmail;
/**
 *  其他备注
 */
@property(nonatomic,copy)NSString*otherInfo;


-(instancetype)init;

+(instancetype)account;

-(BOOL)checkIfHasText:(NSString*)searchText;

@end
