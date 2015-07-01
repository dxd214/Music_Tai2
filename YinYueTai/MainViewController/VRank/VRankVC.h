//
//  VRankVC.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-23.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"
#import "VRankModel.h"
#import "TitleTableView.h"
#import "VRankTableView.h"
#import "PeriodsModel.h"

@interface VRankVC : BaseViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIView  *_publishDateView;   //  打榜日期视图
    UIButton *_publishDateButton;  //  打榜日期
    
    int _lastSelectedRow;
    int _lastSelectedComponent;
}
@property(nonatomic,retain)VRankTableView *mvTableView;
@property(nonatomic, retain)NSArray *ereasArray;//地区名字
@property(nonatomic, retain)NSArray *MVArray;   //mv的数组
@property (nonatomic, retain)TitleTableView *titleTableView; // 滚动标题
@property (nonatomic, retain)NSString *mvRequestParam; // mv视图的请求参数
@property (nonatomic, retain)NSMutableArray *dataArr; // 滚动日期数据源
@property (nonatomic, retain)NSArray *yeahArr; // 滚动日期年份
@property (nonatomic, retain)UIView *shadowView; // 遮罩视图
@property(nonatomic, retain)VRankModel *rankModel;
@property (nonatomic, retain)PeriodsModel *periodsModel;


@end
