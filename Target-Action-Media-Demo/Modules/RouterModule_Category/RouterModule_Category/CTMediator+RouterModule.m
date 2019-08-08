//
//  CTMediator+RouterModule.m
//  RouterModule_Category
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator+RouterModule.h"
#import "CTMediator+ShopModule.h"
#import "CTMediator+GoodModule.h"
#import "CTMediator+SaleModule.h"

@implementation CTMediator (RouterModule)

- (nullable id)routerModule_performActionWithUrl:(NSURL *)url complexParams:(nullable NSDictionary*)complexParams 
{
    if(!url){
        return nil;
    }
    NSString *urlHost = [url host];
    NSString *urlPath = [url path];
    if(!urlHost || !urlPath){
        return nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    if([complexParams isKindOfClass:[NSDictionary class]] && complexParams.count){
        [params setValuesForKeysWithDictionary:complexParams];
    }
    
    
    return [self matchHost:urlHost path:urlPath withParams:params];
}

#pragma mark - private Router Choose
-(nullable id)matchHost:(NSString *) urlHost path:(NSString *) urlPath withParams:(NSDictionary *) params
{
  
  NSString *regrexRouter = [NSString stringWithFormat:@"//%@%@",urlHost,urlPath];
  if([urlHost isEqualToString:@"goods"]){// goods模块
      return [self goodModuleRoute:regrexRouter withParams:params];
  }else if([urlHost isEqualToString:@"sale"]){//sale模块
      return [self saleModuleRoute:regrexRouter withParams:params];
  }else if([urlHost isEqualToString:@"shop"]){//shop模块
      return [self shopModuleRoute:regrexRouter withParams:params];
  }
    
    return nil;
}

#pragma  mark - goodModuleRoute
-(nullable id) goodModuleRoute:(NSString *) regrexRoute withParams:(NSDictionary *) params
{
    if([regrexRoute isEqualToString:kRouteGoodModuleAllGoodsList]){
        /* 不推荐这种做法，这种做法一定程度上分散了hardcode，不好维护，尽量让hardcode集中在各个模块的category中
        return [self performTarget:@"GoodModule" action:@"goodsListViewController" params:params shouldCacheTarget:NO];*/
        //推荐做法
       return [self goodModule_goodsListViewController];
    }else if([regrexRoute isEqualToString:kRouteGoodModuleGoodsDetail]){
        NSString *goodId = params[kRouteGoodModuleGoodsDetailParamId];
        return [self goodModule_goodsDetailViewController:goodId];
    }
    return nil;
}

#pragma mark - saleModuleRoute
-(nullable id) saleModuleRoute:(NSString *) regrexRoute withParams:(NSDictionary *) params
{
    if([regrexRoute isEqualToString:kRouteSaleModuleShoppingCart]){
        return [self saleModule_saleShoppingCartViewController];
    }
    return nil;
}

#pragma mark - shopModuleRoute
-(nullable id) shopModuleRoute:(NSString *) regrexRoute withParams:(NSDictionary *) params
{
    if([regrexRoute isEqualToString:kRouteShopModuleShopDetail]){
        return [self shopModule_shopDetailViewController];
    }
    return nil;
}
@end
