//
//  MAErrorReportingObject.m
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import "MAErrorReportingObject.h"

#import <objc/message.h>
#import <objc/runtime.h>

#import "MAErrorReportingArray.h"
#import "MAErrorReportingDictionary.h"
#import "NSObject+MAErrorReporting.h"


@implementation MAErrorReportingObject {
    id _parent;
    NSMutableArray *_errors;
}

static NSDictionary *gSubclassesMap;

+ (void)initialize
{
    if(self != [MAErrorReportingObject class])
        return;
    
    @autoreleasepool
    {
        CFMutableSetRef whitelist = CFSetCreateMutable(NULL, 0, NULL);
        CFSetAddValue(whitelist, sel_getUid("retain"));
        CFSetAddValue(whitelist, sel_getUid("release"));
        CFSetAddValue(whitelist, sel_getUid("autorelease"));
        CFSetAddValue(whitelist, sel_getUid("dealloc"));
        
        Method *methods = class_copyMethodList([NSProxy class], NULL);
        for(Method *cursor = methods; *cursor; cursor++)
        {
            SEL sel = method_getName(*cursor);
            if(CFSetContainsValue(whitelist, sel))
                continue;
            
            NSLog(@"Clearing %s", sel_getName(sel));
            class_addMethod(self, sel, _objc_msgForward, method_getTypeEncoding(*cursor));
        }
        free(methods);
        CFRelease(whitelist);
        
        CFMutableSetRef clusterClasses = CFSetCreateMutable(NULL, 0, NULL);
        CFSetAddValue(clusterClasses, (__bridge void *)[NSString class]);
        CFSetAddValue(clusterClasses, (__bridge void *)[NSNumber class]);
        CFSetAddValue(clusterClasses, (__bridge void *)[NSData class]);
        CFSetAddValue(clusterClasses, (__bridge void *)[NSDate class]);
        
        NSMutableDictionary *map = [NSMutableDictionary dictionary];
        
        Class *classes = objc_copyClassList(NULL);
        for(Class *cursor = classes; *cursor; cursor++)
        {
            Class class = *cursor;
            while(class)
            {
                if(CFSetContainsValue(clusterClasses, (__bridge void *)class))
                {
                    map[(id<NSCopying>)*cursor] = class;
                    break;
                }
                class = class_getSuperclass(class);
            }
        }
        free(classes);
        CFRelease(clusterClasses);
        
        gSubclassesMap = [map copy];
    }
}

+ (id)wrapObject: (id)object parent: (id)parent key: (id)key
{
    if([object isKindOfClass: [NSArray class]])
        return [[MAErrorReportingArray alloc] initWithParent: parent array: object key: key];
    if([object isKindOfClass: [NSDictionary class]])
        return [[MAErrorReportingDictionary alloc] initWithParent: parent dictionary: object key: key];
    
    return [[self alloc] initWithParent: parent object: object key: key];
}

- (id)initWithParent: (id)parent object: (id)object key: (id)key
{
    _parent = parent;
    _wrappedObject = object;
    _key = key;
    
    return self;
}

- (id)forwardingTargetForSelector: (SEL)sel
{
    NSLog(@"Forwarding %s", sel_getName(sel));
    return _wrappedObject;
}

- (NSMethodSignature *)methodSignatureForSelector: (SEL)sel
{
    return [_wrappedObject methodSignatureForSelector: sel];
}

- (void)forwardInvocation: (NSInvocation *)invocation
{
    [invocation invokeWithTarget: _wrappedObject];
}

- (Class)class
{
    if(_wrappedObject)
    {
        Class class = [_wrappedObject class];
        Class substitute = gSubclassesMap[class];
        return substitute ? substitute : class;
    }
    else
    {
        return object_getClass(self);
    }
}

- (BOOL)isKindOfClass: (Class)class
{
    if(_wrappedObject)
        return [_wrappedObject isKindOfClass: class];
    
    Class myClass = object_getClass(self);
    while(class)
    {
        if(class == myClass)
            return YES;
        
        class = class_getSuperclass(class);
    }
    return NO;
}

- (BOOL)respondsToSelector: (SEL)sel
{
    return [_wrappedObject respondsToSelector: sel] || class_respondsToSelector(object_getClass(self), sel);
}

- (void)setError: (NSError *)error
{
    error = [error ma_errorByPrependingKey: _key];
    [_parent setError: error];
    _errors = [NSMutableArray arrayWithObjects: error, nil];
}

- (NSError *)error
{
    return [_errors lastObject];
}

- (void)addError: (NSError *)error
{
    error = [error ma_errorByPrependingKey: _key];
    [_parent addError: error];
    if(!_errors)
        _errors = [NSMutableArray array];
    [_errors addObject: error];
}

- (NSArray *)errors
{
    return _errors;
}

@end
