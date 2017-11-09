//
//  ViewController.m
//  CustomBanner
//
//  Created by mac on 2017/11/9.
//  Copyright © 2017年 JackyZhou. All rights reserved.
//

#import "ViewController.h"
#import "WTBannerView.h"
@interface ViewController ()<WTBannerViewDelegate,WTBannerViewDataSource>
@property (weak, nonatomic) IBOutlet WTBannerView *bannerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView.dataSource = self;
    self.bannerView.delegate = self;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)bannerCount:(WTBannerView *)bannerView
{
    return 3;
}
- (UIView *)bannerViewForIndex:(NSInteger)pageIndex
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image%ld",pageIndex]];
    return imageView;
}
- (void)pageSelect:(NSInteger)pageIndex
{
    NSLog(@"%ld",pageIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
