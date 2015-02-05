//
//  SoundBox.m
//  EncryptBox
//
//  Created by ucs on 15/1/26.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "SoundBox.h"


static SoundBox *soundBox = nil;
static SystemSoundID soundID_success;
static SystemSoundID soundID_failed;
static SystemSoundID soundID_hacker;

@implementation SoundBox

+(void)playSound:(SoundType)soundType
{
    if (!soundBox)
    {
        soundBox=[[SoundBox alloc] init];
        NSString *path_success = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
        NSString *path_failed = [[NSBundle mainBundle] pathForResource:@"failed" ofType:@"wav"];
        NSString *path_Hacker = [[NSBundle mainBundle] pathForResource:@"hacker" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path_success], &soundID_success);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path_failed], &soundID_failed);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path_Hacker], &soundID_hacker);
    }
    switch (soundType)
    {
        case SoundTypeSuccess:
        {
            AudioServicesPlaySystemSound (soundID_success);
        }
            break;
        case SoundTypeFailed:
        {
            AudioServicesPlaySystemSound (soundID_failed);
        }
            break;
        case SoundTypeHacker:
        {
            AudioServicesPlaySystemSound (soundID_hacker);
        }
            break;
            
        default:
            break;
    }
}
@end
