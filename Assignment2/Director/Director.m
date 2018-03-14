//
//  RDDirector.m
//  BrickBreaker
//
//  Created by Ryan Dieno on 2018-02-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Director.h"

@implementation Director
+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static Director *_sharedInstance;
    dispatch_once(&pred, ^{_sharedInstance = [[self alloc] init]; });
    return _sharedInstance;
}

- (instancetype) init {
    if((self = [super init])) {
        
    }
    return self;
}
@end

