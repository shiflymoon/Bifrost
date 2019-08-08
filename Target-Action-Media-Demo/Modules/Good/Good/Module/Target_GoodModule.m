//
//  Target_GoodModule.m
//  Good
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "Target_GoodModule.h"
#import "GoodsModel.h"
#import "GoodsManager.h"
#import "GoodsDetailsViewController.h"
#import "GoodsListViewController.h"

UIKIT_EXTERN NSString *const kGoodsModelParamGoodId ;
UIKIT_EXTERN NSString *const kGoodsModelParamGoodName ;
UIKIT_EXTERN NSString *const kGoodsModelParamGoodPrice ;
UIKIT_EXTERN NSString *const kGoodsModelParamGoodInventory ;

@implementation Target_GoodModule
- (void) Action_setup
{
     [[GoodsManager sharedInstance] setup];
}

- (UIViewController *)Action_goodsDetailViewController:(NSDictionary *) params
{
    NSString *goodId = params[kGoodsModelParamGoodId];
    GoodsDetailsViewController *detailVC = [[GoodsDetailsViewController alloc] init];
    detailVC.goodsId = goodId;
    return detailVC;
}

- (UIViewController *)Action_goodsListViewController
{
    GoodsListViewController * goodLVC = [[GoodsListViewController alloc] initWithStyle:UITableViewStylePlain];
    return goodLVC;
}

- (NSInteger)Action_totalInventory
{
    return [[GoodsManager sharedInstance] totalInventory];
}

//商品的key值参见kGoodsModelParamGoodId & kGoodsModelParamGoodName & kGoodsModelParamGoodPrice & kGoodsModelParamGoodInventory
- (NSArray<NSDictionary *>*)Action_popularGoodsList //热卖商品
{
    NSMutableArray *list = [NSMutableArray array];
    NSArray<GoodsModel*> *goodsModelArray = [[GoodsManager sharedInstance] popularGoodsList];
    NSInteger count = goodsModelArray.count;
    
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goodModel = goodsModelArray[i];
        NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
        goodDic[kGoodsModelParamGoodId] = goodModel.goodsId;
        goodDic[kGoodsModelParamGoodName] = goodModel.name;
        goodDic[kGoodsModelParamGoodPrice] = @(goodModel.price);
        goodDic[kGoodsModelParamGoodInventory] = @(goodModel.inventory);
        [list addObject:goodDic];
    }
    return list;
}

- (NSArray<NSDictionary *>*)Action_allGoodsList //所有商品
{
    NSMutableArray *list = [NSMutableArray array];
    NSArray<GoodsModel*> *goodsModelArray = [[GoodsManager sharedInstance] allGoodsList];
    NSInteger count = goodsModelArray.count;
    
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goodModel = goodsModelArray[i];
        NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
        goodDic[kGoodsModelParamGoodId] = goodModel.goodsId;
        goodDic[kGoodsModelParamGoodName] = goodModel.name;
        goodDic[kGoodsModelParamGoodPrice] = @(goodModel.price);
        goodDic[kGoodsModelParamGoodInventory] = @(goodModel.inventory);
        [list addObject:goodDic];
    }
    return list;
}

- (NSDictionary *)Action_goodsById:(nonnull NSDictionary*)params
{
    NSString *goodsId = params[kGoodsModelParamGoodId];
    GoodsModel *goodModel = [[GoodsManager sharedInstance] goodsById:goodsId];
    NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
    if(goodModel){
        goodDic[kGoodsModelParamGoodId] = goodsId;
        goodDic[kGoodsModelParamGoodName] = goodModel.name;
        goodDic[kGoodsModelParamGoodPrice] = @(goodModel.price);
        goodDic[kGoodsModelParamGoodInventory] = @(goodModel.inventory);
    }
   
    return goodDic;
}
@end
