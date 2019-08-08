//
//  Target_ShopModule.m
//  Shop
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "Target_ShopModule.h"
#import "ShopBundle.h"
#import "ShopManager.h"
#import "ShopDetailViewController.h"

@implementation Target_ShopModule
- (void) Action_setup
{
     [[ShopManager sharedInstance] setup];
}

-(UIViewController *) Action_shopDetailViewController
{
    ShopDetailViewController *detailVC = [[ShopDetailViewController alloc] init];
    return detailVC;
}

- (NSString*)Action_shopName
{
      return @"零售特工队";
}

- (UIImage*)Action_shopLogo
{
     return [ShopBundle imageNamed:@"shop_logo"];
}

- (CGFloat)Action_shopRevenue
{
    return 666666.66;
}
@end
