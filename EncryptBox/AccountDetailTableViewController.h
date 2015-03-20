//
//  AccountDetailTableViewController.h
//  EncryptBox
//
//  Created by ucs on 15/3/4.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZZAccount.h"
#import "LZZTextField.h"
#import "AccountLIstTableViewController.h"

@interface AccountDetailTableViewController : UITableViewController

@property(nonatomic,assign)BOOL isAddAccount;

@property(nonatomic,assign)int accountIndex;
@property(nonatomic,strong)LZZAccount*thisAccount;

@end
