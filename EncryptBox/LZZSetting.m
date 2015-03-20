//
//  LZZSetting.m
//  EncryptBox
//
//  Created by ucs on 15/3/13.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LZZSetting.h"

@implementation LZZSetting


+(NSString *)getPlistFilePath
{
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString*docPath=[paths objectAtIndex:0];
    NSString*filePath=[docPath stringByAppendingPathComponent:@"ebox_setting.plist"];
    return filePath;
}

+(EBOXLanguage)getCurrentLanguage{
    NSString*filePath=[LZZSetting getPlistFilePath];
    NSMutableDictionary * setting=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    
    if (setting.count>0)
    {
        NSString * currentLang=[setting valueForKey:@"Language"];
        return [currentLang isEqualToString:@"En"]?EBOXEnglish:EBOXChinese;
    }
    else
    {
        NSLog(@"not exit");
        setting=[NSMutableDictionary dictionary];
        [setting setValue:@"En" forKey:@"Language"];
        BOOL isSuccess;
        isSuccess = [setting writeToFile:filePath atomically:YES];
        NSLog(@"成功状态:%d   filePath:%@",isSuccess,filePath);
        return EBOXEnglish;
    }
}
+(void)setCurrentLanguage:(EBOXLanguage)language{
    NSString*filePath=[LZZSetting getPlistFilePath];
    NSMutableDictionary * setting=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    if (setting.count<1) {
        setting=[NSMutableDictionary dictionary];
    }
    switch (language) {
        case EBOXEnglish:
        {
            [setting setValue:@"En" forKey:@"Language"];
        }
            break;
        case EBOXChinese:
        {
            [setting setValue:@"Ch" forKey:@"Language"];
        }
            break;
        default:
            break;
    }
    [setting writeToFile:filePath atomically:YES];
}

@end
