//
//  AccountManagerViewController.m
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "AccountManagerViewController.h"
#import "AccountManagerCell.h"
@interface AccountManagerViewController ()

@end

@implementation AccountManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_data release];
    [_label release];
    [_headerView release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _data = [[NSArray alloc] initWithObjects:@"登录邮箱:", @"密保手机:", @"新浪微博:", nil];
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
//    _label.text
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = [UIColor lightGrayColor];
    _label.backgroundColor = [UIColor clearColor];
    _label.font = [UIFont systemFontOfSize:12];
    _label.text = @"欢迎您：  阿里巴巴";
    _tableView.tableHeaderView = _label;
    _tableView.scrollEnabled = NO;
    UIImageView *shadowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _tableView.bottom - 20, kScreenWidth, 5)];
    shadowImgView.image = [UIImage imageNamed:@"TitleViewShadow.png"];
    [self.view addSubview:shadowImgView];
    [shadowImgView release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"kAccountCell";
    AccountManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AccountManagerCell" owner:self options:nil] lastObject];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    if (indexPath.row > 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(170, 4, 71, 35);
        [button setImage:[UIImage imageNamed:@"Login_bind.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"Login_bind_Sel.png"] forState:UIControlStateHighlighted];
        [cell addSubview: button];
        cell.contentLabel.text = @"无";
    }
    cell.titleLabel.text = _data[indexPath.row];

    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)viewDidUnload {
    [self setHeaderView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
