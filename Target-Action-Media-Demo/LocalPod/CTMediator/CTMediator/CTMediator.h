//
//  CTMediator.h
//  CTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kCTMediatorParamsKeySwiftTargetModuleName;
extern NSString * _Nonnull const kCTMediatorCompletion; //the key for the completion block.

typedef void (^CTMediatorCompletion)(_Nullable id result);

@interface CTMediator : NSObject

+ (instancetype)sharedInstance;

// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(CTMediatorCompletion)completion;
- (id)performActionWithUrl:(NSURL *)url complexParams:(nullable NSDictionary*)complexParams completion:(CTMediatorCompletion)completion;
// 本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

//一般用来跳转到某页面，筛选数据后，关闭页面的同时，要把数据带出到跳转页面
//一般需要和performActionWithUrl:(NSURL *)url complexParams:(nullable NSDictionary*)complexParams completion:(CTMediatorCompletion)completion
//以及kCTMediatorCompletion配合使用
- (void)completeWithParameters:(nullable NSDictionary*)params result:(_Nullable id)result;
@end
