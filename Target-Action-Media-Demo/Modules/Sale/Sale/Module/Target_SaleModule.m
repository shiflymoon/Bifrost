//
//  Target_SaleModule.m
//  Sale
//
//  Created by 史贵岭 on 2019/8/6.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "Target_SaleModule.h"
#import "ShoppingCartManager.h"
#import "SaleManager.h"
#import "ShoppingCartViewController.h"

extern NSString * const kSaleModuleShoppingCartParamGoodId ;
extern NSString * const kSaleModuleShoppingCartParamNum;

@implementation Target_SaleModule
#pragma mark 模块初始化
-(void) Action_setUp
{
    [[SaleManager sharedInstance] setup];
}

#pragma mark - SaleModuleService
- (void)Action_addGoodsAndNum:(NSDictionary *)params
{
    NSString *goodsId = params[kSaleModuleShoppingCartParamGoodId];
    NSUInteger num = [params[kSaleModuleShoppingCartParamNum] unsignedIntegerValue];
    [[ShoppingCartManager sharedInstance] addGoods:goodsId withNum:num];
}

- (void)Action_addShoppingCartGoods:(NSDictionary*)params
{
    NSString *goodsId = params[kSaleModuleShoppingCartParamGoodId];
    [[ShoppingCartManager sharedInstance] addGoods:goodsId withNum:1];
}

- (NSUInteger)Action_shoppinCartGoodsNum {
    return [[ShoppingCartManager sharedInstance] shoppinCartGoodsNum];
}

-(UIViewController *) Action_saleShoppingCartViewController
{
    return [[ShoppingCartViewController alloc] init];
}
@end
