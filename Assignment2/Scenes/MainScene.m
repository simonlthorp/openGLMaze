//
//  RDMainScene.m
//  COMP 8051 - Assignment 1
//
//  Created by Ryan Dieno on 2018-02-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "MainScene.h"
//#import "Cube.h"
//#import "Director.h"
//#import "ViewController.h"
#import "Wall.h"
#import "MazeNode.h"

@implementation MainScene {
    CGSize _gameArea;
    float sceneOffset;
    MazeNode *maze;
    GLKVector3 _position;
    Cube *center;
}

- (instancetype)initWithShader:(Renderer *)shader {
    if((self = [super initWithName:"MainScene" shader:shader vertices:nil vertexCount:0 inidices:nil indexCount:0])) {

        maze = [[MazeNode alloc] initWithShader:shader];
        maze.position = GLKVector3Make(4.5, 0, 3);
        [self.children addObject:maze];
        
        center = [[Cube alloc] initWithShader:shader];
        center.matColor = GLKVector4Make(1, 0, 0, 1);
        
        center.scaleY = 8;
        center.scaleX = 0.25;
        center.scaleZ = 0.25;
        
        [self.children addObject:center];

        _position = GLKVector3Make(0, 45, -10);
    }
    return self;
}


@end
