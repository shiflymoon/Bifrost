//
//  SaleModuleService.h
//  Sale
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#ifndef SaleModuleService_h
#define SaleModuleService_h

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
UIKIT_EXTERN NSString *const kRouteSaleShoppingCart ;



#pragma mark - URL Service routers
UIKIT_EXTERN NSString *const kRouteSaleAddShoppingCartGoods ;
UIKIT_EXTERN NSString *const kRouteSaleAddShoppingCartGoodsParamGoodId ;
UIKIT_EXTERN NSString *const kRouteSaleShoppingCartGoodsNum ;


NS_ASSUME_NONNULL_END
#endif /* SaleModuleService_h */
