//
//  GoodsModel.h
//  Goods
//
//  Created by yangke on 2017/9/17.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsModel : NSObject

@property(nonatomic, strong) NSString *goodsId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) CGFloat price;
@property(nonatomic, assign) NSInteger inventory;

@end
