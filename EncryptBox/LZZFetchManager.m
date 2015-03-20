//
//  LZZFetchManager.m
//  accountDemo
//
//  Created by ucs on 15/3/2.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LZZFetchManager.h"


@implementation LZZFetchManager

#pragma mark - 拿到所有账户
+(NSArray*)getAllAccountList
{
//    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString*docPath=[paths objectAtIndex:0];
    NSString*filePath=[DOCUMENTPATH stringByAppendingPathComponent:@"box.txt"];
    
    NSArray * accountList=[[NSArray alloc] initWithContentsOfFile:filePath];
    
    if (accountList.count==0)
    {
        NSLog(@"无记录!");
        return accountList;
    }
    else
    {
        NSMutableArray*accountList_unarchive=[NSMutableArray array];
        for (NSData*accountData in accountList)
        {
            LZZAccount*account=[NSKeyedUnarchiver unarchiveObjectWithData:accountData];
            [accountList_unarchive addObject:account];
        }
        NSLog(@"读取成功!");
        return accountList_unarchive;
    }
}

#pragma mark - 写入所有账户
+(void)writeAllAccountList:(NSArray*)accountList
{
    if (accountList.count==0)
    {
        NSLog(@"写入错误!");
        return;
    }
    
    NSMutableArray*accountList_archive=[NSMutableArray array];
    
    for (LZZAccount*account in accountList)
    {
        NSData*accountData=[NSKeyedArchiver archivedDataWithRootObject:account];
        [accountList_archive addObject:accountData];
    }
//    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString*docPath=[paths objectAtIndex:0];
    NSString*filePath=[DOCUMENTPATH stringByAppendingPathComponent:@"box.txt"];
    
    [accountList_archive writeToFile:filePath atomically:YES];
    
    NSLog(@"写入成功!  地址:%@",filePath);
    
}

#pragma mark - 删除所有账户
+(void)deleteAllAccountList
{
//    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString*docPath=[paths objectAtIndex:0];
    NSString*filePath=[DOCUMENTPATH stringByAppendingPathComponent:@"box.txt"];
    
    NSFileManager*fm=[NSFileManager defaultManager];
    BOOL isDeleted=[fm fileExistsAtPath:filePath];
    if (isDeleted)
    {
        NSError*err;
        [fm removeItemAtPath:filePath error:&err];
    }
    
    NSLog(@"全部账户已删除");
}

#pragma mark - 增加一个账户（如果该账户已存在，则更改）
+(void)addAccount:(LZZAccount *)account
{
    NSArray*allAcc=[self getAllAccountList];
    NSMutableArray*allAcc_mutable=[NSMutableArray arrayWithArray:allAcc];
    
    for (int i=0;i<allAcc.count;i++)
    {
        LZZAccount*acc=allAcc[i];
        if ([acc.companyName isEqualToString:account.companyName]&&[acc.productName isEqualToString:account.productName]&&[acc.userName isEqualToString:account.userName])
        {
            //如果是同一个账户
            [allAcc_mutable removeObjectAtIndex:i];
            NSLog(@"该账户已存在，已更新!");
            break;
        }
    }
    [allAcc_mutable addObject:account];
    [self writeAllAccountList:allAcc_mutable];
}

#pragma mark - 通过序号修改一个账户
+(void)editAccountByIndex:(int)index withNewAccount:(LZZAccount *)newAccount
{
    NSMutableArray*allAcc=[NSMutableArray arrayWithArray:[self getAllAccountList]];
    allAcc[index]=newAccount;
    [self writeAllAccountList:allAcc];
}


#pragma mark - 通过序号删除一个账户
+(void)deleteAccountByIndex:(int)index
{
    NSArray*allAcc=[self getAllAccountList];
    if (index+1>allAcc.count||index+1<0)
    {
        NSLog(@"index有错!");
        return;
    }
    NSMutableArray*allAcc_mutable=[NSMutableArray arrayWithArray:allAcc];
    [allAcc_mutable removeObjectAtIndex:index];
    if (allAcc_mutable.count==0)
    {
        [self deleteAllAccountList];
    }
    else
    {
        [self writeAllAccountList:allAcc_mutable];
    }
    
}

#pragma mark - 移动一个账户
+(void)moveAccount:(NSUInteger)sourceIndex toAccount:(NSUInteger )destinationIndex
{
    NSArray*allAcc=[self getAllAccountList];
    NSMutableArray*allAcc_mutable=[NSMutableArray arrayWithArray:allAcc];
    [allAcc_mutable exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
    [self writeAllAccountList:allAcc_mutable];
}


@end
