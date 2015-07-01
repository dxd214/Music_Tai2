//
//  PlaylistTableView.h
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-31.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^playNew)(int a);

@interface PlaylistTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain)NSArray *modeArray;
@property(nonatomic, assign)playNew *playNew;
@end
