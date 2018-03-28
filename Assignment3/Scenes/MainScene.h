//
//  RDMainScene.h
//  COMP 8051 - Assignment 1
//
//  Created by Ryan Dieno on 2018-02-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Node.h"

@interface MainScene : Node

- (instancetype)initWithShader:(Renderer *)shader;

@property (nonatomic) float posX;
@property (nonatomic) float posZ;
@property (nonatomic) float rotY;

- (void)setupMinimap;

@end
