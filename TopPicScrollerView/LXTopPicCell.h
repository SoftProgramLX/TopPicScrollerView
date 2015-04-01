//
//  LXMainTableViewCell.m
//  CowBoy(iOS)
//
//  Created by apple on 14/12/2.
//  Copyright (c) 2014年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LXTopPicCellDelegate <NSObject>

- (void)adDelegate:(NSInteger)index;

@end

@interface LXTopPicCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, assign)id<LXTopPicCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDeleagte:(id<LXTopPicCellDelegate>)delegate;

- (void)configurationCell:(NSArray *)modelArr;

@end
