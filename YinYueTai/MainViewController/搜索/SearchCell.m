//
//  SearchCell.m
//  YinYueTai
//
//  Created by Dick on 13-10-30.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "SearchCell.h"

@implementation SearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
        _text.textColor = [UIColor lightGrayColor];
        _text.font = [UIFont systemFontOfSize:15];
        _text.backgroundColor = [UIColor clearColor];
        [self addSubview:_text];
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SearchLabelShadow.png"]];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_text release];
    [super dealloc];
}

@end
