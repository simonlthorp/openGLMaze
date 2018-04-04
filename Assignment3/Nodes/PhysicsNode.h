//
//  PhysicsNode.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-30.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Node.h"
#import "PhysicsInfoWrapper.h"

@interface PhysicsNode : Node

@property (nonatomic, strong) PhysicsInfoWrapper *physicsInfo;
@property (assign) GLKVector3 modelOffset;

- (instancetype)initWithName:(char *)name shader:(Renderer *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount inidices:(GLuint *)indices indexCount:(unsigned int)indexCount;
- (void) setupPhysicsInfo:(int)tag;
- (void)updateWithDelta:(NSTimeInterval)dt;
@end
