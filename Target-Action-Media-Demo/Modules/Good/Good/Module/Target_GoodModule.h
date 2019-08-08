//
//  Target_GoodModule.h
//  Good
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_GoodModule : NSObject

- (UIViewController *)Action_goodsDetailViewController:(NSDictionary *) params;
- (UIViewController *)Action_goodsListViewController;
- (NSInteger)Action_totalInventory;

//商品的key值参见kGoodsModelParamGoodId & kGoodsModelParamGoodName & kGoodsModelParamGoodPrice & kGoodsModelParamGoodInventory
- (NSArray<NSDictionary *>*)Action_popularGoodsList; //热卖商品
- (NSArray<NSDictionary *>*)Action_allGoodsList; //所有商品
- (NSDictionary *)Action_goodsById:(nonnull NSDictionary*)params;
@end

NS_ASSUME_NONNULL_END
