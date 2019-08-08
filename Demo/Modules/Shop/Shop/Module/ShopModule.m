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

@implementation ShopModule

+ (void)load {
    BFRegister(ShopModuleService);
    for(NSInteger i=0; i<100; i++) {
        BFRegister(ShopModuleService);
    }
    
    //ShopDetailViewController对外提供的可用服务
    [Bifrost bindURL:kRouteShopDetail toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        ShopDetailViewController *vc = [[ShopDetailViewController alloc] init];
        return vc;
    }];
    
}

#pragma mark - BifrostModuleProtocol methods

+ (instancetype)sharedInstance {
    static ShopModule *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
    
}

- (void)setup {
    [[ShopManager sharedInstance] setup];
}

- (void)preLoadGoodsInfo {
    //some preload work here. it will take long time
    sleep(10);
}

#pragma mark - ShopModuleService
- (NSString*)shopName {
   /* 以下做法不合理，此类是对外Facade包装类，不应该实现业务逻辑，业务逻辑应该剥离
    return @"零售特工队";*/
    //推荐做法，将业务逻辑移动到service中
    return [[ShopManager sharedInstance] shopName];
}

- (UIImage*)shopLogo {
     /* 以下做法不合理，此类是对外Facade包装类，不应该实现业务逻辑，业务逻辑应该剥离
    return [ShopBundle imageNamed:@"shop_logo"];*/
    
    return [[ShopManager sharedInstance] shopLogo];
}

- (CGFloat)shopRevenue {
  /* 以下做法不合理，此类是对外Facade包装类，不应该实现业务逻辑，业务逻辑应该剥离
    return 666666.66;*/
    return [[ShopManager sharedInstance] shopRevenue];
}


@end
