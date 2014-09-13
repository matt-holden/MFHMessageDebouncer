# MFHMessageDebouncer

This is an Objective-C implementation of a method debouncer. You can
read more about deboucing [here](http://unscriptable.com/2009/03/20/debouncing-javascript-methods/).

MFHMessageDebouncer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MFHMessageDebouncer"

#Usage

You have the option of:

1. Debouncing all message to an object, or 
2. Debounce all message to *any* object originating at a specific call
site:

### 1:

```objc
NSTimeInterval delayLength = 3.0;
NSMutableArray *myArray = [NSMutableArray array];

for (int i = 0; i < 3; i++) {
    [myArray addObject:@(i)];
}

// After three seconds, `myArray[0]` will return "3". 
// The `addObject:` message will only be sent to myArray a single time.
```

### 2:  (pulled straight from the unit tests)

```objc

// Make three mutable arrays
NSArray *arrayInstances = @[[NSMutableArray new], [NSMutableArray new], [NSMutableArray new]];

NSTimeInterval delay = 3.;
for (int i = 0; i < 3; i++) {
  // Debounce any message sent from this specific call site, regardless
  // of the receiver or message name
  [MFHDebouncedCallSite(arrayInstances[i], delay) addObject:@(i)];
}

// Only the last object that was messaged should have received 'addObject:', after a delay of 3 seconds.


// 3 seconds later...
[arrayInstances[0] count] == 0;  //true
[arrayInstances[1] count] == 0;  //true
[arrayInstances[2] count] == 1;  //true
```







## Author

Matthew Holden [@MFHolden](http://twitter.com/mfholden)

## License

MFHMessageDebouncer is available under the MIT license. See the LICENSE file for more info.

