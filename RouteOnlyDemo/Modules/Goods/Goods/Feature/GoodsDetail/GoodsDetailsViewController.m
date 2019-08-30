//
//  GoodsDetailsViewController.m
//  Goods
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "GoodsDetailsViewController.h"
//#import "GoodsModuleService.h"
#import "GoodsManager.h"
#import "SaleModuleService.h"
//#import "GoodsModule.h"
#import "GoodsModel.h"
#import "BifrostHeader.h"

@interface GoodsDetailsViewController ()

//@property (nonatomic, strong) NSString *goodsId;

@end

@implementation GoodsDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Goods Detail";
    self.navigationItem.backBarButtonItem.title = @"";
    /*此处不应该反引用GoodModule造成业务入侵，GoodModule是对外服务的Facade模式实现
     没必要强制依赖Bifrost，只有模块间的业务依赖才需要通过Bifrost解耦。
    GoodsModel *goods = [[GoodsModule sharedInstance] goodsById:self.goodsId];*/
    //推荐做法
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
    NSNumber *goodNumber = [Bifrost handleURL:kRouteSaleShoppingCartGoodsNum];
    NSString *title = BFStr(@"购物车(%@)", goodNumber);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [item setTarget:self];
    [item setAction:@selector(goToShoppingCart)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addToShoppingCart {
    NSDictionary *paramDic =@{kRouteSaleAddShoppingCartGoodsParamGoodId:self.goodsId};
    [Bifrost handleURL:kRouteSaleAddShoppingCartGoods complexParams:paramDic completion:nil];

    [self updateShoppingCartBarButtonItem];
}

- (void)goToShoppingCart {
    UIViewController *vc = [Bifrost handleURL:kRouteSaleShoppingCart];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
