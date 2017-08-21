//
//  HMNews.h
//  无限滚动
//
//  Created by 管章鹏 on 16/1/19.
//  Copyright © 2016年 gzp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMNews : NSObject

@property(nonatomic,copy)NSString * title;

@property(nonatomic,copy)NSString * icon;

-(instancetype)initWithDict:(NSDictionary *)dic;

+(instancetype)NewsWithDict:(NSDictionary *)dic;

+(NSArray *)newsList;

@end
