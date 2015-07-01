//
//  MVDetailViewController.h
//  YinYueTai
//
//  Created by Dick on 13-10-27.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"
#import "MVshowModel.h"
#import "BaseTableView.h"
#import "MVmodel.h"
//#import "MVDetailTableView.h"


@interface MVDetailViewController : BaseViewController
{
    BOOL _isFold; // 展开、收起flag
    UIView *_tableHead;
}
@property(nonatomic, retain) BaseTableView *mvTableView;
@property (nonatomic, retain) NSNumber *mvId;
@property (nonatomic, retain) NSArray *relatedVideos;
@property (nonatomic, retain) MVshowModel *mvShowModel;
@property (nonatomic, retain)MVmodel *model;


// 标题View
@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UIImageView *bigImgView;
@property (retain, nonatomic) IBOutlet UILabel *mvNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *ActorNameLabel;

// 内容View
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;

@property (retain, nonatomic) IBOutlet UIView *foldCtrlView;
@property (retain, nonatomic) IBOutlet UIImageView *foldImgView;
@property (retain, nonatomic) IBOutlet UILabel *foldTextLabel;

// 表视图
//@property (nonatomic, retain) MVDetailTableView *tableView;

// 尾视图
@property (retain, nonatomic) IBOutlet UIView *footerView;
- (IBAction)footButtonClickAction:(UIButton *)sender;


// 播放MV
- (IBAction)playMVAction:(id)sender;
@end
