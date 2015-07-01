//
//  VRCell.h
//  YinYueTai
//
//  Created by Dick on 13-11-1.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVmodel.h"
#import "CellView.h"

@interface VRCell : UITableViewCell

@property (retain, nonatomic) IBOutlet CellView *bottomView;
@property (retain, nonatomic) MVmodel *model;
@property (retain, nonatomic) IBOutlet UIButton *imageButton;
@property (retain, nonatomic) IBOutlet UILabel *MVname;
@property (retain, nonatomic) IBOutlet UILabel *authorName;
@property (retain, nonatomic) IBOutlet UIImageView *flagImgView;
@property (retain, nonatomic) IBOutlet UILabel *rankNum;
- (IBAction)buttonAction:(UIButton *)sender;

@end
