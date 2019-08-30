//
//  SaleModule.m
//  SaleModule
//
//  Created by youzan on 2017/2/28.
//  Copyright (c) 2017年 youzan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaleModule.h"
#import "ShoppingCartManager.h"
#import "SaleManager.h"
#import "ShoppingCartViewController.h"
#import "BifrostHeader.h"

NSString *const kRouteSaleShoppingCart = @"//sale/shopping_chart";

NSString *const kRouteSaleAddShoppingCartGoods = @"//sale/add_goods_shoppingcart";
NSString *const kRouteSaleAddShoppingCartGoodsParamGoodId = @"goodId";
NSString *const kRouteSaleShoppingCartGoodsNum = @"//sale/shoppingcart_goodsnum";

@interface SaleModule()

@end

@implementation SaleModule

+ (void)load {
    
    [Bifrost bindURL:kRouteSaleShoppingCart toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        ShoppingCartViewController *vc = [[ShoppingCartViewController alloc] init];
        return vc;
    }];
    
    [Bifrost bindURL:kRouteSaleAddShoppingCartGoods toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        NSString *goodsId =parameters[kRouteSaleAddShoppingCartGoodsParamGoodId];
        [[ShoppingCartManager sharedInstance] addGoods:goodsId withNum:1];
        return nil;
    }];
    
    [Bifrost bindURL:kRouteSaleShoppingCartGoodsNum toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
     return @([[ShoppingCartManager sharedInstance] shoppinCartGoodsNum]);
    }];
}

@end
