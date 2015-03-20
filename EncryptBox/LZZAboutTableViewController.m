//
//  LZZAboutTableViewController.m
//  EncryptBox
//
//  Created by ucs on 15/3/11.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "LZZAboutTableViewController.h"
#import "ZTypewriteEffectLabel.h"
#import "LZZMessageCell.h"
#import "LZZCopyRightInfoCell.h"
#import <AVFoundation/AVFoundation.h>

@interface LZZAboutTableViewController ()
@property(nonatomic,copy)NSString*message;
@property(nonatomic,assign)CGFloat messageLabelHeight;
@property(nonatomic,strong)AVAudioPlayer*player;
@property(nonatomic,assign)EBOXLanguage currentLanguage;
@end

@implementation LZZAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentLanguage=[LZZSetting getCurrentLanguage];
    
    self.title=_currentLanguage==EBOXEnglish?@"About":@"关于";
    
    NSString *stringA = [[NSBundle mainBundle] pathForResource:@"This Is Halloween" ofType:@"mp3"];
    NSString *stringB = [[NSBundle mainBundle] pathForResource:@"Tainted Love" ofType:@"mp3"];
    int a=arc4random()%2;
    NSURL *url = [NSURL fileURLWithPath:a==0?stringA:stringB];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.numberOfLoops=-1;
    _player.volume=1;
    [_player play];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LZZMessageCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LZZCopyRightInfoCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    NSDictionary * introDic=[NSDictionary dictionaryWithContentsOfFile:[DOCUMENTPATH stringByAppendingPathComponent:INTRODUCEFILENAME]];
    _message=[introDic objectForKey:_currentLanguage==EBOXEnglish?@"En":@"Ch"];

    UIFont*contentFont=_currentLanguage==EBOXEnglish?Font_En:Font_Ch;
    CGFloat contentLabelMaxW = MainWidth-40;
    CGRect labelRect= [_message boundingRectWithSize:CGSizeMake(contentLabelMaxW, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:contentFont,NSFontAttributeName, nil] context:nil];
    _messageLabelHeight=labelRect.size.height;
    
    
    // 双击手势
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap.numberOfTapsRequired=2;
    [self.view addGestureRecognizer:tap];

}

// 双击
-(void)doubleTap:(UITapGestureRecognizer*)tap
{
    LZZMessageCell*cell=(LZZMessageCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ZTypewriteEffectLabel * label=cell.messageLabel;
    if (label.isTyping)
    {
        // 直接列出
        [label stopAndShowAllText];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    LZZMessageCell*cell=(LZZMessageCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.messageLabel stop];
}


#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        return _messageLabelHeight+16;
    }
    else
    {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
    {
        //
        LZZMessageCell*cell=[[[NSBundle mainBundle] loadNibNamed:@"LZZMessageCell" owner:self options:nil]  lastObject];
        cell.currentLanguage=_currentLanguage;
        cell.message=_message;
        cell.messageLabel.font=_currentLanguage==EBOXEnglish?Font_En:Font_Ch;
        NSLog(@"_messageLabelHeight=%.2f",_messageLabelHeight);
        [cell.messageLabel startTypewrite];
        return cell;
    }
    else
    {
        //
        LZZCopyRightInfoCell*cell=[[[NSBundle mainBundle] loadNibNamed:@"LZZCopyRightInfoCell" owner:self options:nil]  lastObject];
        cell.crLabel.text=_currentLanguage==EBOXEnglish?@"Copyright(c) LuZizheng 2015.All right Reseved.":@"Copyright(c) 陆子铮 2015. 版权所有.";
        return cell;
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
