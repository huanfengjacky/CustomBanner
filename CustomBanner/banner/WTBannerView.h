//
//  WTBannerView.h
//  TravelWorld
//
//  Created by mac on 2017/10/10.
//  Copyright © 2017年 JackyZhou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTBannerView;

@protocol WTBannerViewDataSource <NSObject>
@optional
- (NSInteger)bannerCount:(WTBannerView *)bannerView;
- (UIView *)bannerViewForIndex:(NSInteger)pageIndex;
@end


@protocol WTBannerViewDelegate <NSObject>
@optional
- (void)pageSelect:(NSInteger)pageIndex;
@end


@interface WTBannerView : UIView<UIScrollViewDelegate>
@property(nonatomic,strong)UIPageControl *pageControl;
@property(nonatomic,weak)id<WTBannerViewDelegate>delegate;
@property(nonatomic,weak)id<WTBannerViewDataSource>dataSource;
- (void)reloadData;

@end
