//
//  AccountLIstTableViewController.h
//  EncryptBox
//
//  Created by ucs on 15/3/4.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountLIstTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)BOOL needReloadData;
@property(nonatomic,assign)BOOL needChangeLanguage;

@end
