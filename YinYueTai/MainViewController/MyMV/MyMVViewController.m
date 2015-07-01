//
//  MyMVViewController.m
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "MyMVViewController.h"
#import "MyMVCell.h"
#import "WatchRecordVC.h"
#import "DownVC.h"

@interface MyMVViewController ()

@end

@implementation MyMVViewController

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
    [_tableView release];
    [_imgArr release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _data = [[NSArray alloc] initWithObjects: @"我的订阅",
                                              @"下载的MV",
                                              @"自建的悦单",
                                              @"收藏的MV",
                                              @"收藏的悦单",
                                              @"播放记录",nil];
    
    _imgArr = [[NSArray alloc] initWithObjects: @"MyMusic_WX_UserOrder.png",
                                                @"MyMusic_WX_Cache.png",
                                                @"MyMusic_WX_MyList.png",
                                                @"MyMusic_WX_Fav.png",
                                                @"MyMusic_WX_FavList.png",
                                            @"MyMusic_WX_PlayHistory.png", nil];
    
    [self initViews];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_MyMusic.png"];
    [self titleImageSet:navImg];
    
}


- (void)initViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, 264) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor colorWithWhite:0.138 alpha:1.000];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
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
    static NSString *identifier = @"kMyMVCell";
    MyMVCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMVCell" owner:self options:nil] lastObject];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = _data[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            DownVC *downvc = [[DownVC alloc] init];
            [self.navigationController pushViewController:downvc animated:YES];
            [downvc release];
            
        }
            break;
            
            
        case 2:
        {
            
        }
            break;
            
            
        case 3:
        {
            
        }
            break;
            
        case 4:
        {
            
        }
            break;
            
            
        case 5:
        {
            
            //            NSArray *idArray =
            
            WatchRecordVC *watch = [[WatchRecordVC alloc] init];
            [self.navigationController pushViewController:watch animated:YES];
            [watch release];
            
        }
            break;
            
            
            
        default:
            break;
    }
    

    
}


@end
