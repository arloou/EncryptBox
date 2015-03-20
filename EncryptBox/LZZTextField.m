//
//  LZZTextField.m
//  EncryptBox
//
//  Created by ucs on 15/3/5.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LZZTextField.h"
#define TimeInterval_EncryptAnimation 0.05

@implementation LZZTextField

-(void)awakeFromNib
{
    _duration=3;
}

-(void)startAnimationWithPerDuration:(CGFloat)duration
{
    NSLog(@"开始计时");
    _duration=duration;
    [NSTimer scheduledTimerWithTimeInterval:TimeInterval_EncryptAnimation target:self selector:@selector(changeStr:) userInfo:nil repeats:YES];
}

-(void)changeStr:(NSTimer*)timer
{
    _duration-=TimeInterval_EncryptAnimation;
    NSLog(@"开始转换 duration=%f",_duration);
    int length=self.text.length;
    if (length>0)
    {
        NSLog(@"here length=%d",length);
        
        self.text=[self getRandomWithLength:length];
        
        if (self.duration<=0)
        {
            self.text=@"●●●● ●●●●";
            [timer invalidate];
            NSLog(@"转换完成");
            [self.animationDelegate animationDidEndWithTag:self.tag];
        }

    }
    else
    {
        [timer invalidate];
        [self.animationDelegate animationDidEndWithTag:self.tag];
    }
    
    
}


-(NSString*)getRandomWithLength:(int)length
{
    if (length<=0)
    {
        return @"";
    }
    else
    {
        char data[length];
        for (int i=0; i<length; i++)
        {
            int ra=arc4random()%56;
            data[i]=(char)('A'+ra);
        }
        return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
    }
}

@end
