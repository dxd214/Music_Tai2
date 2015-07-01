//
//  BaseTableView.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-25.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "BaseTableView.h"
#import "KSCell.h"
#import "MVDetailViewController.h"
#import "UIView+Additions.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    [super initWithFrame:frame style:style];
    if (self) {
        [self initViews];
    }
    return self;
}

-(void)awakeFromNib{
    [self initViews];
}

- (void)initViews{
    self.delegate = self;
    self.dataSource = self;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showArray.count;
}

- (KSCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    @"addVideo.png"
    static NSString *indentifier = @"cell";
    KSCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KSCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:cell.frame];
        backImage.image = [UIImage imageNamed:@"customBackground1"];
        cell.selectedBackgroundView = backImage;

    }
    cell.model = _showArray[indexPath.row];
    
    return cell;

    
}
- (void)dealloc{
    [_showArray release];
    [super dealloc];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVDetailViewController *MVDetailVC = [[MVDetailViewController alloc] init];
    MVmodel *mvModel = self.showArray[indexPath.row];
     MVDetailVC.mvId = mvModel.MVID;
    MVDetailVC.model = mvModel;
    [self.viewController.navigationController pushViewController:MVDetailVC animated:NO];
    
   
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.viewController.navigationController.view cache:NO];
    [UIView commitAnimations];
    [MVDetailVC release];
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