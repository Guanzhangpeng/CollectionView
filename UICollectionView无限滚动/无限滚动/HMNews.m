//
//  HMNews.m
//  无限滚动
//
//  Created by 管章鹏 on 16/1/19.
//  Copyright © 2016年 gzp. All rights reserved.
//

#import "HMNews.h"

@implementation HMNews

-(instancetype)initWithDict:(NSDictionary *)dic
{
    if (self=[super init]) {
        
        self.title=dic[@"title"];
        self.icon=dic[@"icon"];
        
        
    }
    return self;
}

+(instancetype)NewsWithDict:(NSDictionary *)dic
{
    return [[self alloc]initWithDict:dic];
}

+(NSArray *)newsList
{
    NSArray * newsArray=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"newses.plist" ofType:nil]];
    
    NSMutableArray * muArray=[NSMutableArray array];
    
    for (NSDictionary * dic in newsArray) {
        
        [muArray addObject:[HMNews NewsWithDict:dic]];
    }
    return muArray;
}

@end
