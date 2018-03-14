//
//  Maze.h
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-10.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Node.h"

@interface MazeNode : Node

@property (nonatomic, strong) Renderer *shader;

- (instancetype)initWithShader:(Renderer *)shader;
- (void)createWalls;
- (void)createCells;
- (void)createMaze;
- (void)breakWall;
- (void)giveMeNeighbour;
- (void)addFloorsToCellsWithShader:(Renderer *)shader;
- (void)applyTextures;
@end
