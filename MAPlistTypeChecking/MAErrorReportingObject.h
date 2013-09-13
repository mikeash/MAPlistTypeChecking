//
//  MAErrorReportingObject.h
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MA_ERROR_REPORTING_INTERFACE \
    - (id)initWithParent: (id)parent object: (id)object key: (id)key; \
    \
    @property (nonatomic) NSError *error; \
    @property (readonly) id wrappedObject; \
    \
    - (void)addError: (NSError *)error; \
    - (NSArray *)errors; \
    \
    @property (readonly) id key;

#define MA_ERROR_REPORTING_IVARS \
    id _parent; \
    NSMutableArray *_errors;

#define MA_ERROR_REPORTING_METHODS \
    - (id)initWithParent: (id)parent object: (id)object key: (id)key \
    { \
        if((self = [super init])) \
        { \
            _parent = parent; \
            _wrappedObject = object; \
            _key = key; \
        } \
        return self; \
    } \
    \
    - (id)forwardingTargetForSelector: (SEL)sel \
    { \
        return _wrappedObject; \
    } \
    \
    - (void)setError: (NSError *)error \
    { \
        error = [error ma_errorByPrependingKey: _key]; \
        [_parent setError: error]; \
        _errors = [NSMutableArray arrayWithObjects: error, nil]; \
    } \
    \
    - (NSError *)error \
    { \
        return [_errors lastObject]; \
    } \
    \
    - (void)addError: (NSError *)error \
    { \
        error = [error ma_errorByPrependingKey: _key]; \
        [_parent addError: error]; \
        if(!_errors) \
            _errors = [NSMutableArray array]; \
            [_errors addObject: error]; \
    } \
    \
    - (NSArray *)errors \
    { \
        return _errors; \
    } \
    \
    - (BOOL)ma_isErrorReportingObject { \
        return YES; \
    }

#define MA_ERROR_REPORTING_AUTO_CLUSTER_FORWARD \
    + (void)initialize \
    { \
        MAErrorReportingClassFixup(self); \
    }


void MAErrorReportingClassFixup(Class class);

@interface MAErrorReportingObject : NSObject

+ (id)wrapObject: (id)object parent: (id)parent key: (id)key;
+ (id)wrapObject: (id)object;

MA_ERROR_REPORTING_INTERFACE

@end

@interface MAErrorReportingString : NSString

MA_ERROR_REPORTING_INTERFACE

@end

@interface MAErrorReportingNumber : NSNumber

MA_ERROR_REPORTING_INTERFACE

@end

@interface MAErrorReportingData : NSData

MA_ERROR_REPORTING_INTERFACE

@end

@interface MAErrorReportingDate : NSDate

MA_ERROR_REPORTING_INTERFACE

@end
