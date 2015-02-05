//
//  MainViewController.m
//  EncryptBox
//
//  Created by ucs on 15/1/29.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UISegmentedControl *mySC;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor=[UIColor clearColor];
    UIView*clearView=[[UIView alloc] initWithFrame:self.tableView.bounds];
    [clearView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView=clearView;
    // Do any additional setup after loading the view.
}

- (IBAction)selectSC:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0)
    {
        NSLog(@"第一个");
    }
    else
    {
        NSLog(@"第二个");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView.tag==11?10:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName=@"Cell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.text=@"hehe";
    cell.textLabel.textColor=[UIColor greenColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
