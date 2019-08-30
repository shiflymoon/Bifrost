//
//  GoodService.h
//  TestSwiftControl
//
//  Created by 史贵岭 on 2019/8/20.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodService : NSObject
-(UIViewController *)goodsDetailViewController:(nullable NSString *) goodId;
- (UIViewController *)goodsListViewController;
- (NSInteger)totalInventory;
- (NSInteger)totalInventoryTest:(NSInteger)sex;
- (nullable id) goodsParam:(NSDictionary*) param name:(NSDictionary<NSString *,NSString *> *) name;
+ (null_unspecified NSArray < NSDictionary * > * ) application:(null_unspecified NSArray < NSDictionary * > *)application didFinishLaunchingWithOptions:(NSArray <id> *)didlaunchOptions  willFinishLaunchingWithOptions:(NSDictionary<NSString *,NSString *> *)willlaunchOptions ;

//商品的key值参见kGoodsModelParamGoodId & kGoodsModelParamGoodName & kGoodsModelParamGoodPrice & kGoodsModelParamGoodInventory
- (NSArray<NSDictionary *>*)popularGoodsList; //热卖商品
- (NSArray<NSDictionary *>*)allGoodsList; //所有商品
- (NSDictionary *)goodsById:(nonnull NSString*)goodsId;
@end

NS_ASSUME_NONNULL_END
