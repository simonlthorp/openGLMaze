//
//  TextureObject.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "TextureObject.h"

@implementation TextureObject

-(id)initWithTextureU:(float)u V:(float)v {
    if((self = [super init])) {
        self.u = u;
        self.v = v;
    }
    return self;
}

@end
