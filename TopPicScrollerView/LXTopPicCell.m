//
//  LXTopPicCell.m
//  CowBoy(iOS)
//
//  Created by apple on 14/12/2.
//  Copyright (c) 2014年 LX. All rights reserved.
//

#import "LXTopPicCell.h"

@interface LXTopPicCell ()
{
    //显示图片的滚动视图
    UIScrollView *_scrollView;
    
    //显示page的小圆点
    UIPageControl *_pageControll;
    
    NSMutableArray *imageArr;
    
    NSInteger adNumber;
    
    NSTimer *_timer;
}

@end

@implementation LXTopPicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDeleagte:(id<LXTopPicCellDelegate>)delegate
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.delegate = delegate;
        imageArr = [[NSMutableArray alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, ScrollerHeight)];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
        [self addSubview:_scrollView];
        
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(20, ScrollerHeight-31, kMainScreenWidth - 40, 12)];
        [_pageControll addTarget:self action:@selector(pageControllClicked:) forControlEvents:UIControlEventValueChanged];
        _pageControll.currentPage = 0;
        _pageControll.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControll];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(displayTime)userInfo:nil repeats:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapGesture:(UITapGestureRecognizer*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(adDelegate:)])
    {
        [self.delegate adDelegate:_scrollView.contentOffset.x/kMainScreenWidth - 1];
    }
}

- (void)configurationCell:(NSArray *)arr
{
    adNumber = arr.count + 2;
    
    if (adNumber > imageArr.count) {
        for (NSInteger i = imageArr.count; i < adNumber; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+kMainScreenWidth*i, 0, kMainScreenWidth, ScrollerHeight)];
            imageView.userInteractionEnabled = YES;
            [_scrollView addSubview:imageView];
            [imageArr addObject:imageView];
            
            if (!arr.count) {
                break;
            }
        }
    }
    
    for (int i = 1; i < adNumber - 1 && arr.count; i++) {
        UIImageView *imageView = imageArr[i];
        imageView.image = arr[i-1];
    }
    
    UIImageView *firtImageView = imageArr[0];
    if (!arr.count) {
        adNumber = 0;
        firtImageView.image = [UIImage imageNamed:@"no_thumb.png"];
    } else {
        firtImageView.image = arr[arr.count-1];
        
        UIImageView * lastImageView= imageArr[adNumber-1];
        lastImageView.image = arr[0];
    }
    
    _scrollView.contentSize = CGSizeMake(kMainScreenWidth*adNumber, ScrollerHeight);
    _pageControll.numberOfPages = arr.count;
}


- (void)displayTime
{
    float scrollViewX = _scrollView.contentOffset.x + kMainScreenWidth;
    if (scrollViewX > kMainScreenWidth * (adNumber-2)) {
        scrollViewX = kMainScreenWidth;
    };
    CGPoint point = CGPointMake(scrollViewX, _scrollView.frame.origin.y);
    _scrollView.contentOffset = point;
}

#pragma mark--UIPageControl 事件处理
- (void)pageControllClicked:(UIPageControl*)pageControll
{
    //获取当前pagecontroll的值
    NSInteger page = pageControll.currentPage;
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_scrollView setContentOffset:CGPointMake(kMainScreenWidth*page, 0)];
}

#pragma mark --UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //通过滚动的偏移量来判断目前页面所对应的小白点
    int page = scrollView.contentOffset.x / kMainScreenWidth;
    //pagecontroll响应值的变化
    _pageControll.currentPage = page-1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //滚动开始时停止定时器
    [_timer invalidate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //滚动结束时开始定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(displayTime)userInfo:nil repeats:YES];
    
    //获取当前pagecontroll的值
    NSInteger page = _scrollView.contentOffset.x/kMainScreenWidth;
    if (page == imageArr.count-1) {
        _scrollView.contentOffset = CGPointMake(kMainScreenWidth, 0);
        page = 1;
    }else if (page == 0){
        _scrollView.contentOffset = CGPointMake((imageArr.count-1) * kMainScreenWidth, 0);
        page = imageArr.count-2;
    }
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_scrollView setContentOffset:CGPointMake(kMainScreenWidth*page, 0)];
}

@end




