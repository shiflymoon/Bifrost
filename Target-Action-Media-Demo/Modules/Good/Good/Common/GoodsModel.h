//
//  GoodsModel.h
//  Good
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsModel : NSObject
@property (nonatomic, strong) NSString * goodsId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, assign) CGFloat price;
@property(nonatomic, assign) NSInteger inventory;
@end

NS_ASSUME_NONNULL_END


