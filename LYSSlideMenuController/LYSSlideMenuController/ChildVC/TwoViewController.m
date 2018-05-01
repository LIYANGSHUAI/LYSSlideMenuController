//
//  TwoViewController.m
//  LYSSlideMenuController
//
//  Created by HENAN on 2018/3/29.
//  Copyright © 2018年 李阳帅. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *datatAry;
@end

@implementation TwoViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self show];
        
        NSArray *dataAry = @[@{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 },
                             @{
                                 @"name": @"数码产品",
                                 @"detail": @"手机,电脑等",
                                 }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hidden];
            [self.tableView.mj_header endRefreshing];
            self.datatAry = dataAry;
            [self.tableView reloadData];
        });
    }];
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController didViewDidLoad:(NSInteger)index{
    [self.view addSubview:self.tableView];
    [self addRefresh];
    [self show];
    
    NSArray *dataAry = @[@{
                             @"name": @"数码产品",
                             @"detail": @"手机,电脑等",
                             },
                         @{
                             @"name": @"数码产品",
                             @"detail": @"手机,电脑等",
                             },
                         @{
                             @"name": @"数码产品",
                             @"detail": @"手机,电脑等",
                             },
                         @{
                             @"name": @"数码产品",
                             @"detail": @"手机,电脑等",
                             }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hidden];
        [self.tableView.mj_header endRefreshing];
        self.datatAry = dataAry;
        [self.tableView reloadData];
    });
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillDisappear:(NSInteger)index{
    NSLog(@"将要消失---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidDisappear:(NSInteger)index{
    NSLog(@"已经消失---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewWillAppear:(NSInteger)index{
    NSLog(@"将要出现---%ld",index);
}

- (void)slideMenuController:(LYSSlideMenuController *)slideMenuController viewDidAppear:(NSInteger)index{
    NSLog(@"已经出现---%ld",index);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datatAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    NSDictionary *dict = self.datatAry[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.detailTextLabel.text = dict[@"detail"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
