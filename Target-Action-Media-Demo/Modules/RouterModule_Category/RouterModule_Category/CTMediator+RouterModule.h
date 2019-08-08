//
//  CTMediator+RouterModule.h
//  RouterModule_Category
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - GoodsModuleRouter
static NSString *const kRouteGoodModuleAllGoodsList = @"//goods/all_goods_list";
static NSString *const kRouteGoodModuleGoodsDetail = @"//goods/detail";
static NSString *const kRouteGoodModuleGoodsDetailParamId = @"id";

#pragma mark - SaleModuleRouter
static NSString *const kRouteSaleModuleShoppingCart = @"//sale/shopping_chart";

#pragma mark - ShopModuleRouter
static NSString *const kRouteShopModuleShopDetail = @"//shop/detail";

#pragma mark - service
//为了业务App安全应该尽量减少基于Router的调用，Router基于本地target-action提供服务
//所有涉及到Router调用建议汇总到此处，此类负责Router正则匹配，并选择合适的本地服务去转发
@interface CTMediator (RouterModule)

//complexParams可以放入block回调等，比如A页面跳转到B页面，且需要使用B页面返回数据，可以在A页面构造block放入参数中，在B页面取出
- (nullable id)routerModule_performActionWithUrl:(NSURL *)url complexParams:(nullable NSDictionary*)complexParams ;
@end

NS_ASSUME_NONNULL_END
