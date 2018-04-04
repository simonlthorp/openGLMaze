//
//  PhysicsNode.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-30.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "PhysicsNode.h"

@implementation PhysicsNode


- (instancetype)initWithName:(char *)name shader:(Renderer *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount inidices:(GLuint *)indices indexCount:(unsigned int)indexCount {
    if ((self = [super initWithName:name shader:shader vertices:(Vertex *)vertices vertexCount:vertexCount inidices:(GLuint *)indices indexCount:indexCount])) {
        self.physicsInfo = [[PhysicsInfoWrapper alloc] init];
        self.modelOffset = GLKVector3Make(0, 0, 0);
    }
    return self;
}

- (void) setupPhysicsInfo:(int)tag {
    [self.physicsInfo setupWithTag:tag width:self.width / 2.0 height:self.height / 2.0 depth:self.depth / 2.0];
    self.physicsInfo.owner = self;
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    for(Node *child in self.children) {
        [child updateWithDelta:dt];
    }
    
    //GLKVector3 worldPos = self.position + self.modelOffset;
    
    //worldPos = GLKVector3Make(self.position.x + 4.5, self.position.y, self.position.z + 3.0);
    GLKVector3 worldPos = GLKVector3Make(self.position.x + self.modelOffset.x, self.position.y + self.modelOffset.y, self.position.z + self.modelOffset.z);
    GLKVector3 worldScale = GLKVector3Make(self.scaleX * self.scale, self.scaleY * self.scale, self.scaleZ * self.scale);
    
    Node *myParent = self.parent;
    
    while(myParent != nil) { 
        GLKVector3 parentPos = myParent.position;
        
        
        worldPos = GLKVector3Make(worldPos.x * (myParent.scaleX * myParent.scale) + parentPos.x,
                                  worldPos.y * (myParent.scaleY * myParent.scale) + parentPos.y,
                                  worldPos.z * (myParent.scaleZ * myParent.scale) + parentPos.z);
        
        GLKVector3 parentScale = GLKVector3Make(myParent.scaleX * myParent.scale,
                                                myParent.scaleY * myParent.scale,
                                                myParent.scaleZ * myParent.scale);

        worldScale = GLKVector3Make(worldScale.x * parentScale.x,
                                    worldScale.y * parentScale.y,
                                    worldScale.z * parentScale.z);
        
        myParent = myParent.parent;
    }
    
    // sync position and scale with physics bounding box
    [self.physicsInfo setRotationWithX:self.rotationX Y:self.rotationY Z:self.rotationZ];
    [self.physicsInfo setPosition:worldPos];
    [self.physicsInfo setScaleWithX:worldScale.x Y:worldScale.y Z:worldScale.z];
}

@end
