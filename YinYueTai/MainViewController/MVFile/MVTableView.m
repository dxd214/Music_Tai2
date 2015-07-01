//
//  MVTableView.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-26.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "MVTableView.h"


#define FLIP_ANIMATION_DURATION 0.18f


@implementation MVTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    [super initWithFrame:frame style:style];
    if (self) {
        [self initTabelView];
    }
    return self;
}

- (void)awakeFromNib{
    
}


- (void)initTabelView{
    _refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, self.frame.size.width , self.bounds.size.height)];
    _refreshView.delegate = self;
    _refreshView.backgroundColor = [UIColor clearColor];
//    _refreshView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"refreshLogo"]];
    [self addSubview: _refreshView];
    
    _footViewl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 51)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_footViewl.width - 110)/2, 0, 110, 51.0f)];
    //加了图片
    imageView.image = [UIImage imageNamed:@"refreshLogo.png"];
    [_footViewl addSubview:imageView];
    [imageView release];

  

    
    _footImage = [[UIImageView alloc] initWithFrame:CGRectMake(30.0f,10 , 30.0f, 30.0f)];
    _footImage.image = [UIImage imageNamed:@"refreshArrow.png"];
    [_footViewl addSubview:_footImage];
    
    
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.color = [UIColor colorWithRed:0.537 green:0.799 blue:0.275 alpha:1.000];
    _activityView.frame = CGRectMake(40.0f, 15, 20.0f, 20.0f);
    [_footViewl addSubview:_activityView];

    
//    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    view.frame = CGRectMake(25.0f, 10, 20.0f, 20.0f);
//    [self addSubview:view];
//    _activityView = view;
    
   
    _footLable = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, 15, 100, 20)];
    _footLable.text = @"上拉可加载更多";
    _footLable.backgroundColor = [UIColor clearColor];
    _footLable.textColor = [UIColor colorWithRed:0.537 green:0.799 blue:0.275 alpha:1.000];
    _footLable.font = [UIFont systemFontOfSize:12];
    [_footViewl addSubview:_footLable];

      
    
//    imageView.transform = CATransform3DMakeRotation((M_PI_2 / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
   
    self.tableFooterView = _footViewl;
    
    [_refreshView refreshLastUpdatedDate];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshView egoRefreshScrollViewDidScroll:scrollView];
    float sub = scrollView.contentSize.height - scrollView.contentOffset.y;
//    NSLog(@"%f",scrollView.height - sub - 50);
    float currentHeight = scrollView.height - sub ;
    
    if (currentHeight >= 50 && currentHeight <= 53) {

        if (mark1) {
            mark2 = 0;
        }else{
            mark1 = 1;
            [UIView animateWithDuration:.2 animations:^{
                CGAffineTransform transform = _footImage.transform;
                _footImage.transform = CGAffineTransformRotate(transform, M_PI);
                 _footLable.text = @"上拉可加载更多";
            
            }];

        }
              
            }
    else if(currentHeight >= 70  && currentHeight <= 73){

        if (mark2) {
            mark1 = 0;
        }else{
            mark2 = 1;
            [UIView animateWithDuration:.2 animations:^{
                CGAffineTransform transform = _footImage.transform;
                _footImage.transform = CGAffineTransformRotate(transform, M_PI);
                _footLable.text = @"松开加载更多";        }];

        }
                
    }
    
    
}

//触发下拉刷新
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    float sub = scrollView.contentSize.height - scrollView.contentOffset.y;
//	 NSLog(@"%f",scrollView.height - sub - 50);
    if (scrollView.height - sub > 50) {
        NSLog(@"%f",scrollView.height - sub - 50);
        if (_pullUpBlock) {
                   [_activityView startAnimating];
            _footImage.hidden = YES;
            _footLable.text = @"加载中...";
            self.height -= 50 ;
            //    [self addSubview:view];

            _pullUpBlock();
            [self performSelector:@selector(changFrame) withObject:nil afterDelay:1];
           
        }
    }

}

- (void)changFrame{
    self.height += 50 ;
    _footImage.hidden = NO;
    [_activityView stopAnimating];
}


#pragma mark - EGORefreshTableHeaderView 协议方法
//下拉触发的方法
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    _reloading = YES;
    if (_pullDownBlock) {
        
        _pullDownBlock();
        
    }

    
    //加载数据

}



- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}


//
//- (void)reloadTableViewDataSource{
//	_reloading = YES;
//	
//}
//
//- (void)doneLoadingTableViewData{
//	_reloading = NO;
//	[_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
//}
//
//
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//	
//	[_refreshView egoRefreshScrollViewDidScroll:scrollView];
//    
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//	
//	[_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
//    
//    
//    //上拉加载更多
//    //实现原理: scrollView.contentSize.height - scrollView.contentOffset.y = scrollView.height
//    float sub = scrollView.contentSize.height - scrollView.contentOffset.y;
//	
//    if (scrollView.height - sub > 50) {
//        [self loadMoreAction];
//    }
//}
//
//
////上拉加载更多
//-(void)loadMoreAction
//{
//    //如果没有更多,就返回
//    if (!self) {
//        return;
//    }
//    
//    if (_pullUpBlock) {
//        //刷新正在加载的状态
//        [self startLoadMore];
//        
//        //执行上拉的动作
//        _pullUpBlock(self);
//    }
//}
//
//-(void)startLoadMore
//{
////    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
////    _moreButton.enabled = NO;
////    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2000];
////    [activityView startAnimating];
//}
//
//
//
//#pragma mark -
//#pragma mark EGORefreshTableHeaderDelegate Methods
////已经触发了下拉刷新的动作
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//	
//	[self reloadTableViewDataSource];
//    
//    //请求网络
//    if (_pullDownBlock) {
//        _pullDownBlock(self);
//    }
//    
//   	
//}
//
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
//	
//	return _reloading; // should return if data source model is reloading
//	
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (void)dealloc
{
    
    [_footLable release];
    [_footViewl release];
    [_refreshView release];
    Block_release(_pullDownBlock);
    Block_release(_pullUpBlock);
    [super dealloc];
}

@end
