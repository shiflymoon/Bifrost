//
//  ShopModule_Category.h
//  ShopModule_Category
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator.h"

@interface CTMediator (ShopModule)
- (UIViewController *) shopModule_shopDetailViewController;
- (NSString*) shopModule_shopName;
- (UIImage*) shopModule_shopLogo;
- (CGFloat)  shopModule_shopRevenue;
@end
