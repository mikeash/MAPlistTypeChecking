//
//  MAErrorReportingDictionary.m
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import "MAErrorReportingDictionary.h"

#import "MAErrorReportingObject.h"
#import "NSObject+MAErrorReporting.h"


@implementation MAErrorReportingDictionary {
    MA_ERROR_REPORTING_IVARS
}

MA_ERROR_REPORTING_METHODS

- (NSUInteger)count
{
    return [_wrappedObject count];
}

- (id)objectForKey: (id)key
{
    return [MAErrorReportingObject wrapObject: [_wrappedObject objectForKey: key] parent: self key: key];
}

- (NSEnumerator *)keyEnumerator
{
    return [_wrappedObject keyEnumerator];
}

@end
