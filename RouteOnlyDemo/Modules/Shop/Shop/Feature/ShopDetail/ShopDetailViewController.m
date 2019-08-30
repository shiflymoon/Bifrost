//
//  ShopDetailViewController.m
//  Shop
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "ShopDetailViewController.h"
//#import "ShopModuleService.h"
#import "SaleModuleService.h"
//#import "ShopModule.h"
#import "ShopManager.h"
#import "Bifrost+Router.h"

@interface ShopDetailViewController ()

@end

@implementation ShopDetailViewController

//建议有关注册的全部移动到对外Module接口中，方便管理，同时减少对业务代码入侵
/*
+ (void)load {
    [Bifrost bindURL:kRouteShopDetail toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        ShopDetailViewController *vc = [[self alloc] init];
        return vc;
    }];
}*/


- (void)viewDidLoad {
    [super viewDidLoad];
    /* 此处不应该反引用shopModule造成业务入侵，ShopModule是对外服务的Facade模式实现
    self.title = [ShopModule sharedInstance].shopName;
     */
    //推荐做法
    self.title = [ShopManager sharedInstance].shopName;
    self.navigationItem.backBarButtonItem.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    label.text = @"This is the page for shop details";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [self updateShoppingCartBarButtonItem];
}

- (void)updateShoppingCartBarButtonItem {
    //这是模块间的业务依赖，无法避免，必须依赖中间件
    NSNumber *goodNum = [Bifrost handleURL:kRouteSaleShoppingCartGoodsNum];
    NSString *title = BFStr(@"购物车(%@)", goodNum);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    [item setTarget:self];
    [item setAction:@selector(goToShoppingCart)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)goToShoppingCart {
    //这是模块间的业务依赖，无法避免，必须依赖中间件
    UIViewController *vc = [Bifrost handleURL:kRouteSaleShoppingCart];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
