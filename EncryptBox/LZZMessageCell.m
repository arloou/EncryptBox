//
//  LZZMessageCell.m
//  EncryptBox
//
//  Created by ucs on 15/3/11.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LZZMessageCell.h"

@implementation LZZMessageCell

- (void)awakeFromNib {

}

-(void)setMessage:(NSString *)message
{
    _message=message;
    
    UIFont*contentFont=_currentLanguage==EBOXEnglish?Font_En:Font_Ch;
    CGFloat contentLabelMaxW = MainWidth-40;
    CGRect labelRect= [message boundingRectWithSize:CGSizeMake(contentLabelMaxW, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentFont,NSFontAttributeName, nil] context:nil];
    CGFloat cellHeight=labelRect.size.height+16;
    [self setFrame:CGRectMake(0, 0, MainWidth, cellHeight)];
    
    _messageLabel.tag=10;
    //_messageLabel.font=contentFont;
    _messageLabel.text=message;
    //_messageLabel.textAlignment=NSTextAlignmentCenter;
    //_messageLabel.numberOfLines=0;
    //_messageLabel.lineBreakMode=NSLineBreakByCharWrapping;
    _messageLabel.textColor=[UIColor clearColor];
    _messageLabel.typewriteEffectColor = [UIColor greenColor];
    _messageLabel.hasSound = YES;
    _messageLabel.typewriteTimeInterval = 0.1;
    _messageLabel.typewriteEffectBlock = ^{
        
        NSLog(@"done");
        
    };
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
