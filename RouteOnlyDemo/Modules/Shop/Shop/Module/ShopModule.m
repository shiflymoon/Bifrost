//
//  ShopModule.m
//  Shop
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "ShopModule.h"
#import "ShopBundle.h"
#import "ShopManager.h"
#import "ShopDetailViewController.h"
#import "BifrostHeader.h"

NSString *const kRouteShopDetail = @"//shop/detail";
NSString *const kRouteShopName = @"//shop/shopname";
NSString *const kRouteShopLogo = @"//shop/shoplogo";
NSString *const kRouteShopRevenue = @"//shop/shoprevenue";

@implementation ShopModule

+ (void)load {
    //ShopDetailViewController对外提供的可用服务
    [Bifrost bindURL:kRouteShopDetail toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc] init];
        return vc;
    }];
    
    [Bifrost bindURL:kRouteShopName toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
          return [[ShopManager sharedInstance] shopName];
    }];
    
    [Bifrost bindURL:kRouteShopLogo toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
       return  [[ShopManager sharedInstance] shopLogo];
    }];
    
    [Bifrost bindURL:kRouteShopRevenue toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        return @([[ShopManager sharedInstance] shopRevenue]);
    }];
}

@end
