//
//  HMWaterflowLayout.h
//  瀑布流效果
//
//  Created by 管章鹏 on 16/10/15.
//  Copyright © 2016年 stw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMWaterflowLayout;

@protocol HMWaterflowLayoutDelegate <NSObject>

//根据行号 以及给定的宽度 计算出宽高比，从而返回对应的高度
- (CGFloat)waterflowLayout:(HMWaterflowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface HMWaterflowLayout : UICollectionViewLayout


@property (nonatomic, assign) UIEdgeInsets sectionInset;

/** 每一列之间的间距 */
@property (nonatomic, assign) CGFloat columnMargin;

/** 每一行之间的间距 */
@property (nonatomic, assign) CGFloat rowMargin;

/** 显示多少列 */
@property (nonatomic, assign) int columnsCount;


@property (nonatomic, weak) id<HMWaterflowLayoutDelegate> delegate;

@end
