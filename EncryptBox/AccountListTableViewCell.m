//
//  AccountListTableViewCell.m
//  EncryptBox
//
//  Created by ucs on 15/3/4.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "AccountListTableViewCell.h"
#define LEFTMARGIN 78
#define RIGHTMARGIN 15

@interface AccountListTableViewCell()

@property(nonatomic,strong)UIView * bgView;

@end

@implementation AccountListTableViewCell

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor clearColor]];
    UIView*lineView=[[UIView alloc] initWithFrame:CGRectMake(LEFTMARGIN, 99.5, MainWidth-LEFTMARGIN-RIGHTMARGIN, 0.5)];
    [lineView setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.6]];
    [self addSubview:lineView];
    
    _bgView=[[UIView alloc] initWithFrame:CGRectMake(LEFTMARGIN, 0, MainWidth-LEFTMARGIN-RIGHTMARGIN, self.contentView.frame.size.height)];
    [_bgView setBackgroundColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.3]];
    _bgView.hidden=YES;
    [self.contentView insertSubview:_bgView atIndex:0];
}

-(void)setIsFromResult:(BOOL)isFromResult
{
    _isFromResult=isFromResult;
    if (isFromResult)
    {
        self.backgroundColor=[UIColor blackColor];
    }
    else
    {
        self.backgroundColor=[UIColor clearColor];
    }
    
}

-(void)setBGHL:(BOOL)yesOrNot
{
    if (yesOrNot)
    {
        [_bgView setHidden:NO];
    }
    else
    {
        [_bgView setHidden:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
