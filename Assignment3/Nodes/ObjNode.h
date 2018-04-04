//
//  ObjNode.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhysicsNode.h"

@interface ObjNode : PhysicsNode

- (instancetype)initWithShader:(Renderer *)shader andOBJFile:(NSString *)oFilename andTexture:(NSString *)tFilename;

- (Vertex *)vertexArrayFromVertexObjectArray:(NSMutableArray *)voa;
- (GLuint *) indexArrayFromIndexObjectArray:(NSMutableArray *)ioa;

@end
