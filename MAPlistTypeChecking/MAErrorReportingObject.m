//
//  MAErrorReportingObject.m
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import "MAErrorReportingObject.h"

#import "MAErrorReportingArray.h"
#import "MAErrorReportingDictionary.h"
#import "NSObject+MAErrorReporting.h"


@implementation MAErrorReportingObject {
    MA_ERROR_REPORTING_IVARS
}

+ (id)wrapObject: (id)object parent: (id)parent key: (id)key
{
    Class class = self;
    if([object isKindOfClass: [NSArray class]])
        class = [MAErrorReportingArray class];
    else if([object isKindOfClass: [NSDictionary class]])
        class = [MAErrorReportingDictionary class];
    
    return [[class alloc] initWithParent: parent object: object key: key];
}

MA_ERROR_REPORTING_METHODS

@end
