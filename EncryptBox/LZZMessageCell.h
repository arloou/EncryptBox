//
//  LZZMessageCell.h
//  EncryptBox
//
//  Created by ucs on 15/3/11.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTypewriteEffectLabel.h"
#define Font_En [UIFont  fontWithName:@"Copperplate" size:17]
#define Font_Ch [UIFont  systemFontOfSize:17]


@interface LZZMessageCell : UITableViewCell
@property(nonatomic,copy)NSString * message;
@property (strong, nonatomic) IBOutlet ZTypewriteEffectLabel *messageLabel;
@property(nonatomic,assign)EBOXLanguage  currentLanguage;
@end
