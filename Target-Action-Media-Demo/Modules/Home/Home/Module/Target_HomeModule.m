//
//  HomeModuleTarget.m
//  Home
//
//  Created by 史贵岭 on 2019/8/5.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "Target_HomeModule.h"
#import "HomeBundle.h"

@implementation Target_HomeModule
-(BOOL) Action_showHomeVC:(NSDictionary *) params
{
    UIApplication *application = params[@"application"];
    UIWindow *window = application.delegate.window;
    UIViewController *homeVC =  [[HomeBundle storyboardWithName:@"home"] instantiateViewControllerWithIdentifier:@"HomeViewController"];
    UINavigationController *rootNavContoller = [[UINavigationController alloc] initWithRootViewController:homeVC];
    rootNavContoller.navigationItem.backBarButtonItem.title = @"";
    window.rootViewController = rootNavContoller;
    [window makeKeyAndVisible];
    return YES;
}
@end
