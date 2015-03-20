//
//  LZZFetchManager.h
//  accountDemo
//
//  Created by ucs on 15/3/2.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZZAccount.h"

@interface LZZFetchManager : NSObject


/**
 *  拿到所有账户的数组
 */
+(NSArray*)getAllAccountList;

/**
 *  写入所有账户
 */
+(void)writeAllAccountList:(NSArray*)accountList;

/**
 *  删除所有账户
 */
+(void)deleteAllAccountList;

/**
 *  增加一个账户（如果该账户已存在，则更改）
 */
+(void)addAccount:(LZZAccount*)account;

/**
 *  通过序号修改一个账户
 */
+(void)editAccountByIndex:(int)index withNewAccount:(LZZAccount*)newAccount;

/**
 *  通过序号删除一个账户
 */
+(void)deleteAccountByIndex:(int)index;

/**
 *  通过序号移动交换账户
 */
+(void)moveAccount:(NSUInteger)sourceIndex toAccount:(NSUInteger )destinationIndex;

@end
