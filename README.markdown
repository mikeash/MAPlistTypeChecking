MAPlistTypeChecking
===================

An easier way to deal with type-checking the objects in property lists, JSON, and the like.

To use:

1. Wrap the top-level object of your property list in an `MAErrorReportingDictionary` or `MAErrorReportingArray`.
2. Extract sub-objects as usual.
3. Type-check them by using `ma_castRequiredObject:` or `ma_castOptionalObject:`. These will return `nil` if the types do not match.
4. Type-checking is generally optional. Code that expects plain property list types will get them. (One exception to this currently: keys which do not exist will not produce `nil`, but an instance of `MAErrorReportingObject` wrapping `nil`.)
5. When done, call `-errors` on the top-level object. A list of errors produced by the type-checking cast methods will be returned. An empty array means no errors.
6. Each error contains a code indicating whether it was due to a missing value or a value that was present but not of the correct type. It also contains the full key path used to obtain the value, stored in the `userInfo` under `MAErrorReportingContainersKeyPathUserInfoKey`.

Property list objects are wrapped in proxies that forward to the original object while adding the error-tracking facilities that make the rest possible. Arrays and dictionaries are wrapped in special objects which return proxies for their contents, while other classes (strings, numbers, data, dates) have more generic wrappers. Objects of other types are supported, but they get wrapped in instances of `MAErrorReportingObject` which do not directly proxy their contents. Instead, the wrapped object must be accessed by calling `-wrappedObject`, or by using one of the `ma_cast` methods, which will return the interior object if it is of the correct type.

Because of the proxy wrappers for property list types, the containers can *generally* be passed into code that is unaware of them, as they will still get valid, usable `NSString`, `NSNumber`, `NSDictionary`, etc. instances from the containers. One exception to this is that `nil` will be wrapped, so if the code does an explicit check for `nil`, it will not work properly.

Additional class cluster types can be given proxy wrappers fairly easily. To wrap non-container types such as `NSString`:

1. Create a new class subclassing the class cluster.
2. In the body of the `@interface` section, put `MA_ERROR_REPORTING_INTERFACE` to add the necessary interface portions.
3. In the `@implementation` section, put `MA_ERROR_REPORTING_IVARS` in brackets to declare the necessary instance variables.
4. In the body of the `@implementation` section, put `MA_ERROR_REPORTING_METHODS` to add the necessary methods.
5. Just below that, put `MA_ERROR_REPORTING_AUTO_CLUSTER_FORWARD` to automatically forward all methods from the main class cluster class to the wrapped object.

To wrap container types such as `NSArray`, the steps are similar, but require some manual intervention:

1. Create a new class subclassing the class cluster.
2. In the body of the `@interface` section, put `MA_ERROR_REPORTING_INTERFACE` to add the necessary interface portions.
3. In the `@implementation` section, put `MA_ERROR_REPORTING_IVARS` in brackets to declare the necessary instance variables.
4. In the body of the `@implementation` section, put `MA_ERROR_REPORTING_METHODS` to add the necessary methods.
5. Override the class cluster's primitive methods. For any methods that return an object in the container, wrap those objects using `-[MAErrorReportingObject wrapObject:parent:key:]` before returning them to the caller.

Pull requests are appreciated!