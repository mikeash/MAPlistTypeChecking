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
    id _parent;
    NSDictionary *_innerDictionary;
    NSMutableArray *_errors;
}

- (id)initWithDictionary: (NSDictionary *)dictionary
{
    return [self initWithParent: nil dictionary: dictionary key: nil];
}

- (id)initWithParent: (id)parent dictionary: (NSDictionary *)dictionary key: (id)key
{
    if((self = [super init]))
    {
        _parent = parent;
        _innerDictionary = dictionary;
        _key = key;
    }
    return self;
}

- (NSUInteger)count
{
    return [_innerDictionary count];
}

- (id)objectForKey: (id)key
{
    return [MAErrorReportingObject wrapObject: [_innerDictionary objectForKey: key] parent: self key: key];
}

- (NSEnumerator *)keyEnumerator
{
    return [_innerDictionary keyEnumerator];
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
