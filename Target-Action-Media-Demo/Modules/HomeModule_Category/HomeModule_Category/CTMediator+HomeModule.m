//
//  CTMediator+HomeModule.m
//  HomeModule_Category
//
//  Created by 史贵岭 on 2019/8/5.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "CTMediator+HomeModule.h"


@implementation CTMediator (HomeModule)
-(BOOL) homeModule_showHomeVCWithApplication:(UIApplication *)application
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"application"] = application;
    return  [self performTarget:@"HomeModule" action:@"showHomeVC:" params:params shouldCacheTarget:NO];
}
@end
