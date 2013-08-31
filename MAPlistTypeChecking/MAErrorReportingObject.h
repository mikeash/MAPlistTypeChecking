//
//  MAErrorReportingObject.h
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAErrorReportingObject : NSObject

+ (id)wrapObject: (id)object parent: (id)parent;

- (id)initWithParent: (id)parent object: (id)object;

@property (nonatomic) NSError *error;
@property (readonly) id wrappedObject;

@end
