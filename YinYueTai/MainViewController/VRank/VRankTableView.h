//
//  VRankTableView.h
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseTableView.h"

@interface VRankTableView : BaseTableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *showArr;
@property (nonatomic, retain) NSArray *flagArr;

@end
