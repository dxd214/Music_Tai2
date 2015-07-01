//
//  DownCell.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-2.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVmodel.h"
#import "DownMV.h"

@interface DownCell : UITableViewCell{
    int mark;
}

@property(nonatomic, retain)MVmodel *model;


@property(nonatomic, retain)DownMV *downMV;

- (IBAction)buttonAction:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *mvImage;
@property (retain, nonatomic) IBOutlet UIButton *runOrStop;
@property (retain, nonatomic) IBOutlet UILabel *mvName;
@property (retain, nonatomic) IBOutlet UILabel *descript;
@property (retain, nonatomic) IBOutlet UILabel *progressLable;
@property (retain, nonatomic) IBOutlet UILabel *stopDownloadLabel;
@property (retain, nonatomic) IBOutlet UILabel *continueDownload;
@end
