//
//  GoodsManager.h
//  Goods
//
//  Created by yangke on 2019/3/5.
//  Copyright © 2019 jackie@youzan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsManager : NSObject

+ (instancetype)sharedInstance;
- (void)setup;

- (NSInteger)totalInventory ;

- (id<GoodsProtocol>)goodsById:(NSString*)goodsId;

- (nonnull NSArray<id<GoodsProtocol>> *)allGoodsList;

- (nonnull NSArray<id<GoodsProtocol>> *)popularGoodsList;

@end

NS_ASSUME_NONNULL_END
