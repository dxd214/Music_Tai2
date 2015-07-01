//
//  PlaylistTableView.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-31.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "PlaylistTableView.h"
#import "PlayListCell.h"
#import "MVmodel.h"
#import "UIView+Additions.h"
#import "PlayVC.h"

@implementation PlaylistTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.transform = CGAffineTransformMakeRotation(- M_PI_2);
        self.frame = frame;
        self.separatorColor =[UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;


    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.transform = CGAffineTransformMakeRotation(- M_PI_2);
        self.frame = frame;
        self.separatorColor =[UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.delegate = self;
        self.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);

    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modeArray.count;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (PlayListCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifer = @"playListCell";
    PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifer];
    if (!cell) {
        cell = [[[PlayListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifer] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    cell.model = _modeArray[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PlayVC *playVC =(PlayVC *) self.viewController;
    MVmodel *model = _modeArray[indexPath.row];
    playVC.mvPlayerCtrl.contentURL = [NSURL URLWithString:model.url];
    [playVC.mvPlayerCtrl shouldAutoplay];
    [playVC.mvPlayerCtrl play];
    
    
    
}

- (void)dealloc
{
    [_modeArray release];
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

@end
