//
//  WTBannerView.m
//  TravelWorld
//
//  Created by mac on 2017/10/10.
//  Copyright © 2017年 JackyZhou. All rights reserved.
//

#import "WTBannerView.h"

#define kTimeInterval 2
@interface WTBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSTimer *timer;

@end
@implementation WTBannerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    [self addSubview:self.pageControl];
}
//定时器
- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector (imagePlay) userInfo:nil repeats:YES];
    }
    return _timer;
}
- (void)imagePlay
{
    _page++;
    NSInteger count =  [self.dataSource bannerCount:self];

    if (_page == count) {
        _page = 0;
    }
    [self.collectionView setContentOffset:CGPointMake(self.frame.size.width*_page, 0) animated:YES];
    self.pageControl.currentPage = _page;
}
//重新加载
- (void)reloadData
{
    if (self.dataSource) {
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = [self.dataSource bannerCount:self];
        self.timer.fireDate = [NSDate distantPast];
        _page = 0;
        [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.collectionView.frame = rect;
    self.pageControl.frame = CGRectMake(0, rect.size.height-20, rect.size.width, 20);
    if (self.dataSource) {
        [self reloadData];
    }
}

#pragma mark--UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (self.dataSource) {
        count = [self.dataSource bannerCount:self];
    }
    return count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    if (self.dataSource) {
        cell.backgroundView = [self.dataSource bannerViewForIndex:indexPath.row];
    }
    cell.clipsToBounds = YES;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(pageSelect:)]) {
        [self.delegate pageSelect:indexPath.row];
    }
}


#pragma mark--UIScrollViewDelegate
//滑动时的停止计时
- (void)scrollViewWillBeginDragging:(__unused UIScrollView *)scrollView
{
    self.timer.fireDate = [NSDate distantFuture];
}


- (void)scrollViewWillBeginDecelerating:(__unused UIScrollView *)scrollView
{
    self.timer.fireDate = [NSDate distantFuture];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/self.frame.size.width;
    _page = scrollView.contentOffset.x/self.frame.size.width;
    [self performSelector:@selector(recoverTimer) withObject:nil afterDelay:kTimeInterval];
}
//回复计时
- (void)recoverTimer
{
    self.timer.fireDate = [NSDate distantPast];
}
- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
