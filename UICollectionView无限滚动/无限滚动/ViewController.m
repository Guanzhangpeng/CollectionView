//
//  ViewController.m
//  无限滚动
//
//  Created by 管章鹏 on 16/1/19.
//  Copyright © 2016年 gzp. All rights reserved.
//

#define HMMaxSections 50

#import "ViewController.h"
#import "HMNews.h"
#import "HMViewCelll.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,weak)UICollectionView * collectionView;

@property(nonatomic,strong)UIPageControl * pageControl;

@property(nonatomic,strong)NSTimer * timer;

@property(nonatomic,strong)NSArray * newsArray;

@end

@implementation ViewController

static NSString * const ID=@"image";


-(NSArray *)newsArray
{
    if (_newsArray==nil) {
        
        _newsArray=[HMNews newsList];
        
        self.pageControl.numberOfPages=_newsArray.count;
    }
    return _newsArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViewControls];//初始化控件
    
    //默认显示最中间的那组的第一个图片；
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:HMMaxSections/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [self addTimer];
    
}
//初始化CollectionView控件
-(void)initViewControls
{
    //初始化CollectionViewFlowLayout流水布局；
    UICollectionViewFlowLayout * layOut=[[UICollectionViewFlowLayout alloc]init];
    
    //设置水平方向滚动；
    layOut.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    //设置item大小
    layOut.itemSize=CGSizeMake(self.view.frame.size.width-40, 220);
    
    
    // 行间距
    layOut.minimumLineSpacing = 0;
    
    // 设置cell之间的间距
    layOut.minimumInteritemSpacing = 0;
    
    
    
    CGRect rect=CGRectMake(20, 50, self.view.frame.size.width-40, 220);
    
    
    UICollectionView * collectionView=[[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layOut];
    
    
    //注册CollectionViewCell
    [collectionView registerNib:[UINib nibWithNibName:@"HMViewCelll" bundle:nil] forCellWithReuseIdentifier:ID];
    
    collectionView.dataSource=self;
    collectionView.delegate=self;
    
    //启用分页
    collectionView.pagingEnabled=YES;
    
    //取消水平滚动条
    collectionView.showsHorizontalScrollIndicator=NO;
    //取消弹簧效果
    collectionView.bounces=NO;
    collectionView.backgroundColor=[UIColor redColor];
    self.collectionView=collectionView;
    [self.view addSubview: collectionView];
    
    
    //初始化UIPageControl控件；
    _pageControl=[[UIPageControl alloc]init];
    
    CGSize pageSize=[_pageControl sizeForNumberOfPages:self.newsArray.count];
    
    CGFloat pageControlX=self.view.frame.size.width-60-pageSize.width;
    
    CGFloat pageControlY=CGRectGetMaxY(self.collectionView.frame)-pageSize.height;
    
    _pageControl.frame=CGRectMake(pageControlX, pageControlY, pageSize.width, pageSize.height);
    
    _pageControl.currentPageIndicatorTintColor=[UIColor redColor];
    _pageControl.pageIndicatorTintColor=[UIColor greenColor];
    
//    _pageControl.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:_pageControl];

}


//添加定时器
-(void)addTimer
{
    NSTimer * timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer=timer;
    
}

//添加定时器
-(void)removeTimer
{
    [self.timer invalidate];
    self.timer=nil;//清空定时器
    
}

-(NSIndexPath *)resetIndexPath
{
    //当前正在显示的位置
    NSIndexPath * currentIndexPath=[[self.collectionView indexPathsForVisibleItems] lastObject];
    
    //最中间的那组数据
    NSIndexPath * currentIndexPathReset=[NSIndexPath indexPathForItem:currentIndexPath.item inSection:HMMaxSections/2];
    
    
    //默默的滚动到最中间的那组数据，不需要动画效果；
    [self.collectionView scrollToItemAtIndexPath:currentIndexPathReset atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    return currentIndexPathReset;
    
}
-(void)nextPage
{
//拿到最中间的那组数据
    NSIndexPath * currentIndexPathReset=[self resetIndexPath];
    
    //计算下一个需要显示的位置
    NSInteger nextItem=currentIndexPathReset.item+1;
    NSInteger currentSection=currentIndexPathReset.section;
    
    if (nextItem==self.newsArray.count) {
        nextItem=0;
        currentSection++;
    }
    
    NSIndexPath * currentIndexPath=[NSIndexPath indexPathForItem:nextItem inSection:currentSection];
    
    //通过动画滚动到下一个位置
    [self.collectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    
}

#pragma mark UICollectionViewDataSource

//总共有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  HMMaxSections;
}
//每一组有几个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.newsArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMViewCelll * cell=[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor greenColor];
    
    cell.news=self.newsArray[indexPath.item];
    
    return cell;
}

#pragma mark  UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   HMNews * news= self.newsArray[indexPath.item];
    NSLog(@"%@",news.title);
}

//当用户即将开始拖拽的时候开始调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //取消定时器
    [self removeTimer];
}

//当用户停止拖拽的时候开始调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //添加定时器
    [self addTimer];
}

//用户手指在上面拖拽的时候调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.newsArray.count;
    self.pageControl.currentPage = page;
}

////当手拖动页面的时候 重置页码
//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndDecelerating-----返回");
//
//    [self resetIndexPath];//重置页码
//}

@end
