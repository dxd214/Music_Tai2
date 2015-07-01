//
//  InfiniteScrollerView.h
//  Demo
//
//  Created by Dick on 13-10-23.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

// 点击协议
@protocol InfiniteScrollerViewDelegate <NSObject>
@optional

- (void)infiniteScrollerViewDidClicked:(NSUInteger)index;
- (void)collectPicture:(NSUInteger)index;

@end


@interface InfiniteScrollerView : UIView<UIScrollViewDelegate>
{
	CGRect _viewSize; // 视图大小
	UIScrollView *_scrollView; 
	NSArray *_imageArray; // 图片数组(可以是URL可以是本地)
//    int _currentPageIndex; // 当前页码
}

@property(nonatomic, assign)NSInteger  currentPageIndex;
@property (nonatomic, assign) id<InfiniteScrollerViewDelegate> delegate;
- (id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr;

@end
