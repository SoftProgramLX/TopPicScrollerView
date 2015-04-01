//
//  ViewController.m
//  TopPicScrollerView
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 LX. All rights reserved.
//

#import "ViewController.h"
#import "LXTopPicCell.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, LXTopPicCellDelegate>
{
    NSMutableArray *adImgArr;
}

@property (strong, nonatomic)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    adImgArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [adImgArr addObject:image];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    self.tableView.bounces = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifer;
    if (indexPath.section == 0) {
        cellIdentifer = @"LXTopPicCell";
    } else {
        cellIdentifer = @"LXTableViewCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[LXTopPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer andDeleagte:self];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        
    }
    
    //    配置cell
    if (indexPath.section == 0) {
        [(LXTopPicCell *)cell configurationCell:adImgArr];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld  row", (long)indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld  %ld", (long)indexPath.section, (long)indexPath.row);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //根据屏幕的宽按比例自动计算滚动视图的高
        return kMainScreenWidth/kScrolHWRate;
    }
    return 50;
}

- (void)adDelegate:(NSInteger)index
{
    NSLog(@"%ld", (long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


