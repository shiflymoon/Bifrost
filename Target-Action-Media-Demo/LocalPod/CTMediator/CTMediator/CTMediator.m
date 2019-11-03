//
//  CTMediator.m
//  CTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTMediator.h"
#import <objc/runtime.h>

NSString * const kCTMediatorParamsKeySwiftTargetModuleName = @"kCTMediatorParamsKeySwiftTargetModuleName";
NSString * const kCTMediatorCompletion = @"kCTMediatorCompletion";

@interface CTMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation CTMediator

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static CTMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[CTMediator alloc] init];
    });
    return mediator;
}

/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */

- (id)performActionWithUrl:(NSURL *)url complexParams:(nullable NSDictionary*)complexParams completion:(CTMediatorCompletion)completion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    if([complexParams isKindOfClass:[NSDictionary class]] && complexParams.count){
        [params setValuesForKeysWithDictionary:complexParams];
    }
    
    if(completion) {
        [params setObject:completion forKey:kCTMediatorCompletion];
    }
    
    // 这里这么写主要是出于安全考虑，防止黑客通过远程方式调用本地模块。这里的做法足以应对绝大多数场景，如果要求更加严苛，也可以做更加复杂的安全逻辑。
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {//如果有些业务类禁止远程调用，采用action前加native约束
        return @(NO);
    }
    
    // 这个demo针对URL的路由处理非常简单，就只是取对应的target名字和method名字，但这已经足以应对绝大部份需求。如果需要拓展，可以在这个方法调用之前加入完整的路由逻辑
    id result = [self performTarget:url.host action:actionName params:params shouldCacheTarget:NO];
   
    return result;

}
- (id)performActionWithUrl:(NSURL *)url completion:(CTMediatorCompletion)completion
{
    return [self performActionWithUrl:url complexParams:nil completion:completion];
}
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget
{
    NSString *swiftModuleName = params[kCTMediatorParamsKeySwiftTargetModuleName];
    
    // generate target
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0) {
        targetClassString = [NSString stringWithFormat:@"%@.Target_%@", swiftModuleName, targetName];
    } else {
        targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    }
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }

    // generate action
    NSString *actionString = [NSString stringWithFormat:@"Action_%@", actionName];
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        // 这里是处理无响应请求的地方之一，这个demo做得比较简单，如果没有可以响应的target，就直接return了。实际开发过程中是可以事先给一个固定的target专门用于在这个时候顶上，然后处理这种请求的
        [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
        return nil;
    }
    
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }

    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
    } else {
        // 这里是处理无响应请求的地方，如果无响应，则尝试调用对应target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            return [self safePerformAction:action target:target params:params];
        } else {
            // 这里也是处理无响应请求的地方，在notFound都没有的时候，这个demo是直接return了。实际开发过程中，可以用前面提到的固定的target顶上的。
            [self NoTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:params];
            [self.cachedTarget removeObjectForKey:targetClassString];
            return nil;
        }
    }
}

- (void)releaseCachedTargetWithTargetName:(NSString *)targetName
{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

- (void)completeWithParameters:(nullable NSDictionary*)params result:(_Nullable id)result {
    CTMediatorCompletion completion = params[kCTMediatorCompletion];
    if (completion) {
        completion(result);
    }
}

#pragma mark - private methods
- (void)NoTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams
{
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"originParams"] = originParams;
    params[@"targetString"] = targetString;
    params[@"selectorString"] = selectorString;
    
    [self safePerformAction:action target:target params:params];
}

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params
{
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(methodSig == nil) {
        return nil;
    }
    const char* retType = [methodSig methodReturnType];

    NSInteger paramIndex = 1;
    if([NSStringFromSelector(action) hasSuffix:@":"]){
        paramIndex = 2;
    }
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }

    if (strcmp(retType, @encode(long)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        long result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(int)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        int result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(double)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        double result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(float)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        float result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(unsigned long)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        unsigned long result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(unsigned int)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        unsigned int result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(char)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        char result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(unsigned char)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        unsigned char result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(short)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        short result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(unsigned short)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        unsigned short result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(long long)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        long long result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

    if (strcmp(retType, @encode(unsigned long long )) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        if(paramIndex == 2){
            [invocation setArgument:&params atIndex:2];
        }
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        unsigned long long  result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - getters and setters
- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

@end
