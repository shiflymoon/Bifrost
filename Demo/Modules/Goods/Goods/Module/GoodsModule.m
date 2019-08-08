//
//  GoodsModule.m
//  Goods
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "GoodsModule.h"
#import "GoodsModel.h"
#import "GoodsManager.h"
#import "GoodsListViewController.h"
#import "GoodsDetailsViewController.h"

@implementation GoodsModule

+ (void)load {
    BFRegister(GoodsModuleService);
    
    //GoodsListViewController对外服务
    [Bifrost bindURL:kRouteAllGoodsList toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        GoodsListViewController *vc = [[GoodsListViewController alloc] initWithStyle:UITableViewStylePlain];
        return vc;
    }];
    
    //GoodsDetailsViewController对外服务
    [Bifrost bindURL:kRouteGoodsDetail toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc] init];
        vc.goodsId = parameters[kRouteGoodsDetailParamId];
        return vc;
    }];
    for (NSInteger i=0; i<10000; i++) {
        NSString *url = BFStr(@"//test/test_%ld", i);
        [Bifrost bindURL:url toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
            GoodsDetailsViewController *vc = [[GoodsDetailsViewController alloc] init];
            vc.goodsId = parameters[kRouteGoodsDetailParamId];
            return vc;
        }];
    }
}

#pragma mark - BifrostModuleProtocol methods

+ (instancetype)sharedInstance {
    static GoodsModule *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setup {
    [[GoodsManager sharedInstance] setup];
}

#pragma mark - GoodsModuleService
- (NSInteger)totalInventory {
    /* 以下做法不合理，此类是对外Facade包装类，不应该实现业务逻辑，业务逻辑应该剥离
    NSArray *list = [self allGoodsList];
    NSInteger count = 0;
    for (GoodsModel *goods in list) {
        count += goods.inventory;
    }
    return count;   */
    //推荐做法
    return [[GoodsManager sharedInstance] totalInventory];
}
    
- (id<GoodsProtocol>)goodsById:(NSString*)goodsId {
    /* 以下做法不合理，此类是对外Facade包装类，不应该实现业务逻辑，业务逻辑应该剥离
    GoodsModel *goods = [[GoodsModel alloc] init];
    goods.goodsId = goodsId;
    goods.name = BFStr(@"GoodsName_%@", goodsId);
    goods.price = [goodsId integerValue];
    goods.inventory = 66;
    return goods;*/
    //推荐做法
    return [[GoodsManager sharedInstance] goodsById:goodsId];
}

- (nonnull NSArray<id<GoodsProtocol>> *)allGoodsList {
    /* 以下做法不合理，此类是对外Facade包装类，不应该实现业务逻辑，业务逻辑应该剥离
    NSMutableArray *list = [NSMutableArray array];
    NSInteger count = 20;
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goods = [[GoodsModel alloc] init];
        goods.goodsId = [NSString stringWithFormat:@"%ld", (long)i];
        goods.name = BFStr(@"GoodsName_%ld", (long)i);
        goods.price = i;
        goods.inventory = 66*i;
        [list addObject:goods];
    }
    return list;
      */
    //推荐做法
    return [[GoodsManager sharedInstance] allGoodsList];
}


- (nonnull NSArray<id<GoodsProtocol>> *)popularGoodsList {
    /* 以下做法不合理，此类是对外Facade包装类，不应该实现业务逻辑，业务逻辑应该剥离
    NSMutableArray *list = [NSMutableArray array];
    NSInteger count = 10;
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goods = [[GoodsModel alloc] init];
        goods.goodsId = [NSString stringWithFormat:@"%ld", (long)i];
        goods.name = BFStr(@"GoodsName_%ld", (long)i);
        goods.price = i;
        goods.inventory = 66*i;
        [list addObject:goods];
    }
    return list;
     */
    //推荐做法
    return [[GoodsManager sharedInstance] popularGoodsList];
}


@end
