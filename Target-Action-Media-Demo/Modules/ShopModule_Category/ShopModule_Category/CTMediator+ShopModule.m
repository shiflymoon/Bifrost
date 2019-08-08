//
//  ShopModule_Category.m
//  ShopModule_Category
//
//  Created by 史贵岭 on 2019/8/7.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator+ShopModule.h"
NSString * const ShopModuleTarget = @"ShopModule";
@implementation CTMediator (ShopModule)

+(void) load
{
    [[CTMediator sharedInstance] performTarget:ShopModuleTarget action:@"setup" params:nil shouldCacheTarget:NO];
}

- (UIViewController *) shopModule_shopDetailViewController
{
    return [self performTarget:ShopModuleTarget action:@"shopDetailViewController" params:nil shouldCacheTarget:NO];
}

- (NSString*) shopModule_shopName
{
    return [self performTarget:ShopModuleTarget action:@"shopName" params:nil shouldCacheTarget:NO];
}
- (UIImage*) shopModule_shopLogo
{
    return [self performTarget:ShopModuleTarget action:@"shopLogo" params:nil shouldCacheTarget:NO];
}
- (CGFloat)  shopModule_shopRevenue
{
    
    return (CGFloat)[[self performTarget:ShopModuleTarget action:@"shopRevenue" params:nil shouldCacheTarget:NO] doubleValue];
}
@end
