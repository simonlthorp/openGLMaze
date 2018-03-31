//
//  SimpleVertex.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "SimpleVertex.h"

@implementation SimpleVertex

-(id)initWithVertex:(float)x Y:(float)y Z:(float)z {
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    return self;
}

@end
