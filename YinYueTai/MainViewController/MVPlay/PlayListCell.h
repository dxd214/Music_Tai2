//
//  PlayListCell.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-31.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVmodel.h"

@interface PlayListCell : UITableViewCell{
    UIImageView *_mvImage;
    UILabel *_nameLable;
}

@property(nonatomic, retain)MVmodel *model;
@end
