//
//  GoodsManager.m
//  Goods
//
//  Created by yangke on 2019/3/5.
//  Copyright © 2019 jackie@youzan. All rights reserved.
//

#import "GoodsManager.h"
#import "HomeModuleService.h"

@implementation GoodsManager

+ (instancetype)sharedInstance {
    static GoodsManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setup {
    //observe Home Page Did Appear event to preload data
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateGoodsData)
                                                 name:kNotificationHomePageDidAppear
                                               object:nil];
}

- (void)updateGoodsData {
    NSLog(@"Start to update goods data...");
}

- (NSInteger)totalInventory {
    NSArray *list = [self allGoodsList];
    NSInteger count = 0;
    for (GoodsModel *goods in list) {
        count += goods.inventory;
    }
    return count;
}

- (GoodsModel *)goodsById:(NSString*)goodsId {
    GoodsModel *goods = [[GoodsModel alloc] init];
    goods.goodsId = goodsId;
    goods.name = [NSString stringWithFormat:@"GoodsName_%@", goodsId];
    goods.price = [goodsId integerValue];
    goods.inventory = 66;
    return goods;
}

- (nonnull NSArray<GoodsModel *> *)allGoodsList {
    NSMutableArray *list = [NSMutableArray array];
    NSInteger count = 20;
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goods = [[GoodsModel alloc] init];
        goods.goodsId = [NSString stringWithFormat:@"%ld", (long)i];
        goods.name = [NSString stringWithFormat:@"GoodsName_%ld", (long)i];
        goods.price = i;
        goods.inventory = 66*i;
        [list addObject:goods];
    }
    return list;
}


- (nonnull NSArray<GoodsModel *> *)popularGoodsList {
    NSMutableArray *list = [NSMutableArray array];
    NSInteger count = 10;
    for (NSInteger i=1; i<count; i++) {
        GoodsModel *goods = [[GoodsModel alloc] init];
        goods.goodsId = [NSString stringWithFormat:@"%ld", (long)i];
        goods.name = [NSString stringWithFormat:@"GoodsName_%ld", (long)i];
        goods.price = i;
        goods.inventory = 66*i;
        [list addObject:goods];
    }
    return list;
}


@end
