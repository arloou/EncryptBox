//
//  LZZSettingViewController.m
//  EncryptBox
//
//  Created by ucs on 15/3/13.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LZZSettingViewController.h"
#import "AccountLIstTableViewController.h"
#import "ViewController.h"

@interface LZZSettingViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *languageSegmentController;

@end

@implementation LZZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    EBOXLanguage  currentLang=[LZZSetting getCurrentLanguage];
    _languageSegmentController.selectedSegmentIndex=currentLang==EBOXEnglish?0:1;
    self.title=currentLang==EBOXEnglish?@"Setting":@"设置";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (IBAction)setLanguage:(UISegmentedControl *)sender {
    NSUInteger index=sender.selectedSegmentIndex;
    [LZZSetting setCurrentLanguage:index==0?EBOXEnglish:EBOXChinese];
    
    [_languageSegmentController setTitle:index==0?@"English":@"英文" forSegmentAtIndex:0];
    [_languageSegmentController setTitle:index==0?@"Chinese":@"中文" forSegmentAtIndex:1];
    self.title=index==0?@"Setting":@"设置";
    
    AccountLIstTableViewController*vc=self.navigationController.viewControllers[0];
    [vc setNeedChangeLanguage:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
