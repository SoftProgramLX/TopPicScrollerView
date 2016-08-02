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
    
    adImgArr = [NSMutableArray arrayWithObjects:
                @"http://f.hiphotos.baidu.com/baike/pic/item/2f738bd4b31c8701bc5f7115277f9e2f0608ff5c.jpg",
                @"http://g.hiphotos.baidu.com/baike/pic/item/8718367adab44aed280d8dcfb01c8701a18bfb5d.jpg",
                @"http://f.hiphotos.baidu.com/baike/pic/item/f9198618367adab44f93286888d4b31c8701e45d.jpg",
                @"http://d.hiphotos.baidu.com/baike/pic/item/9d82d158ccbf6c81db3d54f1be3eb13533fa40a4.jpg",
                @"http://g.hiphotos.baidu.com/baike/pic/item/b21bb051f8198618081a16ac48ed2e738bd4e6bd.jpg",
                @"http://c.hiphotos.baidu.com/baike/pic/item/5bafa40f4bfbfbed414d05547bf0f736afc31f80.jpg", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight) style:UITableViewStylePlain];
    self.tableView.bounces = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    //在这儿可以设置关闭定时器
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:YES];
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
        //若广告轮播图的资源不会改变的话，TableView滚动时可以不用刷新，下面这句代码移动到上面实例化LXTopPicCell的地方就可以
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
    NSLog(@"点击了第 %ld 个广告图", (long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


