//
//  MyMVViewController.h
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"

@interface MyMVViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSArray *imgArr;
@end
