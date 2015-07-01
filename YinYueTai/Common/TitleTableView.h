//
//  TitleTableView.h
//  YinYueTai
//
//  Created by Dick on 13-10-25.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
{
    float _edge; // 填充宽度
}
//@property (nonatomic,retain)NSIndexPath *selectedIndexPath;
@property (nonatomic, retain)NSMutableArray *dataList;
@property (nonatomic, retain)NSArray *sourceData; // 原始数据
@property (nonatomic, assign)int currentIndex; // 当前选中位置
@property (nonatomic, assign)int lastSelectedIndex; // 原来选中位置

@end
