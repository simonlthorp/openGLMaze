//
//  NormalObject.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "NormalObject.h"

@implementation NormalObject

-(id)initWithNormalNX:(float)nx NY:(float)ny NZ:(float)nz {
    if((self = [super init])) {
        self.nx = nx;
        self.ny = ny;
        self.nz = nz;
    }
    return self;
}

@end
