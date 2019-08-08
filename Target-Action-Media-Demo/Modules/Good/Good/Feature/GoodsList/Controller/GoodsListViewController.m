//
//  GoodsListViewController.m
//  Goods
//
//  Created by yangke on 2019/3/3.
//  Copyright © 2019 jackie@youzan. All rights reserved.
//

#import "GoodsListViewController.h"
#import "GoodsDetailsViewController.h"
#import "CTMediator+SaleModule.h"
#import "GoodsManager.h"

@interface GoodsListViewController ()
@property (nonatomic, strong) NSArray *goodsList;
@end

@implementation GoodsListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"All Goods List";
    self.navigationItem.backBarButtonItem.title = @"";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.goodsList = [[GoodsManager sharedInstance] allGoodsList] ;
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShoppingCartBarButtonItem];
}

- (void)updateShoppingCartBarButtonItem {
    NSString *title = [NSString stringWithFormat:@"购物车(%lu)",[[CTMediator sharedInstance] saleModule_shoppinCartGoodsNum]];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [item setTarget:self];
    [item setAction:@selector(goToShoppingCart)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)goToShoppingCart {
    UIViewController *vc = [[CTMediator sharedInstance] saleModule_saleShoppingCartViewController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    GoodsModel *goods = self.goodsList[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    NSString *text = [NSString stringWithFormat:@"%@ : ￥%.2f", goods.name, goods.price];
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GoodsModel  *goods = self.goodsList[indexPath.row];
    GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc] init];
    vc.goodsId = goods.goodsId;
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
