//
//  Target_NoTargetAction.m
//  Common
//
//  Created by 史贵岭 on 2019/8/5.
//  Copyright © 2019年 史贵岭. All rights reserved.
//

#import "Target_NoTargetAction.h"

@implementation Target_NoTargetAction
-(void) Action_response:(NSDictionary *) params
{
   NSString *originParams = params[@"originParams"] ;
   NSString *targetString = params[@"targetString"] ;
   NSString *selectorString = params[@"selectorString"] ;
   NSLog(@"originParams=%@,targetString=%@,selectorString=%@",originParams,targetString,selectorString);

    NSExceptionName name = @"CTMediaExceptionName";
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setValue:@"CTExceptionFailedToFindModuleByTargetAction" forKey:@"99999"];
    NSString *expStr = [NSString stringWithFormat:@"originParams=%@,targetString=%@,selectorString=%@",originParams,targetString,selectorString];
    [userInfo setValue:expStr forKey:@"CTExceptionServiceProtocolStr"];
    NSException *ex = [[NSException alloc] initWithName:name
                                                 reason:@"TargetActionNotFound"
                                               userInfo:userInfo];
    @throw ex;
}
@end
