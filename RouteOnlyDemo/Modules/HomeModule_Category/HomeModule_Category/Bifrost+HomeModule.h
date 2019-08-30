//
//  Bifrost+HomeModule.h
//  HomeModule_Category
//
//  Created by 史贵岭 on 2019/8/9.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "Bifrost.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Notifications
static NSNotificationName kNotificationHomePageDidAppear = @"kNotificationHomePageDidAppear";

#pragma mark - URL routers
static NSString *const kRouteHomeModuleHomePage = @"//home/home_page";

@interface Bifrost (HomeModule)

@end

NS_ASSUME_NONNULL_END
