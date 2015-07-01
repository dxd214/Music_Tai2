//
//  KSCell.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-25.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVmodel.h"
#import "CellView.h"


@interface KSCell : UITableViewCell
@property (retain, nonatomic)MVmodel *model;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIButton *imageButton;
@property (retain, nonatomic) IBOutlet UIButton *addButton;
@property (retain, nonatomic) IBOutlet UILabel *MVname;

@property (retain, nonatomic) IBOutlet UILabel *authorName;

- (IBAction)buttonAction:(id)sender;
@end
