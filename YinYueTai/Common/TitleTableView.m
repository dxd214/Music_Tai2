//
//  TitleTableView.m
//  YinYueTai
//
//  Created by Dick on 13-10-25.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "TitleTableView.h"
#define kSingleDistance kScreenWidth / 4
#define kHalfDistance kScreenWidth / 8
#define kStartDistance (self.dataList.count - 4) / 2 * kScreenWidth / 4 + kHalfDistance

@implementation TitleTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        // 逆时针旋转90度
        self.transform = CGAffineTransformMakeRotation(- M_PI_2);
        
        // 重新设置frame
        self.frame = frame;
        
        // 设置背景颜色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置代理
        self.delegate = self;
        self.dataSource = self;
        
        // 隐藏滚动条
        self.showsVerticalScrollIndicator = NO;
        
        // 设置减速滑动停止方式为快速停止
        //        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        // 设置分割线样式
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 取消反弹效果
        self.bounces = NO;
        
        
        // 原始数据
        _sourceData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setDataList:(NSMutableArray *)dataList
{
    if (_dataList != dataList)
    {
        [_dataList release];
        _dataList = [dataList retain];
        
        if (_dataList.count <= 5)
        {
            [_dataList addObjectsFromArray:dataList];
        }
        
        // 设置起始位置
        self.contentOffset = CGPointMake(0, kStartDistance);
        
        _edge = kSingleDistance / 2;
        // 填充位置
        self.contentInset = UIEdgeInsetsMake(-_edge, 0, -_edge, 0);
//        NSLog(@"kSingleDistance:%f", kSingleDistance);
//        NSLog(@"kStartDistance:%f", kStartDistance);
//        NSLog(@"kHalfDistance:%f", kHalfDistance);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        [tap release];
    }
}

- (void)dealloc
{
    [_dataList release];
    [_sourceData release];
    
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    [self lightLabel];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
//    NSLog(@"y-------%f", point.y);
//    NSLog(@"%f%f", kScreenWidth / 8, kStartDistance - kSingleDistance);
    if (point.y < (kStartDistance + kSingleDistance +kHalfDistance))
    {
        [self setContentOffset:CGPointMake(0, kStartDistance - kSingleDistance)  animated:YES];
    }else if (point.y > (kStartDistance + 2*kSingleDistance +kHalfDistance))
    {
        [self setContentOffset:CGPointMake(0, kStartDistance + kSingleDistance)  animated:YES];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"kTitleTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == 3)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:0.472 green:0.737 blue:0.204 alpha:1.000];
    }else
    {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = self.dataList[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kSingleDistance;
}


#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self infiniteScroll:scrollView];
    [self reloadData];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //    [self scrollToCenter:scrollView];
    [self infiniteScroll:scrollView];
    //    [self reloadData];
    self.scrollEnabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self reloadData];
    [self hightLightAndLoadIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.scrollEnabled = NO;
    //    NSLog(@"scrollView.contentOffset.y : %f", scrollView.contentOffset.y);
    //    if (!decelerate)
    //    {
    if (scrollView.contentOffset.y > (kStartDistance - kHalfDistance) && scrollView.contentOffset.y < kStartDistance)
    {
        [scrollView setContentOffset:CGPointMake(0, kStartDistance) animated:YES];
    }else if (scrollView.contentOffset.y > kStartDistance && scrollView.contentOffset.y < (kStartDistance + kHalfDistance))
    {
        [scrollView setContentOffset:CGPointMake(0, kStartDistance) animated:YES];
    }else
    {
        [scrollView setContentOffset:CGPointMake(0, kStartDistance + kSingleDistance) animated:YES];
    }
    
}

//- (void)scrollToCenter: (UIScrollView *)scrollView
//{
////    int row = (scrollView.contentOffset.y + _edge) / self.rowHeight;
////    NSLog(@"row:%d", row);
////    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
////    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
////    self.selectedIndexPath = indexPath;
//
//}

- (void)hightLightAndLoadIndex
{
    [self lightLabel];
    //    NSMutableArray *codeArr = [NSMutableArray arrayWithCapacity:self.sourceData.count];
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:self.sourceData.count];
    for (NSDictionary *dic in self.sourceData)
    {
        //        NSString *codeString = [dic objectForKey:@"code"];
        //        [codeArr addObject:codeString];
        NSString *nameString = [dic objectForKey:@"name"];
        [nameArr addObject:nameString];
    }
    NSArray *visibleCellArr = [self visibleCells];
    UITableViewCell *cell = visibleCellArr[2];
    NSString *cellText = cell.textLabel.text;
    NSString *hightLightStr = [NSString string];
    // 比对 拿到名字对应的code
    for (NSString *str in nameArr)
    {
        if ([str isEqualToString:cellText])
        {
            hightLightStr = str;
        }
    }
    
    _currentIndex = [nameArr indexOfObject:hightLightStr];
    if (_currentIndex != _lastSelectedIndex)
    {
        if (_dataList.count > 7)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kVRankSelectIndexChangeNotification object:nil];
        }else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kMVSelectIndexChangeNotification object:nil];
        }
        
    }
    _lastSelectedIndex = _currentIndex;
}

- (void)lightLabel
{
    NSArray *visibleCellArr = [self visibleCells];
    for (UITableViewCell *cell in visibleCellArr)
    {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    UITableViewCell *cell = visibleCellArr[2];
    cell.textLabel.textColor = [UIColor colorWithRed:0.472 green:0.737 blue:0.204 alpha:1.000];
    
}

// 无限循环滑动
- (void)infiniteScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= (kStartDistance - kSingleDistance))
    {
        [scrollView setContentOffset:CGPointMake(0, kStartDistance) animated:NO];
        
        NSString *lastStr = [self.dataList lastObject];
        //        NSLog(@"lastStrInside:%@", lastStr);
        [self.dataList removeLastObject];
        [self.dataList insertObject:lastStr atIndex:0];
//        NSLog(@"datacount%d", self.dataList.count);
    }
    
    if (scrollView.contentOffset.y >= (kStartDistance + kSingleDistance))
    {
        [scrollView setContentOffset:CGPointMake(0, kStartDistance) animated:NO];
        
        NSString *firstStr = self.dataList[0];
        
        // 这里也是必须先删除再增加，否则会移除两个对象
        [self.dataList removeObjectAtIndex:0];
        [self.dataList addObject:firstStr];
        NSLog(@"datacount%d", self.dataList.count);
    }
}

@end
