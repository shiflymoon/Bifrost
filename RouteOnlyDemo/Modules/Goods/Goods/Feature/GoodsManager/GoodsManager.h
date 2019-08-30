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

- (GoodsModel *)goodsById:(NSString*)goodsId;

- (nonnull NSArray<GoodsModel *> *)allGoodsList;

- (nonnull NSArray<GoodsModel *> *)popularGoodsList;

@end

NS_ASSUME_NONNULL_END
