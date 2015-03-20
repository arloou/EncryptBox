//
//  ViewController.m
//  EncryptBox
//
//  Created by ucs on 15/1/20.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "ViewController.h"
#import "singleCharView.h"
#import "AFViewShaker.h"
#import "CoreDataManger.h"
#import "SoundBox.h"
//#import "IntroductionViewController.h"
#import "AccountLIstTableViewController.h"
#import "DataAnimateView.h"

#define CharView_1_Center CGPointMake([UIScreen mainScreen].bounds.size.width/5, 150)
#define CharView_2_Center CGPointMake([UIScreen mainScreen].bounds.size.width/5*2, 150)
#define CharView_3_Center CGPointMake([UIScreen mainScreen].bounds.size.width/5*3, 150)
#define CharView_4_Center CGPointMake([UIScreen mainScreen].bounds.size.width/5*4, 150)

#define DURATION 0.5



//Frame

@interface ViewController ()<UITextFieldDelegate>

@property (strong, nonatomic)  UITextField *tf;

@property (strong, nonatomic)  singleCharView *charView1;
@property (strong, nonatomic)  singleCharView *charView2;
@property (strong, nonatomic)  singleCharView *charView3;
@property (strong, nonatomic)  singleCharView *charView4;
@property(strong, nonatomic) AFViewShaker *shaker;
@property(strong,nonatomic) UIButton *registerBtn;

// register
@property(strong,nonatomic)UITextField *orignPwdTf;
@property(strong,nonatomic)UITextField *pwdTf;
@property(strong,nonatomic)UITextField *verifyPwdTf;
@property(nonatomic,assign)BOOL isRegistering;

// animation
@property(nonatomic,strong)NSTimer*timer;
@property(nonatomic,strong)NSMutableArray*bottle;

// UIGestureReconizer
@property(nonatomic,strong)UISwipeGestureRecognizer*swipe;

@property(nonatomic,assign)EBOXLanguage  currentLanguage;

@property (strong, nonatomic) IBOutlet UILabel *bottomLabelA; //Welcome to use EncryptBox
@property (strong, nonatomic) IBOutlet UILabel *bottomLabelB; //Your safe box™


@end

@implementation ViewController
{
    // 用来接受字符的四个String
    NSString*str1;
    NSString*str2;
    NSString*str3;
    NSString*str4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=MainBGColor;
}


#pragma mark - 背景动画

-(void)enterAnimate
{
    // clean DataView
    if (_bottle.count>100) {
        for (int i=0; i<_bottle.count; i++)
        {
            if (i%5==0)
            {
                [_bottle[i] removeFromSuperview];
                [_bottle removeObject:_bottle[i]];
            }
        }
    }
    
    // init DataView
    DataAnimateView*dataView=[[DataAnimateView alloc] init];
    [_bottle addObject:dataView];
    [self.view addSubview:dataView];
    [dataView startToMove];
    
    
    
}


-(void)initUI
{
    
    BOOL isEng=_currentLanguage==EBOXEnglish?YES:NO;
    
    //[self.view setBackgroundColor:[UIColor blackColor]];
    _charView1=[[[NSBundle mainBundle] loadNibNamed:@"singleCharView" owner:self options:nil] lastObject];
    _charView2=[[[NSBundle mainBundle] loadNibNamed:@"singleCharView" owner:self options:nil] lastObject];
    _charView3=[[[NSBundle mainBundle] loadNibNamed:@"singleCharView" owner:self options:nil] lastObject];
    _charView4=[[[NSBundle mainBundle] loadNibNamed:@"singleCharView" owner:self options:nil] lastObject];
    
    _charView1.center=CharView_1_Center;
    _charView2.center=CharView_2_Center;
    _charView3.center=CharView_3_Center;
    _charView4.center=CharView_4_Center;
    
    [_charView1 startAnimate];
    
    [self.view addSubview:_charView1];
    [self.view addSubview:_charView2];
    [self.view addSubview:_charView3];
    [self.view addSubview:_charView4];
    
    // Tap
    [_charView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKB:)]];
    [_charView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKB:)]];
    [_charView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKB:)]];
    [_charView4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKB:)]];
    
    // AFViewShaker
    _shaker=[[AFViewShaker alloc] initWithViewsArray:@[_charView1,_charView2,_charView3,_charView4]];
    
    
    // textField(hide)
    _tf=[[UITextField alloc] initWithFrame:CGRectMake(0, -40, MainWidth, 20)];
    _tf.tag=11;
    _tf.borderStyle=UITextBorderStyleNone;
    _tf.backgroundColor=[UIColor clearColor];
    _tf.textColor=[UIColor clearColor];
    _tf.layer.opacity=0;
    _tf.keyboardType=UIKeyboardTypeNumberPad;
    _tf.keyboardAppearance=UIKeyboardAppearanceDark;
    _tf.secureTextEntry=YES;
    [self.view addSubview:_tf];
    self.tf.delegate=self;
    
    
    
    
    
    // register button
    _registerBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_registerBtn setFrame:CGRectMake(60, 220, 160, 30)];
    _registerBtn.center=CGPointMake(MainWidth/2, _registerBtn.center.y);
    _registerBtn.layer.borderWidth=0.5;
    _registerBtn.layer.borderColor=[UIColor greenColor].CGColor;
    _registerBtn.tintColor=[UIColor clearColor];
    NSString*btnTitle;
    if (isEng) {
        btnTitle=@"Set a New PassWord";
    }else{
        btnTitle=@"设置新密码";
    }
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName]=[UIFont fontWithName:@"Papyrus" size:12];
    textAttrs[NSForegroundColorAttributeName]=[UIColor greenColor];
    
    NSAttributedString*attributeStr=[[NSAttributedString alloc] initWithString:btnTitle attributes:textAttrs];
    
    [_registerBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(registerNewPwd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
    
    
    // register TextField
    _orignPwdTf=[[UITextField alloc] initWithFrame:CGRectMake(MainWidth+10, 40, 200, 44)];
    _pwdTf=[[UITextField alloc] initWithFrame:CGRectMake(MainWidth+10, 100, 200, 44)];
    _verifyPwdTf=[[UITextField alloc] initWithFrame:CGRectMake(MainWidth+10, 160, 200, 44)];
    
    _orignPwdTf.tag=22;
    _pwdTf.tag=33;
    _verifyPwdTf.tag=44;
    
    _orignPwdTf.delegate=self;
    _pwdTf.delegate=self;
    _verifyPwdTf.delegate=self;
    
    _orignPwdTf.borderStyle=UITextBorderStyleNone;
    _pwdTf.borderStyle=UITextBorderStyleNone;
    _verifyPwdTf.borderStyle=UITextBorderStyleNone;
    
    //_orignPwdTf.backgroundColor=[UIColor clearColor];
    _orignPwdTf.layer.borderColor=[UIColor greenColor].CGColor;
    _orignPwdTf.layer.borderWidth=1;
    _orignPwdTf.placeholder=isEng?@"pre password":@"原密码";
    _orignPwdTf.textColor=[UIColor greenColor];
    _orignPwdTf.textAlignment=NSTextAlignmentCenter;
    
    //_pwdTf.backgroundColor=[UIColor clearColor];
    _pwdTf.layer.borderColor=[UIColor greenColor].CGColor;
    _pwdTf.layer.borderWidth=1;
    _pwdTf.placeholder=isEng?@"new(4 charaters)":@"新密码(4个数字)";
    _pwdTf.textColor=[UIColor greenColor];
    _pwdTf.textAlignment=NSTextAlignmentCenter;
    
    //_verifyPwdTf.backgroundColor=[UIColor clearColor];
    _verifyPwdTf.layer.borderColor=[UIColor greenColor].CGColor;
    _verifyPwdTf.layer.borderWidth=1;
    _verifyPwdTf.placeholder=isEng?@"again":@"密码确认";
    _verifyPwdTf.textColor=[UIColor greenColor];
    _verifyPwdTf.textAlignment=NSTextAlignmentCenter;
    
    [_orignPwdTf setValue:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    [_pwdTf setValue:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    [_verifyPwdTf setValue:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.2] forKeyPath:@"_placeholderLabel.textColor"];
    
    _orignPwdTf.keyboardAppearance=UIKeyboardAppearanceDark;
    _pwdTf.keyboardAppearance=UIKeyboardAppearanceDark;
    _verifyPwdTf.keyboardAppearance=UIKeyboardAppearanceDark;
    
    
    _orignPwdTf.keyboardType=UIKeyboardTypeNumberPad;
    _pwdTf.keyboardType=UIKeyboardTypeNumberPad;
    _verifyPwdTf.keyboardType=UIKeyboardTypeNumberPad;
    
    _orignPwdTf.secureTextEntry=YES;
    _pwdTf.secureTextEntry=YES;
    _verifyPwdTf.secureTextEntry=YES;
    
    [self.view addSubview:_orignPwdTf];
    [self.view addSubview:_pwdTf];
    [self.view addSubview:_verifyPwdTf];
    
    
    [self changeBottomLabel];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _currentLanguage=[LZZSetting getCurrentLanguage];
    _isRegistering=NO;
    [self initUI];
    
    _swipe=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToLogin)];
    [_swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:_swipe];
    
    
    _bottle=[NSMutableArray array];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enterAnimate) userInfo:nil repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tf becomeFirstResponder];
    });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tf resignFirstResponder];
    [_orignPwdTf resignFirstResponder];
    [_pwdTf resignFirstResponder];
    [_verifyPwdTf resignFirstResponder];
}

#pragma mark - 回到登录页面
-(void)backToLogin
{
    if ([_registerBtn.titleLabel.text isEqualToString:@"Verify"]||[_registerBtn.titleLabel.text isEqualToString:@"提交"])
    {
        [UIView animateWithDuration:DURATION animations:^{
            [self setLoginUI];
        }];
        
        [_tf becomeFirstResponder];
        [self clearAllTextField];
        _isRegistering=NO;
    }
}

#pragma mark - show KEYBOARD
-(void)showKB:(id)sender
{
    [_tf becomeFirstResponder];
}

#pragma mark - 设置密码
-(void)registerNewPwd:(id)sender
{
    BOOL isEng=_currentLanguage==EBOXEnglish?YES:NO;
    [UIView animateWithDuration:DURATION animations:^{
        if (![_registerBtn.titleLabel.text isEqualToString:@"Verify"]&&![_registerBtn.titleLabel.text isEqualToString:@"提交"])
        {
            NSString*btnTitle=isEng?@"Verify":@"提交";
            NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
            textAttrs[NSFontAttributeName]=[UIFont fontWithName:@"Papyrus" size:12];
            textAttrs[NSForegroundColorAttributeName]=[UIColor greenColor];
            NSAttributedString*attributeStr=[[NSAttributedString alloc] initWithString:btnTitle attributes:textAttrs];
            [_registerBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
            
            _charView1.center=CGPointMake(CharView_1_Center.x-MainWidth, CharView_1_Center.y);
            _charView2.center=CGPointMake(CharView_2_Center.x-MainWidth, CharView_2_Center.y);
            _charView3.center=CGPointMake(CharView_3_Center.x-MainWidth, CharView_3_Center.y);
            _charView4.center=CGPointMake(CharView_4_Center.x-MainWidth, CharView_4_Center.y);
            
            _orignPwdTf.center=CGPointMake(MainWidth/2, _orignPwdTf.center.y);
            _pwdTf.center=CGPointMake(MainWidth/2, _pwdTf.center.y);
            _verifyPwdTf.center=CGPointMake(MainWidth/2, _verifyPwdTf.center.y);
            
            
            if ([CoreDataManger hasEnterPwd])
            {
                [_orignPwdTf setHidden:NO];
                [_orignPwdTf becomeFirstResponder];
            }
            else
            {
                [_orignPwdTf setHidden:YES];
                [_pwdTf becomeFirstResponder];
            }
            
            
            
            
        }
        else
        {
            // 按下确认键 从头到尾判断
            if ([CoreDataManger hasEnterPwd])
            {
                if (![_orignPwdTf.text isEqualToString:[CoreDataManger getCurrentEnterPassword]])
                {
                    [SoundBox playSound:SoundTypeFailed];
                    AFViewShaker*shaker=[[AFViewShaker alloc] initWithView:_orignPwdTf];
                    [shaker shake];
                    return ;
                }
            }
            
            if (![_pwdTf.text isEnterPwdFormatter])
            {
                [SoundBox playSound:SoundTypeFailed];
                AFViewShaker*shaker=[[AFViewShaker alloc] initWithView:_pwdTf];
                [shaker shake];
                return ;
            }
            
            if (![_verifyPwdTf.text isEqualToString:_pwdTf.text])
            {
                [SoundBox playSound:SoundTypeFailed];
                AFViewShaker*shaker=[[AFViewShaker alloc] initWithView:_verifyPwdTf];
                [shaker shake];
                return ;
            }
            
            
            
            // 如果修改密码成功
            if ([CoreDataManger updateEnterPassword:_pwdTf.text])
            {
                [SoundBox playSound:SoundTypeSuccess];
                [TipsAlertView showInTarget:self withMessage:isEng?@"Success!":@"成功!" andTextColor:[UIColor greenColor]];
                [self setLoginUI];
                [self clearAllTextField];
            }
            else
            {
                [SoundBox playSound:SoundTypeFailed];
                // 如果修改不成功
                AFViewShaker * shaker=[[AFViewShaker alloc] initWithViewsArray:@[_orignPwdTf,_pwdTf,_verifyPwdTf]];
                [shaker shake];
            }

            
            
        }
        
    } completion:^(BOOL finished) {

        
    }];
}

#pragma mark - 清空textfield
-(void)clearAllTextField
{
    _tf.text=@"";
    _orignPwdTf.text=@"";
    _pwdTf.text=@"";
    _verifyPwdTf.text=@"";
    
    _charView1.label.text=@"";
    _charView2.label.text=@"";
    _charView3.label.text=@"";
    _charView4.label.text=@"";
    
    
    _orignPwdTf.layer.borderColor=[UIColor greenColor].CGColor;
    _pwdTf.layer.borderColor=[UIColor greenColor].CGColor;
    _verifyPwdTf.layer.borderColor=[UIColor greenColor].CGColor;
}

#pragma mark - 设置密码成功后回到开始页面
-(void)setLoginUI
{
    NSString*btnTitle;
    if ([LZZSetting getCurrentLanguage]==EBOXEnglish) {
        btnTitle=@"Set a New PassWord";
    }else{
        btnTitle=@"设置新密码";
    }
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName]=[UIFont fontWithName:@"Papyrus" size:12];
    textAttrs[NSForegroundColorAttributeName]=[UIColor greenColor];
    NSAttributedString*attributeStr=[[NSAttributedString alloc] initWithString:btnTitle attributes:textAttrs];
    [_registerBtn setAttributedTitle:attributeStr forState:UIControlStateNormal];
    
    _charView1.center=CharView_1_Center;
    _charView2.center=CharView_2_Center;
    _charView3.center=CharView_3_Center;
    _charView4.center=CharView_4_Center;
    
    _orignPwdTf.center=CGPointMake(MainWidth/2*3, _orignPwdTf.center.y);
    _pwdTf.center=CGPointMake(MainWidth/2*3, _pwdTf.center.y);
    _verifyPwdTf.center=CGPointMake(MainWidth/2*3, _verifyPwdTf.center.y);
    [_tf becomeFirstResponder];
}

#pragma mark - Login
-(void)login
{
    NSString * passWord =[NSString stringWithFormat:@"%@%@%@%@",str1,str2,str3,str4];
    NSString *enterPwd=[CoreDataManger getCurrentEnterPassword];
    if ([passWord isEqualToString:enterPwd])
    {
        [SoundBox playSound:SoundTypeSuccess];
        
        
        AccountLIstTableViewController*vc=[self.storyboard instantiateViewControllerWithIdentifier:@"accountList"];
        UINavigationController*nvc=[[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:nil];
        
        [self clearAllTextField];
    }
    else
    {
        [SoundBox playSound:SoundTypeFailed];
        [_shaker shake];
    }
}


#pragma mark - 对象序列化 用于复制
- (NSMutableArray*)duplicate:(NSArray*)objects
{
    NSMutableArray*newArr=[NSMutableArray new];
    for (id obj in objects)
    {
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:obj];
        [newArr addObject:[NSKeyedUnarchiver unarchiveObjectWithData:tempArchive]];
    }
    
    return newArr;
}


#pragma mark - TextField delegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 11:
        {
            
        }
            break;
        case 22:
        {
            if (![textField.text isEqualToString:[CoreDataManger getCurrentEnterPassword]]) {
                textField.layer.borderColor=[UIColor redColor].CGColor;
            }
            else
            {
                textField.layer.borderColor=[UIColor greenColor].CGColor;
            }
        }
            break;
        case 33:
        {
            if (![textField.text isEnterPwdFormatter])
            {
                textField.layer.borderColor=[UIColor redColor].CGColor;
            }
            else
            {
                textField.layer.borderColor=[UIColor greenColor].CGColor;
            }
        }
            break;
        case 44:
        {
            if (![textField.text isEqualToString:_pwdTf.text])
            {
                textField.layer.borderColor=[UIColor redColor].CGColor;
            }
            else
            {
                textField.layer.borderColor=[UIColor greenColor].CGColor;
            }
        }
            break;
            
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    if (textField.tag==11)
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        switch (range.location)
        {
            case 0:
            {
                _charView1.label.text=string;
                str1=string;
                if (string.length>0)
                {
                    [_charView1 stopAnimate];
                    [_charView3 stopAnimate];
                    [_charView4 stopAnimate];
                    [_charView2 startAnimate];
                }
                else
                {
                    [_charView2 stopAnimate];
                    [_charView3 stopAnimate];
                    [_charView4 stopAnimate];
                    [_charView1 startAnimate];
                }
                
            }
                break;
            case 1:
            {
                _charView2.label.text=string;
                str2=string;
                if (string.length>0)
                {
                    [_charView1 stopAnimate];
                    [_charView2 stopAnimate];
                    [_charView4 stopAnimate];
                    [_charView3 startAnimate];
                }
                else
                {
                    [_charView1 stopAnimate];
                    [_charView3 stopAnimate];
                    [_charView4 stopAnimate];
                    [_charView2 startAnimate];
                }
                
            }
                break;
            case 2:
            {
                _charView3.label.text=string;
                str3=string;
                if (string.length>0)
                {
                    [_charView1 stopAnimate];
                    [_charView2 stopAnimate];
                    [_charView3 stopAnimate];
                    [_charView4 startAnimate];
                }
                else
                {
                    [_charView1 stopAnimate];
                    [_charView2 stopAnimate];
                    [_charView4 stopAnimate];
                    [_charView3 startAnimate];
                }
                
            }
                break;
            case 3:
            {
                _charView4.label.text=string;
                str4=string;
                if (string.length>0)
                {
                    [_charView1 stopAnimate];
                    [_charView2 stopAnimate];
                    [_charView3 stopAnimate];
                    [_charView4 stopAnimate];
                    
                    
                    // 这时候四位数输入完了 去判断登录
                    
                    [self login];
                }
                else
                {
                    [_charView1 stopAnimate];
                    [_charView2 stopAnimate];
                    [_charView3 stopAnimate];
                    [_charView4 startAnimate];
                }
                
            }
                break;
                
            default:
            {
                [_shaker shake];
                return NO;
            }
                break;
        }
    }
    
    
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [_tf removeFromSuperview];
    [_charView1 removeFromSuperview];
    [_charView2 removeFromSuperview];
    [_charView3 removeFromSuperview];
    [_charView4 removeFromSuperview];
    _shaker=nil;
    [_registerBtn removeFromSuperview];
    
    [_orignPwdTf removeFromSuperview];
    [_pwdTf removeFromSuperview];
    [_verifyPwdTf removeFromSuperview];
    
    [_timer invalidate];
    _timer = nil;
    
    _swipe=nil;
    
    
}

-(void)changeBottomLabel
{
    BOOL isEng=_currentLanguage==EBOXEnglish?YES:NO;
    NSMutableAttributedString * attStrA=[[NSMutableAttributedString alloc] initWithAttributedString:_bottomLabelA.attributedText];
    [attStrA replaceCharactersInRange:NSMakeRange(0, attStrA.length) withString:isEng?@"Welcome to use EncryptBox":@"欢迎使用EncryptBox"];
    _bottomLabelA.attributedText=attStrA;
    NSMutableAttributedString * attStrB=[[NSMutableAttributedString alloc] initWithAttributedString:_bottomLabelB.attributedText];
    [attStrB replaceCharactersInRange:NSMakeRange(0, attStrB.length) withString:isEng?@"Your safe box™":@"你最安全的密码箱™"];
    _bottomLabelB.attributedText=attStrB;
    
}


- (void)didReceiveMemoryWarning {
    NSLog(@"内存爆了");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
