//
//  SoundBox.h
//  EncryptBox
//
//  Created by ucs on 15/1/26.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSInteger, SoundType) {
    SoundTypeSuccess,
    SoundTypeFailed,
    SoundTypeClick,
    SoundTypeHacker,
};

@interface SoundBox : NSObject

+(void)playSound:(SoundType)soundType;

@end
