//
//  Cube.h
//  AnimatedCube
//
//  Created by Ryan Dieno on 2018-02-02.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "PhysicsNode.h"

@interface Cube : PhysicsNode

- (instancetype)initWithName:(char *)name andShader:(Renderer *)shader;
- (void)updateWithDelta:(NSTimeInterval)dt;

@end
