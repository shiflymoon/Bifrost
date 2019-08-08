//
//  GoodsDetailsViewController.m
//  Goods
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "GoodsDetailsViewController.h"
#import "GoodsManager.h"
#import "CTMediator+SaleModule.h"

@interface GoodsDetailsViewController ()

@end

@implementation GoodsDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Goods Detail";
    self.navigationItem.backBarButtonItem.title = @"";
    GoodsModel *goods = [[GoodsManager sharedInstance] goodsById:self.goodsId];
    if (goods) {
        self.title = goods.name;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    //buy button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"加入购物车" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 400, self.view.frame.size.width - 200, 100);
    [button addTarget:self
               action:@selector(addToShoppingCart)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateShoppingCartBarButtonItem];
}

- (void)updateShoppingCartBarButtonItem {
    NSString *title = [NSString stringWithFormat:@"购物车(%lu)", [[CTMediator sharedInstance] saleModule_shoppinCartGoodsNum]];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [item setTarget:self];
    [item setAction:@selector(goToShoppingCart)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addToShoppingCart {
    [[CTMediator sharedInstance] saleModule_addShoppingCartGoods:self.goodsId];
    [self updateShoppingCartBarButtonItem];
}

- (void)goToShoppingCart {
    UIViewController *vc = [[CTMediator sharedInstance] saleModule_saleShoppingCartViewController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
