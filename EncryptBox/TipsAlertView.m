//
//  TipsAlertView.m
//  EncryptBox
//
//  Created by ucs on 15/1/27.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "TipsAlertView.h"

@implementation TipsAlertView

+(void)showInTarget:(UIViewController*)target withMessage:(NSString*)message andTextColor:(UIColor *)textColor
{
    UILabel*label=[[UILabel alloc] initWithFrame:CGRectMake(0, -40, MainWidth, 40)];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=message;
    label.font=[UIFont fontWithName:@"Papyrus" size:15];
    label.textColor=textColor;
    label.layer.opacity=0;
    [target.view addSubview:label];
    
    [UIView animateWithDuration:2 animations:^{
        [label setFrame:CGRectMake(0, 0, MainWidth, 40)];
        label.layer.opacity=1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2 animations:^{
            [label setFrame:CGRectMake(0, -40, MainWidth, 40)];
            label.layer.opacity=0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
    
}

@end