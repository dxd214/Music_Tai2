//
//  DownCell.m
//  YinYueTai
//
//  Created by 张佳仁 on 13-11-2.
//  Copyright (c) 2013年 KSY. All rights reserved.
//

#import "DownCell.h"
#import "UIImageView+WebCache.h"
#import "DownMV.h"

@implementation DownCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MVmodel *)model{
    if (_model != model) {
        [_model release];
        _model = [model retain];
        
       
        _mvImage.layer.cornerRadius = 5;
        _mvImage.layer.borderColor = [UIColor blackColor].CGColor;
        _mvImage.layer.borderWidth = 0.5;
        _mvImage.layer.masksToBounds = YES;

        [_mvImage  setImageWithURL:[NSURL URLWithString:_model.thumbnailPic]];
        int length =  _model.title.length;
        _mvName.width = length * 14;
        _mvName.text = _model.title;
        _descript.left = _mvName.right + 5;
        
        _descript.text = _model.description;
        _progressLable.textColor = CommentColor;
        
        _descript.textColor = [UIColor lightGrayColor];
        _descript.font = [UIFont systemFontOfSize:15];
        _mvName.textColor = [UIColor lightGrayColor];
        _progressLable.textColor = [UIColor lightGrayColor];
        
        _continueDownload.hidden = YES;
        
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MV"];
        NSString *temp = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tempPath"];
        
        NSString *downloadPath = [NSString stringWithFormat:@"%@/%@.mp4",path,_model.title];
        NSString *tempPath = [NSString stringWithFormat:@"%@/%@.mp4",temp,_model.title];
        
        NSData *data = [NSData dataWithContentsOfFile:downloadPath];
        NSData *datatempPath = [NSData dataWithContentsOfFile:tempPath];
        
        if (data.length == [_model.videoSize integerValue]) {
            _progressLable.hidden = YES;
            _progressLable.text =@"下载完成";
            mark = 1;
            [_runOrStop setImage:[UIImage imageNamed:@"addVideo"] forState:UIControlStateNormal];
        }else{
            _progressLable.hidden = NO;
            

            NSArray *array = [DownMV shareInstance].idArray;
            if (array.count > 0) {
                for (int i = 0 ; i < array.count; i++) {
                    if ([_model.MVID isEqualToNumber: array[i]]) {
                        
                        [_runOrStop setImage:[UIImage imageNamed:@"downStop"] forState:UIControlStateNormal];
                        mark = 2;
                        
                        [self progressText];
                        
                    }
                    
            }
                
            }else{
                [self progressText];
                 mark = 0;
                _stopDownloadLabel.text = @"暂停下载";
                _continueDownload.hidden = NO;
                 [_runOrStop setImage:[UIImage imageNamed:@"downRun"] forState:UIControlStateNormal];
            }

            
            
            
        }
      
        
        
        
    }
}

//- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data{
//    long long a = data.length;
//    
//}


-(void)progressText{
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MV"];
    NSString *temp = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/tempPath"];
    NSString *downloadPath = [NSString stringWithFormat:@"%@/%@.mp4",path,_model.title];
    NSString *tempPath = [NSString stringWithFormat:@"%@/%@.mp4",temp,_model.title];
    NSData *data = [NSData dataWithContentsOfFile:downloadPath];
    NSData *datatempPath = [NSData dataWithContentsOfFile:tempPath];
    if (datatempPath.length == [_model.uhdVideoSize integerValue]) {
        
        [_runOrStop setImage:[UIImage imageNamed:@"addVideo"] forState:UIControlStateNormal];
        mark = 1;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressText) object:nil];
        
    }
    
    float current = (float)datatempPath.length;
    
    NSString *progress =[NSString stringWithFormat:@"%.1f%%",current/[_model.videoSize integerValue] *100];
    _progressLable.text = progress;
    
    if (mark == 2) {
     [self performSelector:@selector(progressText) withObject:nil afterDelay:1];
    }

}

- (void)dealloc {
    [_model release];
   
    [_mvImage release];
    [_runOrStop release];
    [_mvName release];
    [_descript release];
    [_progressLable release];
    [_stopDownloadLabel release];
    [_continueDownload release];
    [super dealloc];
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    int tag = sender.tag;
    
    switch (tag) {
        case 401:
        {
            
        }
            break;
        case 402:
        {
            
        }
            break;
            

        case 403:
        {
            
            if (mark == 1) {
                
            }else if (mark == 2){
                mark = 0;
                
                [sender setImage:[UIImage imageNamed:@"downRun"] forState:UIControlStateNormal];
                
                _stopDownloadLabel.hidden = YES;
                _continueDownload.hidden = NO;
                 
            }else{
                mark = 2;
             
                [[DownMV shareInstance] downMvWithUrl:_model.url mvName:_model.title tag:[_model.MVID integerValue]];
                 
                [self progressText];

                [sender setImage:[UIImage imageNamed:@"downStop"] forState:UIControlStateNormal];
                _stopDownloadLabel.hidden = NO;
                _continueDownload.hidden = YES;
               
            }
            
            
            
        }
            break;
            

            
        default:
            break;
    }
}
@end
