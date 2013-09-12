//
//  MAErrorReportingArray.m
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import "MAErrorReportingArray.h"

#import "MAErrorReportingDictionary.h"
#import "MAErrorReportingObject.h"
#import "NSObject+MAErrorReporting.h"


@implementation MAErrorReportingArray {
    MA_ERROR_REPORTING_IVARS
}

MA_ERROR_REPORTING_METHODS

- (NSUInteger)count
{
    return [_wrappedObject count];
}

- (id)objectAtIndex: (NSUInteger)index
{
    return [MAErrorReportingObject wrapObject: [_wrappedObject objectAtIndex: index] parent: self key: @(index)];
}

@end

