//
//  LXBannerScrollerView.m
//  TopPicScrollerView
//
//  Created by 李旭 on 16/10/14.
//  Copyright © 2016年 LX. All rights reserved.
//

#import "LXBannerScrollerView.h"
#import "UIImageView+WebCache.h"

@interface LXBannerScrollerView () <UIScrollViewDelegate>
{
    //显示图片的滚动视图
    UIScrollView *_scrollView;
    
    //显示page的小圆点
    UIPageControl *_pageControll;
    
    NSMutableArray *imageArr;
    
    NSInteger adNumber;
    
    NSTimer *_timer;
    
    BOOL haveImg;
}

@end

@implementation LXBannerScrollerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageArr = [[NSMutableArray alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor grayColor];
        _scrollView.contentOffset = CGPointMake(self.width, 0);
        [self addSubview:_scrollView];
        
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(20, self.height-31, self.width - 40, 12)];
        [_pageControll addTarget:self action:@selector(pageControllClicked:) forControlEvents:UIControlEventValueChanged];
        _pageControll.currentPage = 0;
        _pageControll.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:_pageControll];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        [imageArr addObject:imageView];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(displayTime)userInfo:nil repeats:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [_scrollView addGestureRecognizer:tap];
    }
    return self;
}

- (void)refreshPicWithImgURLArr:(NSArray *)urlArr
{
    haveImg = YES;
    if (!(urlArr.count > 1)) {
        adNumber = 1;
        _scrollView.contentOffset = CGPointMake(0, 0);
        UIImageView *firtImageView = imageArr[0];
        
        if (urlArr.count == 1) {
            [self setImage:firtImageView withUrlString:urlArr[0]];
        } else {
            haveImg = NO;
            firtImageView.image = [UIImage imageNamed:@"no_thumb"];
        }
        
        [_timer invalidate];
        
    } else {
        adNumber = urlArr.count + 2;
        _scrollView.contentOffset = CGPointMake(self.width, 0);
        
        [self setImage:imageArr[0] withUrlString:urlArr[urlArr.count-1]];
        
        for (int i = 1; i < adNumber - 1 && urlArr.count; i++) {
            UIImageView *imgView = [self createImgViewWithIndex:i];
            [self setImage:imgView withUrlString:urlArr[i-1]];
        }
        
        UIImageView *lastImgView = [self createImgViewWithIndex:adNumber-1];
        [self setImage:lastImgView withUrlString:urlArr[0]];
    }
    
    _scrollView.contentSize = CGSizeMake(self.width*adNumber, self.height);
    _pageControll.frame = CGRectMake(20, self.height-21, self.width - 40, 12);
    _pageControll.numberOfPages = adNumber>2 ? adNumber-2 : 1;
    _pageControll.currentPage = 0;
}

#pragma mark - Enent response

- (void)tapGesture:(UITapGestureRecognizer*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerDelegate:)]) {
        NSInteger indedx = _scrollView.contentOffset.x/self.width - 1;
        if (indedx < 0 && haveImg) {
            indedx = 0;
        }
        [self.delegate bannerDelegate:indedx];
    }
}

- (void)displayTime
{
    float scrollViewX = _scrollView.contentOffset.x + self.width;
    if (scrollViewX > self.width * (adNumber-2)) {
        scrollViewX = self.width;
    };
    CGPoint point = CGPointMake(scrollViewX, _scrollView.frame.origin.y);
    _scrollView.contentOffset = point;
}

- (void)pageControllClicked:(UIPageControl*)pageControll
{
    //获取当前pagecontroll的值
    NSInteger page = pageControll.currentPage;
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_scrollView setContentOffset:CGPointMake(self.width*page, 0)];
}

#pragma mark --UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //通过滚动的偏移量来判断目前页面所对应的小白点
    int page = scrollView.contentOffset.x / self.width;
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
    if (adNumber > 2) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(displayTime)userInfo:nil repeats:YES];
    }
    
    //获取当前pagecontroll的值
    NSInteger page = _scrollView.contentOffset.x/self.width;
    if (page == imageArr.count-1) {
        _scrollView.contentOffset = CGPointMake(self.width, 0);
        page = 1;
    } else if (page == 0){
        _scrollView.contentOffset = CGPointMake((imageArr.count-1) * self.width, 0);
        page = imageArr.count-2;
    }
    //根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    [_scrollView setContentOffset:CGPointMake(self.width*page, 0)];
}

#pragma mark - Private methods

- (UIImageView *)createImgViewWithIndex:(NSInteger)index
{
    UIImageView *imageView;
    if (imageArr.count <= index) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + self.width * index, 0, self.width, self.height)];
        imageView.userInteractionEnabled = YES;
        [_scrollView addSubview:imageView];
        [imageArr addObject:imageView];
    } else {
        imageView = imageArr[index];
    }
    
    return imageView;
}

- (void)setImage:(UIImageView *)imgV withUrlString:(NSString *)string
{
    if ([string hasPrefix:@"http"]) {
        NSURL *imageUrl = [NSURL URLWithString:string];
        [imgV sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"bitmap"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imgV.image = [self cutImage:image withBackView:imgV];
        }];
    } else {
        imgV.image = [UIImage imageNamed:string];
    }
}

//裁剪图片
- (UIImage *)cutImage:(UIImage*)image withBackView:(UIView *)backView
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (backView.frame.size.width / backView.frame.size.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * backView.frame.size.height / backView.frame.size.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 4, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * backView.frame.size.width / backView.frame.size.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    
    return [UIImage imageWithCGImage:imageRef];
}

@end



