//
//  AppDelegate.m
//  Bifrost
//
//  Created by yangke on 2017/3/8.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "AppDelegate.h"
#import "CTMediator+HomeModule.h"
#import "CTMediator+RouterModule.h"

@interface AppDelegate ()
    
@end

@implementation AppDelegate


-(void) routerTest
{
    //常规router测试
    static NSString *const kRouteAllGoodsList = @"//goods/all_goods_list";
    static NSString *const kRouteGoodsDetail = @"//goods/detail?id=1";
    static NSString *const kRouteSaleShoppingCart = @"//sale/shopping_chart";
    static NSString *const kRouteShopDetail = @"//shop/detail";
    
    id goodsList = [[CTMediator sharedInstance] routerModule_performActionWithUrl:[NSURL URLWithString:kRouteAllGoodsList] complexParams:nil];
    id goodDetail = [[CTMediator sharedInstance] routerModule_performActionWithUrl:[NSURL URLWithString:kRouteGoodsDetail] complexParams:nil];
    id shopCart = [[CTMediator sharedInstance] routerModule_performActionWithUrl:[NSURL URLWithString:kRouteSaleShoppingCart] complexParams:nil];
    id shopDetail = [[CTMediator sharedInstance] routerModule_performActionWithUrl:[NSURL URLWithString:kRouteShopDetail] complexParams:nil];
    
    
    //基于target-action router测试
    static NSString *const kRouteTAAllGoodsList = @"//GoodModule/goodsListViewController";
    static NSString *const kRouteTAGoodsDetail = @"//GoodModule/goodsDetailViewController:?id=1";
    static NSString *const kRouteTASaleShoppingCart = @"//SaleModule/saleShoppingCartViewController";
    static NSString *const kRouteTAShopDetail = @"//ShopModule/shopDetailViewController";
    goodDetail = [[CTMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:kRouteTAGoodsDetail] completion:nil];
}
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self routerTest];
    });
    
    
    return YES;
}
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   return  [[CTMediator sharedInstance] homeModule_showHomeVCWithApplication:application];;
}
    
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}
    
- (void)applicationDidEnterBackground:(UIApplication *)application{
  
}
    
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
    
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return YES;
}
    
#pragma mark - delegate
    
#pragma mark - Push Remote Notification
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
   
}
    
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
   
}
    
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
}
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   
}
    
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}
    
    @end
