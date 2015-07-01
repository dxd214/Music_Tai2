//
//  VRankTableView.m
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "VRankTableView.h"
#import "BaseTableView.h"
#import "VRCell.h"
#import "MVDetailViewController.h"
#import "UIView+Additions.h"

@implementation VRankTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)setShowArr:(NSArray *)showArr
{
    if (_showArr != showArr) {
        [_showArr release];
        _showArr = [showArr retain];
        
            _flagArr = [[NSArray alloc] initWithObjects:@"VList_Top1.png", @"VList_Top2.png", @"VList_Top3.png", @"VList_TopN.png",nil];
    }
}

- (void)dealloc
{
    [_flagArr release];
    [_showArr release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _showArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    @"addVideo.png"
    static NSString *indentifier = @"kRankCell";
    VRCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VRCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:cell.frame];
        backImage.image = [UIImage imageNamed:@"customBackground1"];
        cell.selectedBackgroundView = backImage;
        
    }
    switch (indexPath.row)
    {
        case 0:
            cell.flagImgView.image = [UIImage imageNamed:_flagArr[0]];
            break;
        case 1:
            cell.flagImgView.image = [UIImage imageNamed:_flagArr[1]];
            break;
        case 2:
            cell.flagImgView.image = [UIImage imageNamed:_flagArr[2]];
            break;
        default:
            cell.flagImgView.image = [UIImage imageNamed:_flagArr[3]];
            break;
    }
    
    cell.rankNum.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    cell.model = _showArr[indexPath.row];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MVDetailViewController *MVDetailVC = [[MVDetailViewController alloc] init];
    MVmodel *mvModel = _showArr[indexPath.row];
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



@end
