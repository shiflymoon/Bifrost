//
//  TemplateBundle.m
//  TemplateModule
//
//  Created by __UserName__ on __YMD__.
//  Copyright (c) __Year__年 __UserName__. All rights reserved.
//

#import "TemplateBundle.h"

@implementation TemplateBundle

+ (NSBundle *)bundle{
    return [self.class bundleWithName:NSStringFromClass(self.class)];
}

@end
