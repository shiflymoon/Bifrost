//
//  HomeModule.m
//  Home
//
//  Created by yangke on 2017/9/16.
//  Copyright © 2017年 jackie@youzan. All rights reserved.
//

#import "HomeModule.h"
#import "HomeViewController.h"
#import "HomeBundle.h"

@implementation HomeModule

+ (void)load {
    BFRegister(HomeModuleService);
    
    //HomeViewController
    [Bifrost bindURL:kRouteHomePage
           toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
               UIViewController *vc = [[HomeBundle storyboardWithName:@"home"] instantiateViewControllerWithIdentifier:@"HomeViewController"];
               return vc;
           }];
}

#pragma mark - BifrostModuleProtocol
+ (instancetype)sharedInstance {
    static HomeModule *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setup {
    
}

+ (NSUInteger)priority {
    return BifrostModuleDefaultPriority+100; //higher priority than other modules
}

+ (BOOL)setupModuleSynchronously {
    return YES;
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = application.delegate.window;
    /*不建议这么做
     模块内部能不依赖Bifrost的就不要依赖，除非是模块间的业务依赖不可避免。Module类可以访问模块内的任何类的
    UIViewController *homeVC = [Bifrost handleURL:kRouteHomePage];*/
    //推荐做法
    UIViewController *homeVC = [[HomeBundle storyboardWithName:@"home"] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    UINavigationController *rootNavContoller = [[UINavigationController alloc] initWithRootViewController:homeVC];
    rootNavContoller.navigationItem.backBarButtonItem.title = @"";
    window.rootViewController = rootNavContoller;
    [window makeKeyAndVisible];
    return YES;
}

#pragma mark - HomeModuleService


@end
