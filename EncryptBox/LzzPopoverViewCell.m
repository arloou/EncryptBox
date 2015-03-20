//
//  LzzPopoverViewCell.m
//  EncryptBox
//
//  Created by ucs on 15/3/11.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LzzPopoverViewCell.h"

@implementation LzzPopoverViewCell

- (void)awakeFromNib {
    // Initialization code
    _logoImageView.image=nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
