//
//  AccountListTableViewCell.h
//  EncryptBox
//
//  Created by ucs on 15/3/4.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property(nonatomic,assign)BOOL isFromResult;

-(void)setBGHL:(BOOL)yesOrNot;

@end
