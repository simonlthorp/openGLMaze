//
//  Cell.m
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-10.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Cell.h"

@implementation Cell

-(id)init {
    if((self = [super init])) {
        self.visited = false;
    }
    return self;
}

-(void)createFloorAndAddToParentNode:(Node *)parent andShader:(Renderer *)shader {
    float x = self.north.position.x - 1.5;
    float z = self.west.position.z - 1.5;
    
    self.floor = [[Cube alloc] initWithShader:shader];
    [self.floor loadTexture:@"dungeon_01.png"];
    self.floor.position = GLKVector3Make(x, -1.5, z);
    self.floor.scaleX = 1.5;
    self.floor.scaleZ = 1.5;
    self.floor.scaleY = 0.15;
    
    [parent.children addObject:self.floor];
}

@end
