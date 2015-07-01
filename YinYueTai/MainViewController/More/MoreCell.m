//
//  MoreCell.m
//  YinYueTai
//
//  Created by Dick on 13-10-28.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "MoreCell.h"
#import "AccountManagerViewController.h"
#import "UIView+Additions.h"

@implementation MoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [_titleLabel setShadowColor:[UIColor blackColor]];
    [_titleLabel setShadowOffset:CGSizeMake(2, 1)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_backGroundButton release];
    [_userImgView release];
    [_titleLabel release];
    [_userNameLabel release];
  
    [super dealloc];
}

- (IBAction)pushAtion:(id)sender {
    switch (_indexPath.section) {
        case 0:{
            AccountManagerViewController *managerVC = [[AccountManagerViewController alloc] init];
            [self.viewController.navigationController pushViewController:managerVC animated:YES];
            [managerVC release];
        }
            
            break;
        case 1:{
            switch (_indexPath.row) {
                case 0:
                    
                    break;
                case 1:
                    
                    break;
                case 2:
                    
                    break;
                case 3:
                    
                    break;
                    
                default:
                    break;
            }
            
            
        }
            
            break;
        case 2:{
            
            switch (_indexPath.row) {
                case 0:{
                    
                }
                    
                    break;
                case 1:{
                    
                }
                    
                    break;

                case 2:{
                    
                }
                    
                    break;
                case 3:{
                    
                }
                    
                    break;
                case 4:{
                    
                }
                    
                    break;



                    
                default:
                    break;
            }
            
            
            
        }
            
            break;
            
        default:
            break;
    }
      
}
@end
