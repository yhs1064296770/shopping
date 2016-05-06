//
//  YhsCommon.m
//  YhsShopping
//
//  Created by 姚海深 on 16/5/6.
//  Copyright © 2016年 姚海深. All rights reserved.
//

#import "YhsCommon.h"
#include <objc/runtime.h>

@implementation YhsCommon

+ (NSArray *)findAllOf:(Class)defaultClass

{
    
    int count = objc_getClassList(NULL, 0);
    
    if (count <= 0)
        
    {
        
        @throw@"Couldn't retrieve Obj-C class-list";
        
        return nil;
        
    }
    
    
    
    NSMutableArray *output = [NSMutableArray array];
    
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    
    objc_getClassList(classes, count);
    
    for (int i = 0; i < count; ++i) {
        
        if (defaultClass == class_getSuperclass(classes[i]))//子类
            
        {
            
            [output addObject:[NSString stringWithUTF8String:object_getClassName(classes[i])]];
            
        }
        
    }
    
    free(classes);
    
    return [NSArray arrayWithArray:[output sortedArrayUsingSelector:@selector(compare:)]];
    
}



@end
