//
//  GoodsModuleService.h
//  Goods
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#ifndef GoodsModuleService_h
#define GoodsModuleService_h

///<v1.0>
/**
 service protocol头文件版本号基于Semantic Versioning
 x(major).y(minor)
 major - 公共API改动或者删减
 minor - 新添加了公共API
 小于1.0的版本（如0.6），视为未稳定版本，不做上述限制。
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Notifications
//static NSNotificationName kNotification*** = @"kNotification***";

#pragma mark - URL ViewController routers
UIKIT_EXTERN NSString *const kRouteAllGoodsList ;
UIKIT_EXTERN NSString *const kRouteGoodsDetail ;
UIKIT_EXTERN NSString *const kRouteGoodsDetailParamId ;

#pragma mark -  Model Key
UIKIT_EXTERN NSString *const kRouteGoodsModelParamKeyGoodsId ;
UIKIT_EXTERN NSString *const kRouteGoodsModelParamKeyGoodsName ;
UIKIT_EXTERN NSString *const kRouteGoodsModelParamKeyGoodsPrice ;
UIKIT_EXTERN NSString *const kRouteGoodsModelParamKeyGoodsInventory;


#pragma mark - URL Module Service
/**
 The services provided by goods module to other modules
 */
UIKIT_EXTERN NSString *const kRouteGoodsServicetoTalInventory ;
UIKIT_EXTERN NSString *const kRouteGoodsServicetoPopularGoodsList ;
UIKIT_EXTERN NSString *const kRouteGoodsServiceAllGoodsList;
UIKIT_EXTERN NSString *const kRouteGoodsServiceGoodsById ;

NS_ASSUME_NONNULL_END

#endif /* GoodsModuleService_h */
