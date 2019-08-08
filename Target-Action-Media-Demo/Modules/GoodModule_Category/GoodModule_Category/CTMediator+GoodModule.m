//
//  CTMediator+GoodModule.m
//  GoodModule_Category
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator+GoodModule.h"

NSString *const kGoodsModelParamGoodId = @"goodsId";//value为NSString
NSString *const kGoodsModelParamGoodName = @"name";//value为NSString
NSString *const kGoodsModelParamGoodPrice = @"price";//value为NSNumber
NSString *const kGoodsModelParamGoodInventory = @"inventory";//value为NSNumber

NSString * const GoodModuleTarget = @"GoodModule";
@implementation CTMediator (GoodModule)

#pragma mark - 需要提前初始化代码
+(void) load
{
    [[CTMediator sharedInstance] performTarget:GoodModuleTarget action:@"setup" params:nil shouldCacheTarget:NO];
}

#pragma mark - GoodModule Service
- (UIViewController *)goodModule_goodsListViewController
{
    return [self performTarget:GoodModuleTarget action:@"goodsListViewController" params:nil shouldCacheTarget:NO];
}

- (UIViewController *)goodModule_goodsDetailViewController:(NSString *) goodId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kGoodsModelParamGoodId] = goodId;
    return [self performTarget:GoodModuleTarget action:@"goodsDetailViewController:" params:params shouldCacheTarget:NO];
}
- (NSInteger)goodModule_totalInventory
{
    return [[self performTarget:GoodModuleTarget action:@"totalInventory" params:nil shouldCacheTarget:NO] integerValue];
}
//商品的key值参见kGoodsModelParamGoodId & kGoodsModelParamGoodName & kGoodsModelParamGoodPrice & kGoodsModelParamGoodInventory
- (NSArray<NSDictionary *>*)goodModule_popularGoodsList//热卖商品
{
    return [self performTarget:GoodModuleTarget action:@"popularGoodsList" params:nil shouldCacheTarget:NO];
}
- (NSArray<NSDictionary *>*)goodModule_allGoodsList //所有商品
{
    return [self performTarget:GoodModuleTarget action:@"allGoodsList" params:nil shouldCacheTarget:NO];
}
- (NSDictionary *)goodModule_goodsById:(nonnull NSString*)goodsId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kGoodsModelParamGoodId] = goodsId;
    return [self performTarget:GoodModuleTarget action:@"goodsById:" params:params shouldCacheTarget:NO];
}
@end
