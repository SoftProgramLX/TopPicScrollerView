//
//  LXBannerScrollerView.h
//  TopPicScrollerView
//
//  Created by 李旭 on 16/10/14.
//  Copyright © 2016年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXBannerScrollerView <NSObject>

- (void)bannerDelegate:(NSInteger)index;

@end

@interface LXBannerScrollerView : UIView

@property (nonatomic, assign) id<LXBannerScrollerView> delegate;

- (void)refreshPicWithImgURLArr:(NSArray *)urlArr;

@end
