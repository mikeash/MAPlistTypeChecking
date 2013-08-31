//
//  NSObject+MAErrorReporting.m
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import "NSObject+MAErrorReporting.h"

#import "MAErrorReportingObject.h"


NSString * const MAErrorReportingContainersErrorDomain = @"MAErrorReportingContainersErrorDomain";

@implementation NSObject (MAErrorReporting)

+ (instancetype)ma_cast: (id)obj required: (BOOL)required
{
    id value = obj;
    if([obj isKindOfClass: [MAErrorReportingObject class]])
        value = [obj wrappedObject];
    
    if(required && !value)
    {
        if([obj respondsToSelector: @selector(addError:)])
        {
            NSError *error = [NSError errorWithDomain: MAErrorReportingContainersErrorDomain code: MAErrorReportingContainersMissingRequiredKey userInfo: nil];
            [obj addError: error];
        }
        return nil;
    }
    
    if(value && ![value isKindOfClass: self])
    {
        if([obj respondsToSelector: @selector(addError:)])
        {
            NSError *error = [NSError errorWithDomain: MAErrorReportingContainersErrorDomain code: MAErrorReportingContainersWrongValueType userInfo: nil];
            [obj addError: error];
        }
        return nil;
    }
    
    return value;
    
}

+ (instancetype)ma_castRequiredObject: (id)obj
{
    return [self ma_cast: obj required: YES];
}

+ (instancetype)ma_castOptionalObject: (id)obj
{
    return [self ma_cast: obj required: NO];
}

@end
