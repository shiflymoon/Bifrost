//
//  CTMediator+SaleModule.h
//  SaleModule_Category
//
//  Created by 史贵岭 on 2019/8/6.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CTMediator (SaleModule)
- (void)saleModule_addGoods:(NSString*)goodsId withNum:(NSUInteger)num ;

- (void)saleModule_addShoppingCartGoods:(NSString*)goodsId;

- (NSUInteger)saleModule_shoppinCartGoodsNum;

- (UIViewController *) saleModule_saleShoppingCartViewController;
@end

NS_ASSUME_NONNULL_END
