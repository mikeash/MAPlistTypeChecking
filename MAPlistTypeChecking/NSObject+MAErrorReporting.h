//
//  NSObject+MAErrorReporting.h
//  MAPlistTypeChecking
//
//  Created by Michael Ash on 8/30/13.
//  Copyright (c) 2013 mikeash. All rights reserved.
//

#import <Foundation/Foundation.h>


/** The error domain used for reporting errors from ma_castRequiredObject: and ma_castOptionalObject:. */
extern NSString * const MAErrorReportingContainersErrorDomain;

/** A user info key for errors in MAErrorReportingContainersErrorDomain. Contains an NSArray containing keys, ordered from top to bottom, with strings for dictionary keys and NSNumbers for array indexes. */
extern NSString * const MAErrorReportingContainersKeyPathUserInfoKey;

enum {
    /** An error code indicating that a required key was not present. */
    MAErrorReportingContainersMissingRequiredKey,
    
    /** An error code indicating that an object was present but contained the wrong type. */
    MAErrorReportingContainersWrongValueType
};


@interface NSObject (MAErrorReporting)

/**
 * Cast an object to the receiver's type, generating an error if the object is nil.
 */
+ (instancetype)ma_castRequiredObject: (id)obj;

/**
 * Cast an object to the receiver's type, generating an error only if the object is non-nil and does not match the receiver's type.
 */
+ (instancetype)ma_castOptionalObject: (id)obj;

/**
 * @return YES if the receiver implements the interface from MAErrorReportingObject, NO otherwise
 */
- (BOOL)ma_isErrorReportingObject;

@end

@interface NSError (MAErrorReporting)

/**
 * Generate a new error object by prepending the given key to the array contained in
 * MAErrorReportingContainersKeyPathUserInfoKey in the receiver. Creates a new array
 * containing just that object if the receiver doesn't have an array.
 */
- (NSError *)ma_errorByPrependingKey: (id)key;

@end
