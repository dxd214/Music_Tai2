


//
//  DownVC.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-2.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"

@interface DownVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *downTableView;


@property (nonatomic, retain)NSMutableArray *array;
@property (nonatomic, retain)NSArray *modelArray;
@end
