//
//  singleCharView.m
//  EncryptBox
//
//  Created by ucs on 15/1/21.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "singleCharView.h"
#import "EmitterView.h"

@implementation singleCharView
{
    CAEmitterLayer *fireEmitter;
    UIView *emitterView;
    CAKeyframeAnimation *animation;
    BOOL   hasAnimate;
    NSTimer*timer;
}

-(void)awakeFromNib
{
    self.layer.borderWidth=01;
    self.layer.borderColor=[UIColor greenColor].CGColor;
    self.bounds=CGRectMake(0, 0, 55, 55);
    self.label.text=@"";
    self.label.font=[UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:30];
    
    timer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(checkingText) userInfo:nil repeats:YES];
    
}


-(void)checkingText
{
    if (self.label.text.length>0&&![self.label.text isEqualToString:@"※"])
    {
        self.label.text=@"※";
    }
}


-(void)startAnimate
{
    hasAnimate=YES;
    if (!emitterView)
    {
        emitterView = [[EmitterView alloc] initWithFrame:CGRectZero];
        [self addSubview:emitterView];
    }
    [self setNeedsDisplay];

}
-(void)stopAnimate
{
    hasAnimate=NO;
    if (emitterView)
    {
        [emitterView removeFromSuperview];
        emitterView=nil;
    }
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
    if (hasAnimate)
    {
        //绘制路径
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathAddRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        
        animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.duration = 3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        animation.repeatCount = MAXFLOAT;
        animation.path = path;
        [emitterView.layer addAnimation:animation forKey:@"test"];
    }
}

@end
