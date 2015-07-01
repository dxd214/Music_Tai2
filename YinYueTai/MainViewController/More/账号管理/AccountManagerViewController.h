//
//  AccountManagerViewController.h
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"

@interface AccountManagerViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) UILabel *label;

@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
