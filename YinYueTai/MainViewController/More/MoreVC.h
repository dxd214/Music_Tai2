//
//  MoreVC.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"

@interface MoreVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *titleArr;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *imgArr;


@end
