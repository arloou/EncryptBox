//
//  DataAnimateView.m
//  EncryptBox
//
//  Created by ucs on 15/1/27.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "DataAnimateView.h"

@implementation DataAnimateView
{
    NSTimer*thisTimer;
    int speed;
}

-(instancetype)init
{
    self=[super init];
    if (self)
    {
        int multipleNum=rand()%3+1;
        [self setFrame:CGRectMake(arc4random()%(int)MainWidth, Mainheight, 5*multipleNum, 100*multipleNum)];
        self.backgroundColor=[UIColor clearColor];
        
        for (int i=0; i<self.bounds.size.height/self.bounds.size.width; i++)
        {
            UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.width*i, self.bounds.size.width, self.bounds.size.width)];
            label.textAlignment=NSTextAlignmentCenter;
            label.font=[UIFont fontWithName:@"Helvetica-Bold" size:12+multipleNum];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor colorWithRed:0 green:1 blue:0 alpha:0.1+0.1*(rand()%4)];

            char x=(char)('0'+(arc4random_uniform(50)));
            NSString*charStr=[NSString stringWithFormat:@"%c",x];
            label.text=charStr;
            
            [self addSubview:label];
            
            speed=1+rand()%3;
            
        }
        
    }
    
    
    return self;
}

-(void)startToMove
{
    thisTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(startAnimate) userInfo:nil repeats:YES];
}

-(void)startAnimate
{
    
    CGPoint center=self.center;
    center.y=center.y-speed;
    self.center=center;
    
    if (self.frame.origin.y<-self.bounds.size.height)
    {
        [thisTimer invalidate];
        thisTimer=nil;
        [self removeFromSuperview];
    }
    
    
}

-(void)dealloc
{
    if (thisTimer)
    {
        [thisTimer invalidate];
        thisTimer=nil;
    }
    
}


@end
