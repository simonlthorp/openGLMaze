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
#import "ViewController.h"
#import "Wall.h"
#import "MazeNode.h"
#import "Director.h"

@implementation MainScene {
    CGSize _gameArea;
    float sceneOffset;
    MazeNode *maze;
    GLKVector3 _position;
    Cube *crate;
    
    NSString *miniMapString[10 * 2 + 1][10 * 2 + 1];
}

- (instancetype)initWithShader:(Renderer *)shader {
    if((self = [super initWithName:"MainScene" shader:shader vertices:nil vertexCount:0 inidices:nil indexCount:0])) {

        maze = [[MazeNode alloc] initWithShader:shader];
        maze.position = GLKVector3Make(4.5, 0, 3);
        [self.children addObject:maze];
        

        [self setupMinimap];
        
        Cell *startCell = [maze getCellX:0 Y:0];
        [maze.children removeObject:startCell.east];
        startCell.east = nil;
        
        crate = [[Cube alloc] initWithShader:shader];
        crate.scale = 0.8;
        [self.children addObject:crate];
        crate.isRotating = YES;
        
        
        self.posX = 0;
        self.posZ = 0;
        self.rotY = 0;
    }
    return self;
}

- (void)setupMinimap {
    
    ViewController *vc = (ViewController *) [Director sharedInstance].vc;
    
    UILabel *label = vc.MinimapLabel;
    label.text = @"";
    
    int xSize = 10 * 2 + 1;
    //int ySize = xSize;
    

    NSString *playerString = @"";
    float degrees = GLKMathRadiansToDegrees(self.rotY);
    
    if(degrees < 45) {
       playerString = [playerString stringByAppendingString:@"░↑"];
    } else if (degrees < 90) {
        playerString = [playerString stringByAppendingString:@"░↗"];
    } else if (degrees < 135) {
        playerString = [playerString stringByAppendingString:@"░→"];
    }else if (degrees < 180) {
        playerString = [playerString stringByAppendingString:@"░↘"];
    } else if (degrees < 225) {
        playerString = [playerString stringByAppendingString:@"░↓"];
    } else if (degrees < 270) {
        playerString = [playerString stringByAppendingString:@"░↙"];
    } else if (degrees < 315) {
        playerString = [playerString stringByAppendingString:@"░←"];
    } else if (degrees < 360) {
        playerString = [playerString stringByAppendingString:@"░↖"];
    }
    
    int playerX = (int) self.posX / 3;
    int playerY = (int) self.posZ / 3;
    
    NSString *myString = @"";
    
    for(int i = 0; i < xSize; i++) {
        myString = [myString stringByAppendingString:@"██"];
    }
    myString = [myString stringByAppendingString:@"\n"];
    
    for(int y = 0; y < 10; y++) {

       myString = [myString stringByAppendingString:@"██"];
       for(int x = 0; x < 10; x++) {
           Cell *cell = [maze getCellX:x Y:y];
           
           if(playerX == x && playerY == y) {
               myString = [myString stringByAppendingString:playerString];
           } else {
               myString = [myString stringByAppendingString:@"░░"];
               
           }
          
           
           if(cell.north != nil) {
               //NSLog(@"%i, %i, north true",i, j);
               myString = [myString stringByAppendingString:@"██"];
            } else {
                //NSLog(@"%i, %i, north false",i, j);
                myString = [myString stringByAppendingString:@"░░"];
            }
           
        }

        myString = [myString stringByAppendingString:@"\n"];
        
        myString = [myString stringByAppendingString:@"██"];
        for(int x = 0; x < 10; x++) {

            Cell *cell = [maze getCellX:x Y:y];

            
            if(cell.west != nil) {
                myString = [myString stringByAppendingString:@"██"];
            } else {
                myString = [myString stringByAppendingString:@"░░"];
            }
            myString = [myString stringByAppendingString:@"██"];
            
        }

        myString = [myString stringByAppendingString:@"\n"];
    }

    label.text = myString;
}


@end
