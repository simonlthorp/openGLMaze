//
//  Wall.m
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Wall.h"

@implementation Wall

- (instancetype)initWithShader:(Renderer *)shader {
    if ((self = [super initWithShader:shader])) {
        //[self loadTexture:@"dungeon_01.png"];
        //[self loadTexture:@"brick_1.jpg"];
        //[self loadTexture:@"crate.jpg"];
        
        self.scaleX = 1.5;
        self.scaleY = 1.5;
        self.scaleZ = 0.15;
    }
    return self;
}

@end
