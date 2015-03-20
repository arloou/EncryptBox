//
//  AccountDetailTableViewController.m
//  EncryptBox
//
//  Created by ucs on 15/3/4.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "AccountDetailTableViewController.h"
#import "AccountDetailTableViewCell.h"
#import "LZZFetchManager.h"

@interface AccountDetailTableViewController ()<UIAlertViewDelegate,EncryptAnimationDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet LZZTextField *mainTf;

@property (strong, nonatomic) IBOutlet LZZTextField *subTf;

@property (strong, nonatomic) IBOutlet LZZTextField *userTf;

@property (strong, nonatomic) IBOutlet LZZTextField *pwdTf;

@property (strong, nonatomic) IBOutlet LZZTextField *phoneTf;

@property (strong, nonatomic) IBOutlet LZZTextField *emailTf;

@property (strong, nonatomic) IBOutlet LZZTextField *infoTf;

@property (strong, nonatomic) IBOutletCollection(LZZTextField) NSArray *allTfs;

@property (strong, nonatomic) IBOutlet UIButton *clearBtn;

@property(nonatomic,assign)EBOXLanguage currentLanguage;


@property(nonatomic,assign)BOOL hasText;

@property(nonatomic,strong)NSArray*typeArray;
@end

@implementation AccountDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentLanguage=[LZZSetting getCurrentLanguage];
    
    // 回退按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor greenColor];
    
    
    if (_isAddAccount)
    {
        self.title=_currentLanguage==EBOXEnglish?@"Add":@"添加账户";
        UIBarButtonItem*bbi_save=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAccount)];
        self.navigationItem.rightBarButtonItem=bbi_save;
    }
    else
    {
        self.title=_currentLanguage==EBOXEnglish?@"Detail Info":@"账户信息";
        UIBarButtonItem*bbi_save=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAccount)];
        UIBarButtonItem*bbi_del=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeAccount)];
        self.navigationItem.rightBarButtonItems=@[bbi_save,bbi_del];
        
        [self showAccountInfo];
    }
    
    
    UIView*bgview=[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [bgview setBackgroundColor:[UIColor colorWithRed:0.11 green:0.12 blue:0.13 alpha:1]];
    self.tableView.backgroundView=bgview;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    for (UITextField*tf in _allTfs)
    {
        tf.delegate=self;
    }
    
    _clearBtn.layer.cornerRadius=30;
    _clearBtn.layer.borderWidth=0.5;
    _clearBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    
    _hasText=YES;
    
}

-(void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)showAccountInfo
{
    if (!_thisAccount)
    {
        return;
    }
    
    _mainTf.text=_thisAccount.companyName;
    _subTf.text=_thisAccount.productName;
    _userTf.text=_thisAccount.userName;
    _pwdTf.text=[[NSString alloc] initWithData:_thisAccount.passWord encoding:NSUTF8StringEncoding];
    _phoneTf.text=_thisAccount.bingdingPhoneNumber;
    _emailTf.text=_thisAccount.bingdingEmail;
    _infoTf.text=_thisAccount.otherInfo;
    
}

-(void)saveAccount
{
    if (![self checkInput])
    {
        [self showSimpleAlert:_currentLanguage==EBOXEnglish?@"Information is not complete!":@"必须信息未完整！"];
    }
    else
    {
        [ProgressHUD show:_currentLanguage==EBOXEnglish?@"Encrypting force...":@"高强度加密中..."];
        LZZAccount*acc=[LZZAccount account];
        acc.companyName=_mainTf.text;
        acc.productName=_subTf.text;
        acc.userName=_userTf.text;
        acc.passWord=[_pwdTf.text dataUsingEncoding:NSUTF8StringEncoding];
        acc.bingdingPhoneNumber=_phoneTf.text;
        acc.bingdingEmail=_emailTf.text;
        acc.otherInfo=_infoTf.text;
        
        // save account
        if (_isAddAccount) {
            [LZZFetchManager addAccount:acc];
        }
        else
        {
            [LZZFetchManager editAccountByIndex:_accountIndex withNewAccount:acc];
        }
        
        
        for (int i=0; i<_allTfs.count;i++)
        {
            LZZTextField*tf=_allTfs[i];
            tf.animationDelegate=self;
            tf.tag=i;
        }
        [_mainTf startAnimationWithPerDuration:1.5];
    }
}

-(void)animationDidEndWithTag:(int)tag
{
    if (tag==_allTfs.count-1)
    {
        [ProgressHUD showSuccess:_currentLanguage==EBOXEnglish?@"Done!":@"完成！"];
        [UIView animateWithDuration:1 animations:^{
            self.tableView.layer.opacity=0;
        } completion:^(BOOL finished) {
#pragma mark - 页面回退
            AccountLIstTableViewController*lastVC=self.navigationController.viewControllers[0];
            lastVC.needReloadData=YES;
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }
    else
    {
        LZZTextField*tf=_allTfs[tag+1];
        [tf startAnimationWithPerDuration:1.5];
    }
}

-(void)removeAccount
{
    UIAlertView*av;
    if(_currentLanguage==EBOXEnglish)
    {
        av=[[UIAlertView alloc] initWithTitle:@"WARNNING!" message:@"Are you sure to delete this account?" delegate:self cancelButtonTitle:@"Delete it!" otherButtonTitles:@"Not Sure...",nil];
    }
    else{
        av=[[UIAlertView alloc] initWithTitle:@"警告!" message:@"确定要删除此账户?" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"不删",nil];
    }
    
    av.tag=11;
    [av show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11)
    {
        if (buttonIndex!=0)
        {
            return;
        }
        else
        {
            [LZZFetchManager deleteAccountByIndex:_accountIndex];
#pragma mark - 页面回退
            AccountLIstTableViewController*lastVC=self.navigationController.viewControllers[0];
            lastVC.needReloadData=YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


-(BOOL)checkInput
{
    NSArray*allTf=@[_mainTf,_subTf,_userTf,_pwdTf];
    for (UITextField*tf in allTf)
    {
        if (tf.text.length<1)
        {
            return NO;
        }
    }
    return YES;
}

-(void)showSimpleAlert:(NSString*)alertMessage
{
    UIAlertView*av=[[UIAlertView alloc] initWithTitle:alertMessage message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [av show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clearBtnTouchDown:(UIButton *)sender {
    
    
    [UIView animateWithDuration:0.05 animations:^{
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.4, 1.4);
    } completion:^(BOOL finished) {
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }];
    
    
}


- (IBAction)clearAll:(id)sender {
    
    if (!_hasText)
    {
        return;
    }
    
    for (UITextField*tf in _allTfs)
    {
        for (id lb in tf.subviews)
        {
            if ([lb isKindOfClass:[UILabel class]])
            {
                UILabel*lable=lb;
                [UIView animateWithDuration:0.5 animations:^{
                    lable.transform=CGAffineTransformScale(CGAffineTransformIdentity,1.8, 1.8);
                    lable.layer.opacity=0;
                } completion:^(BOOL finished) {
                    tf.text=@"";
                    _hasText=NO;
                    lable.transform=CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
                    lable.layer.opacity=1;
                }];
            }
        }
    }

    
}

#pragma mark - textFile delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _hasText=YES;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
