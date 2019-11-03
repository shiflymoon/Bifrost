//
//  AppDelegate.m
//  Bifrost
//
//  Created by yangke on 2017/3/8.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeModuleService.h"
#import "Bifrost+Router.h"
#import <UIKit/UIKit.h>

#define Safe(obj) obj ? obj : [NSNull null]

@interface AppDelegate ()
    
@end

@implementation AppDelegate


-(void) regexTest
{
    /*
    NSString *path =  @"/Users/shiguiling063/Desktop/testPro/TestSwiftControl/TestSwiftControl/SaleModuleOut/Sale/Sale/Module/Target_TemplateModule.h";//Target_SaleModule.h
    NSData *data =  [[NSFileManager defaultManager] contentsAtPath:path];//Target_SaleModule.h

    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    long long location = 0 ;
     NSString *addStr = @"$GoodStart\n";
    NSString *ap =  @"@interface GoodsModel : NSObject\n@property (nonatomic, strong) NSString * goodsId;\n\n @property(nonatomic, strong) NSString *name;\n @property(nonatomic, assign) CGFloat price;\n @property(nonatomic, assign) NSInteger inventory;\n@end\n";
    
    for (int i =0;i<100;i++){
        addStr = [NSString stringWithFormat:@"%@%@",addStr,ap];
    }

    NSRange range = [str rangeOfString:@"NS_ASSUME_NONNULL_BEGIN"];
    if(range.location != NSNotFound){
        location = range.location;
        NSString *preFix = [str substringToIndex:location+range.length];
       
        NSString *sufix = [str substringFromIndex:range.location + range.length];
        NSString *fStr = [NSString stringWithFormat:@"%@%@%@",preFix,addStr,sufix];
        NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:path];
        [handle seekToFileOffset:0];
        [handle writeData:[fStr dataUsingEncoding:NSUTF8StringEncoding]];
        [handle synchronizeFile];
        [handle closeFile];
    }*/
    
   
    
     
    
   // NSString *testSource = @"   + (  null_unspecified NSArray < NSDictionary * > *   ) application:(null_unspecified NSArray < NSDictionary * > *)application didFinishLaunchingWithOptions:(NSArray < id> *)launchOptions  willFinishLaunchingWithOptions:(NSDictionary<NSString *,NSString *> *)launchOptions ;";
  //  NSString *testSource = @"   + (BOOL)application:(UIApplication *)application  ;";
   //  NSString *testSource = @"   + (BOOL) application ;";
 // NSString *testSource = @"+ (null_unspecified NSArray < NSDictionary * > * ) application:(null_unspecified NSArray < NSDictionary * > *)application didFinishLaunchingWithOptions:(NSArray <id> *)didlaunchOptions  willFinishLaunchingWithOptions:(NSDictionary<NSString *,NSString *> *)willlaunchOptions ;"
 
   // NSString *testSource =  @"( nullable NSDictionary<NSString *,NSString *> *)willlaunchOptions";
   // NSString *eStr = @"NS[a-zA-Z<>\\*\\s,_]+\\*";
    //
   // NSString * eStr = @"@interface([a-zA-Z_0-9\\s]+):[a-zA-Z_0-9\\s]+(@property[a-zA-Z,0-9\\s\\*\\(\\)]+;\\s*)+@end";
  //  NSString *eStr = @"@property\\s*\\([a-zA-Z,0-9_\\s]+\\)\\s*([a-zA-Z0-9_]+\\s*\\*?)\\s*([a-zA-Z0-9_]+)\\s*;";
   // NSString *testSource = @"@interface GoodsModel : NSObject\r@property (nonatomic, strong) NSString * goodsId;\r @property(nonatomic, strong) NSString *name;\r @property(nonatomic, assign) CGFloat price;\r @property(nonatomic, assign) NSInteger inventory;\r@end";
  
    NSString * eStr = @"<a>(.*)?</a>";
    NSString * testSource = @"<a> href = \"a\"</a>good<a>";
    //NSString *eStr = @"[\\+|-]\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\)";//找到返回值Prefix
   // NSString *eStr = @"\\s*([a-zA-Z]+):(\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\))\\s*([a-zA-Z]+)";//找到三个参数
   // NSString *eStr = @"[\\+|-]\\s*\\(\\s*([a-zA-Z<>\\s\\*_,]+\\s*\\*?)\\s*\\)";//找到了返回类型
    
  //  NSString *eStr = @"[\\+|-]\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\)(\\s*[a-zA-Z]+:\\s*\\(\\s*[a-zA-Z<>\\s\\*_,]+\\s*\\*?\\s*\\)\\s*[a-zA-Z]+)+\\s*;";//找到带参数匹配，再需要继续子查询

    
  //  NSString *eStr = @"[\\+|-]\\s*\\(\\s*([a-zA-Z<>\\s\\*_,]+\\s*\\*?)\\s*\\)\\s*[a-zA-Z]+\\s*;";//没有参数返回
    NSError *error = nil;
    
    
    
    NSRegularExpression * express = [NSRegularExpression regularExpressionWithPattern:eStr options:NSRegularExpressionDotMatchesLineSeparators error:&error];
    /*
    [express enumerateMatchesInString:testSource options:NSMatchingReportProgress range:NSMakeRange(0, testSource.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        for(int i = 0 ;i<result.numberOfRanges;i++){
            NSLog(@"%@,%@",NSStringFromRange([result rangeAtIndex:i]),[testSource substringWithRange:[result rangeAtIndex:i]]);
        }
    }];*/
    NSArray<NSTextCheckingResult *> * resultArray = [express matchesInString:testSource options:0 range:NSMakeRange(0, testSource.length)];
    for(NSTextCheckingResult * result in resultArray){
        //NSLog(@"%@,%ld",NSStringFromRange(result.range),result.numberOfRanges);
        for(int i = 0 ;i<result.numberOfRanges;i++){
             NSLog(@"%@,%@",NSStringFromRange([result rangeAtIndex:i]),[testSource substringWithRange:[result rangeAtIndex:i]]);
        }
       // NSLog(@"%@",[testSource substringWithRange:result.range]);
    }
}
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self regexTest];
    UIViewController *homeVC = [Bifrost handleURL:kRouteHomePage];
    UINavigationController *rootNavContoller = [[UINavigationController alloc] initWithRootViewController:homeVC];
    rootNavContoller.navigationItem.backBarButtonItem.title = @"";
    self.window.rootViewController = rootNavContoller;
    [self.window makeKeyAndVisible];
    return YES;
}
    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
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
