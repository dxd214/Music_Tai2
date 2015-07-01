//
//  MoreCell.h
//  YinYueTai
//
//  Created by Dick on 13-10-28.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIButton *backGroundButton;
@property (retain, nonatomic) IBOutlet UIImageView *userImgView;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (nonatomic, retain)NSIndexPath *indexPath;

- (IBAction)pushAtion:(id)sender;

@end
