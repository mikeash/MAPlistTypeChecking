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


@implementation MAErrorReportingArray {
    id _parent;
    NSArray *_innerArray;
}

- (id)initWithParent: (id)parent array: (NSArray *)array
{
    if((self = [super init]))
    {
        _parent = parent;
        _innerArray = array;
    }
    return self;
}

- (NSUInteger)count
{
    return [_innerArray count];
}

- (id)objectAtIndex: (NSUInteger)index
{
    return [MAErrorReportingObject wrapObject: [_innerArray objectAtIndex: index] parent: self];
}

- (void)setError: (NSError *)error
{
    [_parent setError: error];
    _error = error;
}

@end

