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
#import "BifrostHeader.h"

 NSString *const kRouteAllGoodsList = @"//goods/all_goods_list";
 NSString *const kRouteGoodsDetail = @"//goods/detail";
 NSString *const kRouteGoodsDetailParamId = @"id";

 NSString *const kRouteGoodsModelParamKeyGoodsId = @"goodsId" ;
 NSString *const kRouteGoodsModelParamKeyGoodsName = @"name" ;
 NSString *const kRouteGoodsModelParamKeyGoodsPrice = @"price" ;
 NSString *const kRouteGoodsModelParamKeyGoodsInventory = @"inventory";


 NSString *const kRouteGoodsServicetoTalInventory = @"//goods/tal_inventory";
 NSString *const kRouteGoodsServicetoPopularGoodsList = @"//goods/popular_goodslist";
 NSString *const kRouteGoodsServiceAllGoodsList = @"//goods/all_goodslist";
 NSString *const kRouteGoodsServiceGoodsById = @"//goods/goodsbyid";
@implementation GoodsModule

+ (void)load {
    
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
    
    
    [Bifrost bindURL:kRouteGoodsServicetoTalInventory toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
         return @([[GoodsManager sharedInstance] totalInventory]);
    }];
    
    [Bifrost bindURL:kRouteGoodsServicetoPopularGoodsList toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        return [self popularGoodsList];
    }];
    
    [Bifrost bindURL:kRouteGoodsServiceAllGoodsList toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        return [self allGoodsList];
    }];
    
    [Bifrost bindURL:kRouteGoodsServiceGoodsById toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
        NSString *goodsId = parameters[kRouteGoodsModelParamKeyGoodsId];
        GoodsModel *goodModel = [[GoodsManager sharedInstance] goodsById:goodsId];
        NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
        if(goodModel){
            goodDic[kRouteGoodsModelParamKeyGoodsId] = goodsId;
            goodDic[kRouteGoodsModelParamKeyGoodsName] = goodModel.name;
            goodDic[kRouteGoodsModelParamKeyGoodsPrice] = @(goodModel.price);
            goodDic[kRouteGoodsModelParamKeyGoodsInventory] = @(goodModel.inventory);
        }
        
        return goodDic;
    }];
}

#pragma mark - private
+(NSArray<NSDictionary *> *)popularGoodsList
{
    NSMutableArray *list = [NSMutableArray array];
    NSArray<GoodsModel*> *goodsModelArray = [[GoodsManager sharedInstance] popularGoodsList];
    NSInteger count = goodsModelArray.count;
    
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goodModel = goodsModelArray[i];
        NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
        goodDic[kRouteGoodsModelParamKeyGoodsId] = goodModel.goodsId;
        goodDic[kRouteGoodsModelParamKeyGoodsName] = goodModel.name;
        goodDic[kRouteGoodsModelParamKeyGoodsPrice] = @(goodModel.price);
        goodDic[kRouteGoodsModelParamKeyGoodsInventory] = @(goodModel.inventory);
        [list addObject:goodDic];
    }
    return list;
}


+(NSArray<NSDictionary *> *)allGoodsList
{
    NSMutableArray *list = [NSMutableArray array];
    NSArray<GoodsModel*> *goodsModelArray = [[GoodsManager sharedInstance] allGoodsList];
    NSInteger count = goodsModelArray.count;
    
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goodModel = goodsModelArray[i];
        NSMutableDictionary *goodDic = [NSMutableDictionary dictionary];
        goodDic[kRouteGoodsModelParamKeyGoodsId] = goodModel.goodsId;
        goodDic[kRouteGoodsModelParamKeyGoodsName] = goodModel.name;
        goodDic[kRouteGoodsModelParamKeyGoodsPrice] = @(goodModel.price);
        goodDic[kRouteGoodsModelParamKeyGoodsInventory] = @(goodModel.inventory);
        [list addObject:goodDic];
    }
    return list;
}


@end
