//
//  Target_SaleModule.h
//  Sale
//
//  Created by 史贵岭 on 2019/8/6.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_SaleModule : NSObject
- (void) Action_setUp;

- (void)Action_addGoodsAndNum:(NSDictionary *)params;// kSaleModuleShoppingCartParamGoodId & 

- (void)Action_addShoppingCartGoods:(NSDictionary*)params;
- (NSUInteger)Action_shoppinCartGoodsNum ;

- (UIViewController *) Action_saleShoppingCartViewController;
@end

NS_ASSUME_NONNULL_END
