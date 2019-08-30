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
#import "BifrostHeader.h"

NSString *const kRouteHomePage = @"//home/home_page";
@implementation HomeModule

+ (void)load {
    
    //HomeViewController
    [Bifrost bindURL:kRouteHomePage
           toHandler:^id _Nullable(NSDictionary * _Nullable parameters) {
               UIViewController *vc = [[HomeBundle storyboardWithName:@"home"] instantiateViewControllerWithIdentifier:@"HomeViewController"];
               return vc;
           }];
}



@end
