//
//  Maze.m
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-10.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "MazeNode.h"
#import "MazeHelper.h"
#import "Wall.h"
#import "Cell.h"

@implementation MazeNode {
    //MazeHelper *mazeHelper;
    int xSize;
    int ySize;
    float wallLength;
    GLKVector3 initialPos;
    NSMutableArray *wallHolder;
    NSMutableArray *allwalls;
    NSMutableArray *lastCells;
    NSMutableArray *cells;
    int totalCells;
    int visitedCells;
    BOOL startedBuilding;
    int currentNeighbour;
    int currentCell;
    int backingUp;
    int wallToBreak;
}

- (instancetype)initWithShader:(Renderer *)shader {
    if ((self = [super initWithName:"Maze" shader:shader vertices:nil vertexCount:0 inidices:nil indexCount:0])) {
        //mazeHelper = [[MazeHelper alloc] init];
        //rows = [mazeHelper getRows];
        //cols = [mazeHelper getCols];
        xSize = 10;
        ySize = 10;
        wallLength = 3.0;
        
        visitedCells = 0;
        startedBuilding = NO;
        currentNeighbour = 0;
        currentCell = 0;
        backingUp = 0;
        wallToBreak = 0;
        
        
        self.shader = shader;
        [self createWalls];
        [self applyTextures];
    }
    return self;
}

- (void)createWalls {
    initialPos = GLKVector3Make((-xSize / 2.0) + wallLength / 2.0 ,
                                0.0,
                                (-ySize / 2.0) + wallLength / 2.0 );
    
    GLKVector3 myPos = initialPos;
    
    wallHolder = [NSMutableArray arrayWithCapacity:((xSize + 1) * (ySize + 1))];
    //walls = [NSMutableArray array];
    
    //For X Axis
    for(int i = 0; i < ySize; i++)
    {
        for(int j = 0; j <= xSize; j++)
        {
            myPos = GLKVector3Make((initialPos.z + (i * wallLength) - wallLength / 2.0f),
                                   0.0f,
                                   initialPos.x + (j * wallLength) - wallLength / 2.0f);
            
            //myPos.z *= -1.0;
            
            Wall *tempWall = [[Wall alloc] initWithShader:self.shader];
            tempWall.position = myPos;
            
            //NSLog(@"x: %f, y: %f, z: %f", myPos.x, myPos.y, myPos.z);

            //[self.children addObject:tempWall];
            [wallHolder addObject:tempWall];
        }
    
    }
    //initialPos = GLKVector3Make(((-(float)xSize / 2.0) + wallLength / 2.0) - wallLength,
    //                            0.0,
    //                            ((-(float)ySize / 2.0) + wallLength / 2.0) c);
    
    //For Y Axis
    for(int i = 0; i <= ySize; i++)
    {
        for(int j = 0; j < xSize; j++)
        {
            /*myPos = GLKVector3Make(initialPos.x + (j * wallLength),
                                   0.0f,
                                   (initialPos.z + (i * wallLength) - wallLength));*/
            myPos = GLKVector3Make((initialPos.z + (i * wallLength) - wallLength),
                                   0.0f,
                                   initialPos.x + (j * wallLength) );
            
            //myPos.z *= -1.0;
            
            Wall *tempWall = [[Wall alloc] initWithShader:self.shader];
            tempWall.rotationY = GLKMathDegreesToRadians(-90.0);
            tempWall.position = myPos;
            
            //NSLog(@"x: %f, y: %f, z: %f", myPos.x, myPos.y, myPos.z);
            
            //[self.children addObject:tempWall];
            [wallHolder addObject:tempWall];
        }
    }
    
    [self createCells];
}

- (void)createCells {
    lastCells = [NSMutableArray array];
    totalCells = xSize * ySize;
    int children = (int) [wallHolder count];
    allwalls = [NSMutableArray arrayWithCapacity:children];
    cells = [NSMutableArray arrayWithCapacity:totalCells];
    int eastWestProcess = 0;
    int childProcess = 0;
    int termCount = 0;
    
    //Gets all the children
    for (int i = 0; i < children; i++)
    {
        [allwalls addObject:wallHolder[i]];
    }
    
    for(int cellProcess = 0; cellProcess < totalCells; cellProcess++) {
        if(termCount == xSize)
        {
            eastWestProcess++;
            termCount = 0;
        }
        
        Cell *newCell = [[Cell alloc] init];
        
        newCell.east = allwalls[eastWestProcess];
        newCell.south = allwalls[childProcess + (xSize + 1) * ySize];
        
        eastWestProcess++;
        termCount++;
        childProcess++;
        
        newCell.west = allwalls[eastWestProcess];
        newCell.north = allwalls[(childProcess + (xSize + 1) * ySize) + xSize - 1];
        
        [self.children addObject:newCell.north];
        [self.children addObject:newCell.south];
        [self.children addObject:newCell.east];
        [self.children addObject:newCell.west];
        
        [cells addObject:newCell];
    }
    
    [self addFloorsToCellsWithShader:self.shader];
    
    [self createMaze];
}

- (void)createMaze {
    while (visitedCells < totalCells) {
        if(startedBuilding) {
            [self giveMeNeighbour];
            Cell *cNeighbourCell = cells[currentNeighbour];
            Cell *cCurrentCell = cells[currentCell];
            if(cNeighbourCell.visited == NO && cCurrentCell.visited == YES) {
                [self breakWall];
                Cell *myCurrentCell = cells[currentNeighbour];
                myCurrentCell.visited = YES;
                visitedCells++;
                [lastCells addObject:[NSNumber numberWithInteger:currentCell]];
                currentCell = currentNeighbour;
                if([lastCells count] > 0) {
                    backingUp = (int) [lastCells count] - 1;
                }
            }
        } else {
            currentCell = arc4random_uniform(totalCells);
            Cell *myCell = cells[currentCell];
            myCell.visited = YES;
            visitedCells++;
            startedBuilding = YES;
        }
    }
    //[self addWallsToNode];
}

- (void)breakWall {
    Cell *myCell = cells[currentCell];
    //Cell *savedCell = myCell;
    switch (wallToBreak) {
        case 1: {
            [self.children removeObject:myCell.north];
            Cell *myNeighbour = cells[currentCell + xSize];
            myCell.north = nil;
            myNeighbour.south = nil;
            break;
        }
        case 2: {
            [self.children removeObject:myCell.east];
            myCell.east = nil;
            Cell *myNeighbour = cells[currentCell - 1];
            myNeighbour.west = nil;
            break;
        }
        case 3: {
            [self.children removeObject:myCell.west];
            Cell *myNeighbour = cells[currentCell + 1];
            myCell.west = nil;
            myNeighbour.east = nil;
            break;
        }
        case 4: {
            [self.children removeObject:myCell.south];
            Cell *myNeighbour = cells[currentCell - xSize];
            myCell.south = nil;
            myNeighbour.north = nil;
            break;
        }
        default:
            NSLog(@"Error in breakWall");
            break;
    }
}

- (void)giveMeNeighbour {
    int length = 0;
    NSMutableArray *neighbours = [NSMutableArray arrayWithCapacity:4];
    neighbours[0] = [NSNumber numberWithInteger:0];
    neighbours[1] = [NSNumber numberWithInteger:0];
    neighbours[2] = [NSNumber numberWithInteger:0];
    neighbours[3] = [NSNumber numberWithInteger:0];
    NSMutableArray *connectingWall = [NSMutableArray arrayWithCapacity:4];
    connectingWall[0] = [NSNumber numberWithInteger:0];
    connectingWall[1] = [NSNumber numberWithInteger:0];
    connectingWall[2] = [NSNumber numberWithInteger:0];
    connectingWall[3] = [NSNumber numberWithInteger:0];
    int check = (currentCell + 1) / xSize;
    check -= 1;
    check *= xSize;
    check += ySize;
    
    //west
    if(currentCell + 1 < totalCells && (currentCell + 1) != check) {
        Cell *myCell = cells[currentCell + 1];
        if(myCell.visited == NO) {
            neighbours[length] = [NSNumber numberWithInteger:currentCell + 1];
            connectingWall[length] = [NSNumber numberWithInteger:3];
            length++;
        }
    }
    
    //east
    if(currentCell - 1 >= 0 && currentCell != check) {
        Cell *myCell = cells[currentCell - 1];
        if(myCell.visited == NO) {
            neighbours[length] = [NSNumber numberWithInteger:currentCell - 1];
            connectingWall[length] = [NSNumber numberWithInteger:2];
            length++;
        }
    }
    
    //north
    if(currentCell + xSize < totalCells) {
        Cell *myCell = cells[currentCell + xSize];
        if(myCell.visited == NO) {
            neighbours[length] = [NSNumber numberWithInteger:currentCell + xSize];
            connectingWall[length] = [NSNumber numberWithInteger:1];
            length++;
        }
    }
    
    //south
    if(currentCell - xSize >= 0) {
        Cell *myCell = cells[currentCell - xSize];
        if(myCell.visited == NO) {
            neighbours[length] = [NSNumber numberWithInteger:currentCell - xSize];
            connectingWall[length] = [NSNumber numberWithInteger:4];
            length++;
        }
    }
    
    if(length != 0) {
        int randomCell = arc4random_uniform(length);
        currentNeighbour = (int) [neighbours[randomCell] integerValue];
        wallToBreak = (int) [connectingWall[randomCell] integerValue];
    } else {
        if(backingUp > 0) {
            currentCell = (int) [lastCells[backingUp] integerValue];
            backingUp--;
        }
    }
}

- (void)addFloorsToCellsWithShader:(Renderer *)shader {
    for(int i = 0; i < [cells count]; i++) {
        Cell *myCell = cells[i];
        [myCell createFloorAndAddToParentNode:self andShader:shader];
    }
}

- (void)applyTextures {

    /*
     
     1. no walls to either side - brick 1
     2. a wall to the left - brick 2
     3. a wall to the right - brick 3
     4. walls on both sides - brick 4
     
     */
    
    // x axis
    for(int i = 0; i < [cells count]; i++) {
        Cell *myCell = cells[i];
        if(i < xSize) { // first col
            Cell *neighbourCell = cells[i + xSize];
            if(myCell.east != nil) {
                if(neighbourCell.east == nil) {
                    [myCell.east loadTexture:@"brick_1.jpg"];
                } else {
                    [myCell.east loadTexture:@"brick_3.jpg"];
                }
            }
            
            if(i == (xSize - 1)) {
                Cell *neighbourCell = cells[i + xSize];
                if(neighbourCell.west != nil) {
                    [myCell.west loadTexture:@"brick_3.jpg"];
                    //NSLog(@"index: %i, YES", i);
                } else {
                    [myCell.west loadTexture:@"brick_1.jpg"];
                    //NSLog(@"index: %i, NO", i);
                }
            }
        } else if(i > (((xSize * ySize) - 1) - (xSize))&& i < ((xSize * ySize))) { // last col
            Cell *neighbourCell = cells[i - xSize];
            if(myCell.east != nil) {
                if(neighbourCell.east == nil) {
                    [myCell.east loadTexture:@"brick_1.jpg"];
                } else {
                    [myCell.east loadTexture:@"brick_2.jpg"];
                }
            }
            
            if(i == ((xSize * ySize) - 1)) {
                Cell *neighbourCell = cells[i - xSize];
                if(neighbourCell.west != nil) {
                    [myCell.west loadTexture:@"brick_2.jpg"];
                    //NSLog(@"index: %i, YES", i);
                } else {
                    [myCell.west loadTexture:@"brick_1.jpg"];
                    //NSLog(@"index: %i, NO", i);
                }
            }
        } else { // middle cols
            Cell *neighbourCellNorth = cells[i + xSize];
            Cell *neighbourCellSouth = cells[i - xSize];
            if(neighbourCellNorth.east != nil && neighbourCellSouth.east != nil) {
                [myCell.east loadTexture:@"brick_4.jpg"];
            } else if(neighbourCellNorth.east != nil && neighbourCellSouth.east == nil) {
                [myCell.east loadTexture:@"brick_3.jpg"];
            } else if (neighbourCellNorth.east == nil && neighbourCellSouth.east != nil) {
                [myCell.east loadTexture:@"brick_2.jpg"];
            } else {
                [myCell.east loadTexture:@"brick_1.jpg"];
            }

            if(i % xSize == (xSize - 1)) {
                [myCell.west loadTexture:@"brick_4.jpg"];
            }
            
        }
    }
    
    // y axis
    for(int i = 0; i < [cells count]; i++) {
        Cell *myCell = cells[i];
        if(i % xSize == 0) { // first row
            Cell *neighbourCell = cells[i + 1];
            if(myCell.south != nil) {
                if(neighbourCell.south == nil) {
                    [myCell.south loadTexture:@"brick_1.jpg"];
                } else {
                    [myCell.south loadTexture:@"brick_2.jpg"];
                }
            }
            
            if(i == ((xSize * ySize) - xSize)) {
                Cell *neighbourCell = cells[i + 1];
                if(neighbourCell.north == nil) {
                    [myCell.north loadTexture:@"brick_1.jpg"];
                    //NSLog(@"index: %i, YES", i);
                } else {
                    [myCell.north loadTexture:@"brick_2.jpg"];
                    //NSLog(@"index: %i, NO", i);
                }
            }
        } else if(i % xSize == (xSize - 1)) { // last col
            Cell *neighbourCell = cells[i - 1];
            if(myCell.south != nil) {
                if(neighbourCell.south == nil) {
                    [myCell.south loadTexture:@"brick_1.jpg"];
                } else {
                    [myCell.south loadTexture:@"brick_3.jpg"];
                }
            }
            
            if(i == ((xSize * ySize) - 1)) {
                Cell *neighbourCell = cells[i - 1];
                if(neighbourCell.north != nil) {
                    [myCell.north loadTexture:@"brick_3.jpg"];
                    //NSLog(@"index: %i, YES", i);
                } else {
                    [myCell.north loadTexture:@"brick_1.jpg"];
                    //NSLog(@"index: %i, NO", i);
                }
            }
        } else {
            Cell *neighbourCellWest = cells[i + 1];
            Cell *neighbourCellEast = cells[i - 1];
            if(neighbourCellWest.south != nil && neighbourCellEast.south != nil) {
                [myCell.south loadTexture:@"brick_4.jpg"];
            } else if(neighbourCellWest.south != nil && neighbourCellEast.south == nil) {
                [myCell.south loadTexture:@"brick_2.jpg"];
            } else if (neighbourCellWest.south == nil && neighbourCellEast.south != nil) {
                [myCell.south loadTexture:@"brick_3.jpg"];
            } else {
                [myCell.south loadTexture:@"brick_1.jpg"];
            }
            
            if(i > ((xSize * ySize) - xSize)) {
                [myCell.north loadTexture:@"brick_4.jpg"];
            }
        }
    }
    
}

-(void) updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    self.rotationY += 0;
}

@end
