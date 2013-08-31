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
    id _parent;
    NSArray *_innerArray;
    NSMutableArray *_errors;
}

- (id)initWithParent: (id)parent array: (NSArray *)array key: (id)key
{
    if((self = [super init]))
    {
        _parent = parent;
        _innerArray = array;
        _key = key;
    }
    return self;
}

- (NSUInteger)count
{
    return [_innerArray count];
}

- (id)objectAtIndex: (NSUInteger)index
{
    return [MAErrorReportingObject wrapObject: [_innerArray objectAtIndex: index] parent: self key: @(index)];
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

