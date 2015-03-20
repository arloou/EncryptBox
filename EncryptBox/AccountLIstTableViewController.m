//
//  AccountLIstTableViewController.m
//  EncryptBox
//
//  Created by ucs on 15/3/4.
//  Copyright (c) 2015年 lzz. All rights reserved.
//

#import "AccountLIstTableViewController.h"
#import "AccountListTableViewCell.h"
#import "AccountDetailTableViewController.h"
#import "LZZAccount.h"
#import "LZZFetchManager.h"
#import "LZZPopoverView.h"
#import "LzzPopoverViewCell.h"
#import "LZZAboutTableViewController.h"
#import "LZZSettingViewController.h"

@interface AccountLIstTableViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addAccountBtn;
@property(nonatomic,strong)NSMutableArray*accountArr;
@property(nonatomic,strong)NSMutableArray*accountDisplay;
@property(nonatomic,strong)NSMutableArray*orignIndexInDisplayArr;
@property(nonatomic,strong)LZZPopoverView*popoverView;
@property(nonatomic,strong)UITableView*popTableView;
@property(nonatomic,strong)NSArray*popTitles_En;
@property(nonatomic,strong)NSArray*popTitles_Ch;
@property(nonatomic,strong)NSArray*popImages;
@property(nonatomic,assign)__block BOOL isPopViewShowing;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UISearchDisplayController*searchDC;
@property(nonatomic,strong)UISearchBar*searchBar;
@property(nonatomic,strong)UIView * blackView;
@property(nonatomic,assign)EBOXLanguage currentLanguage;

@end

@implementation AccountLIstTableViewController
{
    UIApplication*app;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.title=[LZZSetting getCurrentLanguage]==EBOXEnglish?@"Accounts":@"账户";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.backBarButtonItem = backItem;
    backItem.title = @"";
    UINavigationBar *navBar = self.navigationController.navigationBar;
    
#define kSCNavBarImageTag 10
    [navBar setBarStyle:UIBarStyleBlackOpaque];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        //if iOS 5.0 and later
        [navBar setBackgroundImage:[UIImage imageNamed:@"navBG.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];
        if (imageView == nil)
        {
            imageView = [[UIImageView alloc] initWithImage:
                         [UIImage imageNamed:@"navBG.png"]];
            [imageView setTag:kSCNavBarImageTag];
            [navBar insertSubview:imageView atIndex:0];
        }  
    }
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleSDGothicNeo-UltraLight" size:18],NSFontAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setTintColor:[UIColor greenColor]];
    
    
    _accountDisplay= [NSMutableArray array];
    _orignIndexInDisplayArr=[NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountListTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.view.backgroundColor=[UIColor blackColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.tag=1;
    _blackView=[[UIView alloc] initWithFrame:self.view.frame];
    _blackView.backgroundColor=MainBGColor;
    
    // 搜索栏
    _searchBar=[[UISearchBar alloc] init];
    _searchBar.tintColor=[UIColor grayColor];
    _searchBar.delegate=self;
    _searchBar.placeholder=@"";
    _searchBar.backgroundImage=[UIImage imageNamed:@"navBG"];
    [_searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"navBG"] forState:UIControlStateNormal];
    _searchBar.layer.borderColor=[UIColor greenColor].CGColor;
    _searchBar.layer.borderWidth=0.5;
    _searchBar.layer.cornerRadius=6;
    _searchBar.tintColor=[UIColor greenColor];
    _searchBar.barTintColor=[UIColor blackColor];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor greenColor] forKeyPath:@"_placeholderLabel.textColor"];
    _searchDC=[[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDC.delegate=self;
//    _searchDC.displaysSearchBarInNavigationBar=YES;
    [_searchDC setSearchResultsDelegate:self];
    [_searchDC setSearchResultsDataSource:self];
    _searchDC.searchResultsTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView=_searchBar;
    self.tableView.tableHeaderView.backgroundColor=[UIColor blackColor];
    
    // 创建
    [self initPopoverView];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 页面显示前获取最新的语言设置
    _currentLanguage = [LZZSetting getCurrentLanguage];
    
    if (_needReloadData)
    {
        NSLog(@"需要刷新数据");
        [self loadData];
        if (_searchDC.isActive) {
            [_searchDC setActive:NO animated:NO];
            [_accountDisplay removeAllObjects];
            [_orignIndexInDisplayArr removeAllObjects];
        }
        _needReloadData=NO;
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (_needChangeLanguage) {
        
        [_popTableView reloadData];
        switch ([LZZSetting getCurrentLanguage]) {
            case EBOXChinese:
            {
                self.title=@"账户";
                _searchBar.placeholder=@"搜索";
            }
                break;
            case EBOXEnglish:
            {
                self.title=@"Accounts";
                _searchBar.placeholder=@"Search";
            }
                break;
                
            default:
                break;
        }
        
        _needChangeLanguage=NO;
    }
    

    
}

-(void)initPopoverView
{
    _popoverView=[LZZPopoverView popover];
    _popoverView.arrowSize=CGSizeMake(12.0, 12.0);
    _popoverView.cornerRadius=2;
    _popoverView.maskType=LZZPopoverMaskTypeBlack;
    _popoverView.applyShadow=YES;
    _popoverView.layer.shadowColor=[UIColor greenColor].CGColor;
    _popoverView.layer.shadowRadius=4;
    _popoverView.layer.shadowOpacity=0.8;
    _popoverView.layer.shadowOffset=CGSizeMake(0, 0);
    [_popoverView setNeedsDisplay];
    
    
    _popTitles_En=@[@"Add Account",@"Setting",@"About",@"Exit"];
    _popTitles_Ch=@[@"添加账户",@"设置",@"关于",@"退出"];
    _popImages=@[@"add.png",@"setting.png",@"about.png",@"exit.png"];
    _popTableView=[[[NSBundle mainBundle] loadNibNamed:@"LZZPopoverTableView" owner:self options:nil] lastObject];
    _popTableView.tag=2;
    _popTableView.dataSource=self;
    _popTableView.delegate=self;
    [_popTableView registerNib:[UINib nibWithNibName:@"LzzPopoverViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
}

- (IBAction)addBtnClick:(id)sender {
    
    CGPoint point=CGPointMake(MainWidth-24, 0);
    [_popoverView showAtPoint:point  popoverPostion:LZZPopoverPositionDown withContentView:_popTableView inView:self.view];
}
- (IBAction)organizeBtnClick:(id)sender {
    if (!_tableView.editing) {
        [_tableView setEditing:YES animated:YES] ;
    }else{
        [_tableView setEditing:NO animated:YES];
    }
    
}


-(void)loadData
{
    _accountArr=[NSMutableArray arrayWithArray:[LZZFetchManager getAllAccountList]];
    if (_accountArr.count==0)
    {
        self.tableView.tableHeaderView.hidden=YES;
        UIView * bgView=[[[NSBundle mainBundle] loadNibNamed:@"EmptyView" owner:self options:nil] lastObject];
        [bgView setBackgroundColor:[UIColor blackColor]];
        for (id obj in bgView.subviews)
        {
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel*label=obj;
                label.font=[UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:36];
            }
        }
        self.tableView.backgroundView=bgView;
    }
    else
    {
        self.tableView.tableHeaderView.hidden=NO;
        self.tableView.backgroundView=_blackView;
    }
    [self.tableView setNeedsDisplay];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView.tag==2)
    {
        return _popTitles_En.count;
    }
    else if(tableView==_searchDC.searchResultsTableView)
    {
        return _accountDisplay.count;
    }
    else
    {
        return _accountArr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag==2)
    {
        LzzPopoverViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"LzzPopoverViewCell" owner:self options:nil] lastObject];
        }
        NSString * title=_currentLanguage==EBOXEnglish?_popTitles_En[indexPath.row]:_popTitles_Ch[indexPath.row];
        NSMutableAttributedString*attStr=[[NSMutableAttributedString alloc ] initWithString:title];
        [attStr addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleSDGothicNeo-Thin" size:16],NSFontAttributeName, nil] range:NSMakeRange(0, attStr.length)];
        cell.titleLabel.attributedText=attStr;
        cell.logoImageView.image=[UIImage imageNamed:_popImages[indexPath.row]];
        return cell;
    }
    else
    {
        AccountListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"AccountListTableViewCell" owner:self options:nil] lastObject];
        }
        LZZAccount*acc=tableView==_searchDC.searchResultsTableView?[_accountDisplay objectAtIndex:indexPath.row]:[_accountArr objectAtIndex:indexPath.row];
        cell.titleLabel.text=acc.companyName;
        cell.subTitleLabel.text=acc.productName;
        cell.userNameLabel.text=[acc.userName formatToSecuDisplayUserName];
        cell.isFromResult=tableView==_searchDC.searchResultsTableView?YES:NO;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==2)
    {
        return 50;
    }
    else
    {
        return 100;
    }
    
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==2)
    {
        //LzzPopoverViewCell*cell=(LzzPopoverViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        AccountListTableViewCell*cell=(AccountListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell setBGHL:YES];
        cell.imgView.image=[UIImage imageNamed:@"unlock"];
    }
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==2)
    {
        //LzzPopoverViewCell*cell=(LzzPopoverViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    }
    else
    {
        AccountListTableViewCell*cell=(AccountListTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell setBGHL:NO];
        cell.imgView.image=[UIImage imageNamed:@"lock"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"1");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag==2)
    {
        NSLog(@"2");
        switch (indexPath.row)
        {
            case 0:
            {
                NSLog(@"3");
                //add
                AccountDetailTableViewController*vc=[self.storyboard instantiateViewControllerWithIdentifier:@"accountDetail"];
                vc.isAddAccount=YES;
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 1:
            {
                //setting
                LZZSettingViewController * vc=[self.storyboard instantiateViewControllerWithIdentifier:@"settingView"];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:
            {
                //about
                LZZAboutTableViewController*vc=[self.storyboard instantiateViewControllerWithIdentifier:@"aboutView"];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
            case 3:
            {
                //exit
                NSLog(@"4");
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }
                break;
                
            default:
                break;
        }
    }
    else
    {

        AccountDetailTableViewController*vc=[self.storyboard instantiateViewControllerWithIdentifier:@"accountDetail"];
        vc.isAddAccount=NO;
        if (tableView==_searchDC.searchResultsTableView)
        {
            vc.accountIndex=[[_orignIndexInDisplayArr objectAtIndex:indexPath.row] intValue];
            vc.thisAccount=_accountDisplay[indexPath.row];
        }
        else
        {
            vc.accountIndex=(int)indexPath.row;
            vc.thisAccount=_accountArr[indexPath.row];
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
   [_popoverView dismiss];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [LZZFetchManager moveAccount:sourceIndexPath.row toAccount:destinationIndexPath.row];
    [self loadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [ProgressHUD showError:@"Delete isn't permitted"];
}


#pragma mark - SearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;
{
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [_accountDisplay removeAllObjects];
    [_orignIndexInDisplayArr removeAllObjects];
    for (int i=0; i<_accountArr.count; i++) {
        LZZAccount * acc=_accountArr[i];
        if ([acc checkIfHasText:searchString])
        {
            [_accountDisplay addObject:acc];
            [_orignIndexInDisplayArr addObject:[NSNumber numberWithInt:i]];
        }
    }
    return YES;
}



@end
