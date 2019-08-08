//
//  CTMediator+HomeModule.h
//  HomeModule_Category
//
//  Created by 史贵岭 on 2019/8/5.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Notifications
UIKIT_EXTERN NSNotificationName const kNotificationHomePageDidAppear;

#pragma mark 
@interface CTMediator (HomeModule)
-(BOOL) homeModule_showHomeVCWithApplication:(UIApplication *)application;
@end

NS_ASSUME_NONNULL_END
