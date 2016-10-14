//
//  LXTopPicCell.m
//  CowBoy(iOS)
//
//  Created by apple on 14/12/2.
//  Copyright (c) 2014年 LX. All rights reserved.
//

#import "LXTopPicCell.h"

@interface LXTopPicCell ()

@property (nonatomic, weak)   LXBannerScrollerView *bannerView;

@end

@implementation LXTopPicCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"LXTopPicCell";
    LXTopPicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[LXTopPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        LXBannerScrollerView *bannerView = [[LXBannerScrollerView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kShopGroupBannerHeight)];
        [self addSubview:bannerView];
        self.bannerView = bannerView;
    }
    return self;
}

-(void)setDelegate:(id<LXBannerScrollerView>)delegate
{
    _delegate = delegate;
    self.bannerView.delegate = delegate;
}

- (void)configurationCell:(NSArray *)arr
{
    [self.bannerView refreshPicWithImgURLArr:arr];
}

@end


