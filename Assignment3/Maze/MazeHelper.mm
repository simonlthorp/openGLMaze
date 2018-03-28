//
//  MazeBuilder.m
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-04.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "MazeHelper.h"
#import "maze.h"

struct MazeClass
{
    Maze mazeObj;
};

@implementation MazeHelper

- (id)init
{
    self = [super init];
    if (self) {
        mazeObject = new MazeClass;
        mazeObject->mazeObj.Create();
        //mazeObject->mazeObj.PrintCells();
    }
    return self;
}

-(int)getRows {
    return mazeObject->mazeObj.rows;
}

-(int)getCols {
    return mazeObject->mazeObj.cols;
}

@end
