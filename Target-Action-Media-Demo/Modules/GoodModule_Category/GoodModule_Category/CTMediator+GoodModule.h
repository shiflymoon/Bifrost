//
//  CTMediator+GoodModule.h
//  GoodModule_Category
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Goods Model Dic key
//对于需要传递到B模块的模型建议通过键值对传送
UIKIT_EXTERN NSString *const kGoodsModelParamGoodId ;//value为NSString
UIKIT_EXTERN NSString *const kGoodsModelParamGoodName ;//value为NSString
UIKIT_EXTERN NSString *const kGoodsModelParamGoodPrice ;//value为NSNumber
UIKIT_EXTERN NSString *const kGoodsModelParamGoodInventory ;//value为NSNumber

#pragma mark - Goods service
@interface CTMediator (GoodModule)

- (UIViewController *)goodModule_goodsDetailViewController:(NSString *) goodId;
- (UIViewController *)goodModule_goodsListViewController;
- (NSInteger)goodModule_totalInventory;

//商品的key值参见kGoodsModelParamGoodId & kGoodsModelParamGoodName & kGoodsModelParamGoodPrice & kGoodsModelParamGoodInventory
- (NSArray<NSDictionary *>*)goodModule_popularGoodsList; //热卖商品
- (NSArray<NSDictionary *>*)goodModule_allGoodsList; //所有商品
- (NSDictionary *)goodModule_goodsById:(nonnull NSString*)goodsId;
@end

NS_ASSUME_NONNULL_END
