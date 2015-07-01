//
//  BsaeView.m
//  FirstMoive
//
//  Created by 张佳仁 on 13-8-31.
//  Copyright (c) 2013年 张佳仁. All rights reserved.
//

#import "BsaeView.h"
#import "MVmodel.h"
#import "UIImageView+WebCache.h"
#import "PlayVC.h"
#import "UIView+Additions.h"
#import "PlayListCell.h"



@implementation BsaeView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.transform = CGAffineTransformMakeRotation(- M_PI_2);
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.frame = frame;
        self.dataSource = self;
        self.delegate = self;
    
    }
    return self;
}

- (void)setRowHeight:(CGFloat)rowHeight{
    [super setRowHeight:rowHeight];
    _egde = (kScreenHeight - rowHeight)/2 ;
    self.contentInset = UIEdgeInsetsMake(_egde, 0, _egde, 0);
    
    
    
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  110;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//         self.viewController
  
    return _modeArray.count;
}

- (PlayListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentfier = @"cell";
    PlayListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentfier];
    if (cell == nil) {
        cell = [[[PlayListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentfier] autorelease ];
         cell.transform = CGAffineTransformMakeRotation( M_PI_2);
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    MVmodel *news = _modeArray[indexPath.row];

    
//     UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.height *.05 , 5, self.rowHeight - self.height * .1, self.height - 20 )];
//     UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5 , 5, 101, 57 )];
//    [imageview setImageWithURL:[NSURL URLWithString:news.thumbnailPic]];
//    cell.backgroundColor = [UIColor orangeColor];
//    [cell.contentView addSubview:imageview];
//    [imageview release];
//
    cell.model = news;


    
    return cell;
    
    
    
}





- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        
    PlayVC *playVC =(PlayVC *) self.viewController;
    MVmodel *model = _modeArray[indexPath.row];
    self.index1 = indexPath.row;
    if (_mark) {
        NSLog(@"%@",model.title);
      playVC.mvPlayerCtrl.contentURL =  [self loactionUrl:model.title];
    }else{
        
        playVC.mvPlayerCtrl.contentURL = [NSURL URLWithString:model.url];
        
        
 
    }
    playVC.progressTime.hidden = YES;
    playVC.allTime.hidden = YES;
    [playVC.mvPlayerCtrl shouldAutoplay];
    [playVC.mvPlayerCtrl play];
    
    
    
    
    

}


- (NSURL *)loactionUrl:(NSString *)title{
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MV"];
    NSString *downloadPath = [NSString stringWithFormat:@"%@/%@.mp4",path,title];
    NSURL *url = [NSURL fileURLWithPath:downloadPath];
    return url;
}



@end