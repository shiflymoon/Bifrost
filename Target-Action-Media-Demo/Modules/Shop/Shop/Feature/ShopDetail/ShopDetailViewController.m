//
//  ShopDetailViewController.m
//  Shop
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "CTMediator+SaleModule.h"

@interface ShopDetailViewController ()

@end

@implementation ShopDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"零售特工队";
    self.navigationItem.backBarButtonItem.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200)];
    label.text = @"This is the page for shop details";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [self updateShoppingCartBarButtonItem];
}

- (void)updateShoppingCartBarButtonItem {
    NSString *title =[NSString stringWithFormat:@"购物车(%lu)", [[CTMediator sharedInstance] saleModule_shoppinCartGoodsNum]];

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

@end
