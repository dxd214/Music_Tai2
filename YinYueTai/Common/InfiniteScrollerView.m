//
//  InfiniteScrollerView.m
//  Demo
//
//  Created by Dick on 13-10-23.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "InfiniteScrollerView.h"
@implementation InfiniteScrollerView
- (id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)imgArr
{
    
	if ((self = [super initWithFrame:rect])) {
        self.userInteractionEnabled = YES;
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count] - 1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
		_imageArray = [[NSArray arrayWithArray:tempArray] retain];
		_viewSize = rect;
        NSUInteger pageCount = [_imageArray count];
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, _viewSize.size.width, _viewSize.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_viewSize.size.width * pageCount, _viewSize.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        for (int i = 0; i < pageCount; i++) {
            NSString *imgURL = [_imageArray objectAtIndex:i];
            UIImageView *imgView = [[[UIImageView alloc] init] autorelease];
            imgView.contentMode = UIViewContentModeScaleToFill;
            if ([imgURL hasPrefix:@"http://"]) {
                //网络图片 请使用ego异步图片库
                [imgView setImageWithURL:[NSURL URLWithString:imgURL]];
            }
            else
            {
                
                UIImage *img = [UIImage imageNamed:[_imageArray objectAtIndex:i]];
                imgView.image = img;
            }
            
            [imgView setFrame:CGRectMake(_viewSize.size.width * i, 0, _viewSize.size.width, _viewSize.size.height)];
            imgView.tag = i;
            UITapGestureRecognizer *Tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)] autorelease];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:Tap];
            [_scrollView addSubview:imgView];
            
            // 添加长按手势收藏海报图片
            UILongPressGestureRecognizer *Tap2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(collectAction:)];
            Tap2.minimumPressDuration = 1;
            [imgView addGestureRecognizer:Tap2];
        }
        [_scrollView setContentOffset:CGPointMake(_viewSize.size.width, 0)];
        [self addSubview:_scrollView];
	}
    
    [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(changePageNumByTimer:) userInfo:nil repeats:YES];
	return self;
}

- (void)changePageNumByTimer:(NSTimer *)timer
{
    if (_currentPageIndex >= _imageArray.count - 2)
    {
        _currentPageIndex = 0;
        [_scrollView setContentOffset:CGPointMake((_imageArray.count - 1) * _viewSize.size.width, 0) animated:YES];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }else
    {
        [_scrollView setContentOffset:CGPointMake((_currentPageIndex + 1) * _viewSize.size.width, 0) animated:YES];
    }
}

- (void)dealloc
{
	[_scrollView release];
	_delegate = nil;
    if (_imageArray) {
        [_imageArray release];
        _imageArray = nil;
    }
    [super dealloc];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentPageIndex = page;
    NSNumber *num = [NSNumber numberWithInt:_currentPageIndex - 1];

    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:@"index"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPageChangeNotification object:nil userInfo:dic];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_currentPageIndex == 0)
    {
        [scrollView setContentOffset:CGPointMake(([_imageArray count] - 2) * _viewSize.size.width, 0)];
    }
    if (_currentPageIndex == ([_imageArray count] - 1))
    {
        [UIView animateWithDuration:0.35 animations:^{
            [_scrollView setContentOffset:CGPointMake((_imageArray.count - 1) * _viewSize.size.width, 0)];
        } completion:^(BOOL finished) {
            [scrollView setContentOffset:CGPointMake(_viewSize.size.width, 0)];
        }];
 
    }
//    NSNumber *num = [NSNumber numberWithInt:_currentPageIndex - 1];
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:@"index"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kPageChangeNotification object:nil userInfo:dic];
    
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(infiniteScrollerViewDidClicked:)]) {
        [self.delegate infiniteScrollerViewDidClicked:sender.view.tag];
    }
}

- (void)collectAction:(UILongPressGestureRecognizer *)sender
{
    
    NSLog(@"%@", [sender.view class]);
    if ([self.delegate respondsToSelector:@selector(collectPicture:)]) {
        [self.delegate collectPicture:sender.view.tag];
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



@end
