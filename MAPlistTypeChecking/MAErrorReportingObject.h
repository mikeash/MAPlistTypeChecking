//
//  MAErrorReportingObject.h
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAErrorReportingObject : NSObject

+ (id)wrapObject: (id)object parent: (id)parent key: (id)key;

- (id)initWithParent: (id)parent object: (id)object key: (id)key;

@property (nonatomic) NSError *error;
@property (readonly) id wrappedObject;

- (void)addError: (NSError *)error;
- (NSArray *)errors;

@property (readonly) id key;

@end
