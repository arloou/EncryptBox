//
//  CoreDataManger.m
//  EncryptBox
//
//  Created by ucs on 15/1/22.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "CoreDataManger.h"
#import "User.h"
#import "AppDelegate.h"
#import "DES3Util.h"

@implementation CoreDataManger

#pragma mark - 拿到当前的登陆密码
+(NSString*)getCurrentEnterPassword
{
    AppDelegate * app=[UIApplication sharedApplication].delegate;
    
    
    NSFetchRequest * pwdReq=[[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray * users=[app.managedObjectContext executeFetchRequest:pwdReq error:nil];
    User * user=[users lastObject];
    
    // 返回的是解密后的密码
    return [DES3Util decryptWithText:user.enterPassWord key:DES_KEY];
}
+(BOOL)updateEnterPassword:(NSString*)passWord
{
    AppDelegate * app=[UIApplication sharedApplication].delegate;
    
    NSFetchRequest * pwdReq=[[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray * users=[app.managedObjectContext executeFetchRequest:pwdReq error:nil];
    
    if (users.count==0)
    {
        // 插入一个新的密码
        User*newUser=[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:app.managedObjectContext];
        [newUser setEnterPassWord:[DES3Util encryptWithText:passWord key:DES_KEY]]; // 加密存进
        [newUser setIsFirstLogin:[NSNumber numberWithInt:1]];
        NSError*error;
        BOOL isSaveSuccess=[app.managedObjectContext save:&error];
        if (!isSaveSuccess)
        {
            NSLog(@"增加密码失败:%@",error);
            return NO;
        }
        else
        {
            NSLog(@"成功增加一个密码");
            return YES;
        }
    }
    else
    {
        User * user=[users lastObject];
        
        user.enterPassWord=[DES3Util encryptWithText:passWord key:DES_KEY];
        [app saveContext];
        NSLog(@"密码已改为:%@",user.enterPassWord);
        
        NSError*error;
        BOOL isSaveSuccess=[app.managedObjectContext save:&error];
        if (!isSaveSuccess)
        {
            NSLog(@"增加密码失败:%@",error);
            return NO;
        }
        else
        {
            NSLog(@"修改密码成功");
            return YES;
        }
    }
    
    return NO;
    
}

#pragma mark - 判断是否有密码
+(BOOL)hasEnterPwd
{
    AppDelegate * app=[UIApplication sharedApplication].delegate;
    
    
    NSFetchRequest * pwdReq=[[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray * users=[app.managedObjectContext executeFetchRequest:pwdReq error:nil];
    
    return users.count==0?NO:YES;
}

#pragma mark - 判断是否是第一次登陆

+(BOOL)isFirstLogin
{
    AppDelegate * app=[UIApplication sharedApplication].delegate;
    
    
    NSFetchRequest * pwdReq=[[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray * users=[app.managedObjectContext executeFetchRequest:pwdReq error:nil];
    User*user=[users lastObject];
    
    return [user.isFirstLogin integerValue]==1?YES:NO;
}

#pragma mark - 更改为已经登陆
+(void)didLogin
{
    AppDelegate * app=[UIApplication sharedApplication].delegate;
    
    
    NSFetchRequest * pwdReq=[[NSFetchRequest alloc] initWithEntityName:@"User"];
    NSArray * users=[app.managedObjectContext executeFetchRequest:pwdReq error:nil];
    if (users.count>0)
    {
        User * user=[users lastObject];
        user.isFirstLogin=[NSNumber numberWithInt:0];
        [app saveContext];
        NSError*error;
        BOOL isSaveSuccess=[app.managedObjectContext save:&error];
        NSLog(isSaveSuccess?@"更改为已经登陆过":@"初次登陆修改失败");
    }
    else
    {
        NSLog(@"初次登陆修改失败");
    }
    
}




@end
