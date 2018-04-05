//
//  RDMainScene.h
//  COMP 8051 - Assignment 1
//
//  Created by Ryan Dieno on 2018-02-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Node.h"
#import "LineRenderer.h"

@interface MainScene : Node

//- (instancetype)initWithShader:(Renderer *)shader;
- (instancetype)initWithShader:(Renderer *)shader andLineShader:(LineRenderer *)lineShader;

@property (nonatomic) float posX;
@property (nonatomic) float posZ;
@property (nonatomic) float rotY;
@property (nonatomic) BOOL isDoingSomething;

- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;
- (void)setupMinimap;
- (void)updateWithDelta:(NSTimeInterval)dt;

- (void)chooseRandomDirection;

- (void)toggleView;

- (BOOL)checkIfPlayerIsInSameCellAsModel;

- (void)translateModel:(CGPoint)p;

- (void)rotateModel:(float)degrees;

- (void)scaleModel:(float)scaleSlider;

@end
