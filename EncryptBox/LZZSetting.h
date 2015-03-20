//
//  LZZSetting.h
//  EncryptBox
//
//  Created by ucs on 15/3/13.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EBOXLanguage) {
    EBOXEnglish=0,
    EBOXChinese,
};

@interface LZZSetting : NSObject

+(NSString *)getPlistFilePath;

+(EBOXLanguage)getCurrentLanguage;

+(void)setCurrentLanguage:(EBOXLanguage)language;

@end
