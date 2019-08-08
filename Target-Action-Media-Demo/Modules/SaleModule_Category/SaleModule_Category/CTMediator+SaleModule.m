//
//  CTMediator+SaleModule.m
//  SaleModule_Category
//
//  Created by 史贵岭 on 2019/8/6.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator+SaleModule.h"

NSString * const kSaleModuleShoppingCartParamGoodId =@"goodId";
NSString * const kSaleModuleShoppingCartParamNum =@"number";

NSString * const SaleModuleTarget = @"SaleModule";
@implementation CTMediator (SaleModule)

+(void) load
{
    [[CTMediator sharedInstance] performTarget:SaleModuleTarget action:@"setUp" params:nil shouldCacheTarget:NO];
}

- (void)saleModule_addGoods:(NSString*)goodsId withNum:(NSUInteger)num
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kSaleModuleShoppingCartParamGoodId] = goodsId;
    params[kSaleModuleShoppingCartParamNum] = @(num);
    [self performTarget:SaleModuleTarget action:@"addGoodsAndNum:" params:params shouldCacheTarget:NO];
}

- (void)saleModule_addShoppingCartGoods:(NSString*)goodsId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kSaleModuleShoppingCartParamGoodId] = goodsId;
    [self performTarget:SaleModuleTarget action:@"addShoppingCartGoods:" params:params shouldCacheTarget:NO];
}

- (NSUInteger)saleModule_shoppinCartGoodsNum
{
    return [[self performTarget:SaleModuleTarget action:@"shoppinCartGoodsNum" params:nil shouldCacheTarget:NO] unsignedIntegerValue];
}

- (UIViewController *) saleModule_saleShoppingCartViewController
{
    return [self performTarget:SaleModuleTarget action:@"saleShoppingCartViewController" params:nil shouldCacheTarget:NO];
}
@end
