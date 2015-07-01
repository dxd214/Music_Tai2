//
//  WatchRecordVC.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-3.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "WatchRecordVC.h"
#import "MVmodel.h"
#import "RecordModel.h"


@interface WatchRecordVC ()

@end

@implementation WatchRecordVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_PlayHis.png"];
    [self titleImageSet:navImg];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _watchTable = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 - 44) style:UITableViewStylePlain];
    _watchTable.separatorColor = [UIColor clearColor];
    _watchTable.separatorStyle = UITableViewCellStyleDefault;
    _watchTable.backgroundColor = [UIColor clearColor];
  
    [self.view addSubview:_watchTable];
    
    
    
    NSArray *array = [RecordModel userDefalutsArraywithString:@"watchRecord"];
    self.array = [RecordModel arrayForPathString: array subPath:@"Model"];
    _watchTable.showArray = _array;
    [_watchTable reloadData];
    
    
}
- (void)dealloc
{
    [_watchTable release];
    [_array release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
