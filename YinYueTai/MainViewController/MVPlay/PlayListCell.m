//
//  PlayListCell.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-10-31.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "PlayListCell.h"
#import "UIImageView+WebCache.h"

@implementation PlayListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initView{

    _mvImage = [[UIImageView alloc] initWithFrame:CGRectMake(5 , 10, 101, 57 )];
    [self addSubview:_mvImage];
    
    _mvImage.layer.cornerRadius = 5;
    _mvImage.layer.borderColor = [UIColor blackColor].CGColor;
    _mvImage.layer.borderWidth = 0.5;
    _mvImage.layer.masksToBounds = YES;
     
    _nameLable = [[UILabel alloc] initWithFrame:CGRectMake(8, _mvImage.bottom , _mvImage.width - 6, 16)];
    [self addSubview:_nameLable];

    _nameLable.textColor = CommentColor;
    _nameLable.font = [UIFont systemFontOfSize:10];
    _nameLable.backgroundColor = [UIColor clearColor];
    
    
//    UIButton *button = [[UIButton alloc ] initWithFrame:self.frame];
//    [button addTarget:self action:@selector(playMV) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:button];
//    button.backgroundColor = [UIColor clearColor];
//
//    [button release];
    
        
    
    
   
}


- (void)playMV{
    
}

- (void)setModel:(MVmodel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
        _nameLable.text = _model.title;
        
        [_mvImage setImageWithURL:[NSURL URLWithString:_model.thumbnailPic]];
        
    }
}

- (void)dealloc
{
    [_mvImage release];
    [_nameLable release];
    [_model release];
    [super dealloc];
}

@end
