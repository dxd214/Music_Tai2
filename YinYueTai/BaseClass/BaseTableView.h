//
//  BaseTableView.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-25.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,retain)NSArray *showArray;

@end
