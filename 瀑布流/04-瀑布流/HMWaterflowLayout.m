//
//  HMWaterflowLayout.m
//  瀑布流效果
//
//  Created by 管章鹏 on 16/10/15.
//  Copyright © 2016年 stw. All rights reserved.
//

#import "HMWaterflowLayout.h"


@interface HMWaterflowLayout();

/** 这个字典用来存储每一列最大的Y值(每一列的高度) */
@property (nonatomic, strong) NSMutableDictionary *maxYDict;

/** 存放所有的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation HMWaterflowLayout


#pragma  mark 数据懒加载
- (NSMutableDictionary *)maxYDict
{
    if (!_maxYDict) {
        
        _maxYDict = [[NSMutableDictionary alloc] init];
    }
    return _maxYDict;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        
        self.attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}


#pragma mark 数据初始化
//在这里我们也可以将数据初始化的方法放到prepareLayout方法中去实现，但是init方法在对象初始化的时候就执行了，而且只执行一次。但是prepareLayout只要显示的边界发生改变就会再次调用。
- (instancetype)init
{
    if (self = [super init]) {
        
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.columnsCount = 3;
        
    }
    return self;
}

/**
 *  只要显示的边界发生改变就重新布局:
 内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

/** *  每次布局之前的准备 */
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 1.清空最大的Y值
    for (int i = 0; i<self.columnsCount; i++) {
        NSString *column = [NSString stringWithFormat:@"%d", i];
        self.maxYDict[column] = @(self.sectionInset.top);//默认最大高度
    }
    
    // 2.计算所有cell的layoutAttributes属性
    [self.attrsArray removeAllObjects];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i = 0; i<count; i++) {
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [self.attrsArray addObject:attrs];
    }
}

/** * 由于UICollectionView对它的content并不知情，所以布局首先要提供的信息就是滚动区域大小。这个方法返回UICollectionView的contentSize */
- (CGSize)collectionViewContentSize
{
    __block NSString *maxColumn = @"0";
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] > [self.maxYDict[maxColumn] floatValue]) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxYDict[maxColumn] floatValue] + self.sectionInset.bottom);
}

/**获取某个indexPath下cell的LayoutAttributes信息*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 假设最短的那一列的第0列
    __block NSString *minColumn = @"0";
    // 找出最短的那一列
    [self.maxYDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL *stop) {
        if ([maxY floatValue] < [self.maxYDict[minColumn] floatValue]) {
            minColumn = column;
        }
    }];
    
    // 计算尺寸
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnsCount - 1) * self.columnMargin)/self.columnsCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 计算位置
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColumn intValue];
    CGFloat y = [self.maxYDict[minColumn] floatValue] + self.rowMargin;
    
    // 更新这一列的最大Y值
    self.maxYDict[minColumn] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    return attrs;
}

/**获取在某个区域内rect 可见cell的Attributes信息 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

@end
