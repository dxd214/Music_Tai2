//
//  SearchDetailViewController.h
//  YinYueTai
//
//  Created by Dick on 13-10-30.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseViewController.h"
#import "MVTableView.h"
#import "CollectionTableView.h"
#import <CoreData/CoreData.h>

@interface SearchDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) NSString *keyWord;
@property (nonatomic, retain) MVTableView *mvTbView;
@property (nonatomic, retain) NSArray *mvData;

@property(nonatomic,retain)CollectionTableView * vlistTavleView;
@property(nonatomic,retain)NSMutableArray *vlistArray;

@property (retain, nonatomic) IBOutlet UIView *headerView;
@property (retain, nonatomic) IBOutlet UITextField *textField;
@property (retain, nonatomic) IBOutlet UIButton *showMVButton;
@property (retain, nonatomic) IBOutlet UIButton *showPlayListButton;
@property (retain, nonatomic) IBOutlet UIButton *showArtistButton;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *defaultSearchArr;
@property (nonatomic, retain) NSMutableArray *defaultMVSearchArr;

- (IBAction)cancelSearchAction:(id)sender;
- (IBAction)showListAction:(UIButton *)sender;

// 用来判断当前选择
@property (nonatomic, assign)BOOL isMVList;
@property (nonatomic, assign)BOOL isPlayList;
@property (nonatomic, assign)BOOL isArtistList;

//数据模型对象
@property(strong,nonatomic) NSManagedObjectModel *managedObjectModel;
//上下文对象
@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//持久性存储区
@property(strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//初始化Core Data使用的数据库
-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

//managedObjectModel的初始化赋值函数
-(NSManagedObjectModel *)managedObjectModel;

//managedObjectContext的初始化赋值函数
-(NSManagedObjectContext *)managedObjectContext;

@end
