//
//  DownVC.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-2.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "DownVC.h"
#import "DownCell.h"
#import "DataService.h"
#import "MVmodel.h"
#import "RecordModel.h"
#import "PlayVC.h"


@interface DownVC ()

@end

@implementation DownVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//+ (id)shareInstance{
//    static DownVC *instance = nil;
//
//    if (!self) {
//        instance = [[DownVC alloc] init];
//
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    [self initView];
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    UIImage *navImg = [UIImage imageNamed:@"Title_DownCatch.png"];
    [self titleImageSet:navImg];
    
}


- (void)loadData{
    self.array = [RecordModel userDefalutsArraywithString:@"DownRecord"];
    self.modelArray = [RecordModel arrayForPathString:_array subPath:@"DownRecord"];
    
}

- (void)initView{
    
    _downTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 20 - 44 ) style:UITableViewStylePlain];
    _downTableView.backgroundColor = [UIColor clearColor];
    _downTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _downTableView.separatorColor = [UIColor clearColor];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  65;
}

-  (DownCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"downCell";
    DownCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DownCell" owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    MVmodel *mode = _modelArray[indexPath.row];
    cell.model = mode;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *recodArray = [RecordModel userDefalutsArraywithString:@"DownRecord"];
    MVmodel *mode = _modelArray[indexPath.row];
    PlayVC *play = [[PlayVC alloc] init];
    play.locationArray = _modelArray;
    
    
     NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MV"];
     NSString *downloadPath = [NSString stringWithFormat:@"%@/%@.mp4",path,mode.title];
     NSURL *url = [NSURL fileURLWithPath:downloadPath];
    
     play.url = url;
    
     [self presentModalViewController:play animated:YES];
  
    [play release];
    
//     _modelArray
    
    //需要视频地址 
   // 下载的modl;

    
   
    

//    NSString *downloadPath = [NSString stringWithFormat:@"%@/%@.mp4",path,_model.title];
//    NSString *tempPath = [NSString stringWithFormat:@"%@/%@.mp4",temp,_model.title];
//    
//    NSData *data = [NSData dataWithContentsOfFile:downloadPath];
//    NSData *datatempPath = [NSData dataWithContentsOfFile:tempPath];
    
    
    

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)dealloc {
    [_downTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDownTableView:nil];
    [super viewDidUnload];
}
@end
