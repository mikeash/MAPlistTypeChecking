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


@implementation MAErrorReportingObject {
    id _parent;
    NSMutableArray *_errors;
}

+ (id)wrapObject: (id)object parent: (id)parent
{
    if([object isKindOfClass: [NSArray class]])
        return [[MAErrorReportingArray alloc] initWithParent: parent array: object];
    if([object isKindOfClass: [NSDictionary class]])
        return [[MAErrorReportingDictionary alloc] initWithParent: parent dictionary: object];
    
    return [[self alloc] initWithParent: parent object: object];
}

- (id)initWithParent: (id)parent object: (id)object
{
    if((self = [super init]))
    {
        _parent = parent;
        _wrappedObject = object;
    }
    return self;
}

- (void)setError: (NSError *)error
{
    [_parent setError: error];
    _errors = [NSMutableArray arrayWithObjects: error, nil];
}

- (NSError *)error {
    return [_errors lastObject];
}

- (void)addError: (NSError *)error {
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
