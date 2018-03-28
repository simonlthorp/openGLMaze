//
//  MazeBuilder.h
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-04.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>

struct MazeClass;

@interface MazeHelper : NSObject
{
    @private
    struct MazeClass *mazeObject;
}

-(int)getRows;
-(int)getCols;

@end
