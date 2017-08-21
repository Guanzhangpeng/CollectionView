//
//  HMViewCelll.m
//  无限滚动
//
//  Created by 管章鹏 on 16/1/19.
//  Copyright © 2016年 gzp. All rights reserved.
//

#import "HMViewCelll.h"
#import "HMNews.h"
@interface HMViewCelll()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end

@implementation HMViewCelll

- (void)awakeFromNib {
    // Initialization code
}

-(void)setNews:(HMNews *)news
{
    _news=news;
    
    self.title.text=[NSString stringWithFormat:@"  %@",news.title];
    
    
    self.iconImg.image=[UIImage imageNamed:news.icon];
    
}

@end
