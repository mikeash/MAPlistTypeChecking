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


void MAErrorReportingClassFixup(Class class)
{
    Class superclass = class_getSuperclass(class);
    
    if(class_respondsToSelector(superclass, @selector(wrappedObject)))
        return;
    
    while(superclass != [NSObject class])
    {
        Method *methods = class_copyMethodList(superclass, NULL);
        for(Method *cursor = methods; *cursor; cursor++)
        {
            SEL sel = method_getName(*cursor);
            const char *types = method_getTypeEncoding(*cursor);
            class_addMethod(class, sel, _objc_msgForward, types);
        }
        free(methods);
        superclass = class_getSuperclass(superclass);
    }
}

@implementation MAErrorReportingObject {
    MA_ERROR_REPORTING_IVARS
}

+ (id)wrapObject: (id)object parent: (id)parent key: (id)key
{
    Class class = self;
    
#define CASE(baseName) else if([object isKindOfClass: [NS ## baseName class]]) class = [MAErrorReporting ## baseName class];
    if(0) {}
    CASE(Array)
    CASE(Dictionary)
    CASE(String)
    CASE(Number)
    CASE(Data)
    CASE(Date)
#undef CASE
    
    return [[class alloc] initWithParent: parent object: object key: key];
}

+ (id)wrapObject: (id)object
{
    return [self wrapObject: object parent: nil key: nil];
}

MA_ERROR_REPORTING_METHODS

@end

@implementation MAErrorReportingString {
    MA_ERROR_REPORTING_IVARS
}

MA_ERROR_REPORTING_METHODS
MA_ERROR_REPORTING_AUTO_CLUSTER_FORWARD

@end

@implementation MAErrorReportingNumber {
    MA_ERROR_REPORTING_IVARS
}

MA_ERROR_REPORTING_METHODS
MA_ERROR_REPORTING_AUTO_CLUSTER_FORWARD

@end

@implementation MAErrorReportingData {
    MA_ERROR_REPORTING_IVARS
}

MA_ERROR_REPORTING_METHODS
MA_ERROR_REPORTING_AUTO_CLUSTER_FORWARD

@end

@implementation MAErrorReportingDate {
    MA_ERROR_REPORTING_IVARS
}

MA_ERROR_REPORTING_METHODS
MA_ERROR_REPORTING_AUTO_CLUSTER_FORWARD

@end
