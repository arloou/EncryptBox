//
//  IntroductionViewController.m
//  EncryptBox
//
//  Created by ucs on 15/1/27.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "IntroductionViewController.h"
#import "DataAnimateView.h"
#import "SoundBox.h"
#import "MainViewController.h"

@interface IntroductionViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property(nonatomic,strong)NSTimer*timer;
@property(nonatomic,strong)NSTimer*sound_timer;
@property(nonatomic,strong)NSMutableArray*bottle;
@property(nonatomic,assign)CGFloat changeOpacity;
@property(nonatomic,assign)CGFloat changeScale;
@property(nonatomic,assign)CGAffineTransform bgTransform;
@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _changeOpacity=1;
    _bgImageView.layer.opacity=0;
    
    _changeScale=1;
    _bgTransform=_bgImageView.transform;
    
    _sound_timer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(playSound) userInfo:nil repeats:YES];
    
    self.view.backgroundColor=[UIColor blackColor];
    _bottle=[NSMutableArray array];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(enterAnimate) userInfo:nil repeats:YES];
    
}

-(void)playSound
{
    [SoundBox playSound:SoundTypeHacker];
}

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
    
    // bgImageView Opacity
    if (_bgImageView.layer.opacity>0.9)
    {
        _changeOpacity=-1;
    }
    if (_bgImageView.layer.opacity<0.1)
    {
        _changeOpacity=+1;
    }
    _bgImageView.layer.opacity+=0.2*_changeOpacity;
    
    
    // bgImageView Scale
    _changeScale+=_changeScale * 0.02;
    NSLog(@"%.2f",_changeScale);
    _bgImageView.transform=CGAffineTransformScale(_bgTransform, _changeScale, _changeScale);
    
    
    // init DataView
    DataAnimateView*dataView=[[DataAnimateView alloc] init];
    [_bottle addObject:dataView];
    [self.view addSubview:dataView];
    [dataView startToMove];
    
    if (_changeScale>27)
    {
        [_bgImageView removeFromSuperview];
        [self cleanTimer];
        MainViewController*vc=[self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self cleanTimer];
    MainViewController*vc=[self.storyboard instantiateViewControllerWithIdentifier:@"mainView"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cleanTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self cleanTimer];
}

-(void)cleanTimer
{
    if (_timer)
    {
        [_timer invalidate];
        _timer=nil;
    }
    if (_sound_timer)
    {
        [_sound_timer invalidate];
        _sound_timer=nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
