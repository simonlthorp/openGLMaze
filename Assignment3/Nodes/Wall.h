//
//  Wall.h
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-07.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Cube.h"

@interface Wall : Cube

- (instancetype)initWithName:(char *)name andShader:(Renderer *)shader;

@end
