//
//  LXMainTableViewCell.m
//  CowBoy(iOS)
//
//  Created by apple on 14/12/2.
//  Copyright (c) 2014年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXBannerScrollerView.h"

#define kShopGroupBannerHeight (kMainScreenWidth * (221.0/368))

@interface LXTopPicCell : UITableViewCell

@property (nonatomic, assign)id<LXBannerScrollerView> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (void)configurationCell:(NSArray *)modelArr;

@end
