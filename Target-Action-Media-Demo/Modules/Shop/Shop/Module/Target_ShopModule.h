//
//  Target_ShopModule.h
//  Shop
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_ShopModule : NSObject

- (void) Action_setup;
- (UIViewController *) Action_shopDetailViewController;
- (NSString*) Action_shopName;
- (UIImage*) Action_shopLogo;
- (CGFloat) Action_shopRevenue;
@end

NS_ASSUME_NONNULL_END
