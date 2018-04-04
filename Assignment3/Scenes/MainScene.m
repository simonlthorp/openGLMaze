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
//#import "ObjLoader.h"
#import "ObjNode.h"
#import "PhysicsWorldWrapper.h"
#import "PhysicsTags.h"

enum MoveDirection {
    North,
    East,
    South,
    West
};

@implementation MainScene {
    CGSize _gameArea;
    float sceneOffset;
    LineRenderer *lineRenderer;
    MazeNode *maze;
    GLKVector3 _position;
    Cube *crate;
    NSString *miniMapString[10 * 2 + 1][10 * 2 + 1];
    PhysicsWorldWrapper *physicsWorld;
    
    GLKVector3 savePosition;
    GLKVector3 saveRotation;
    
    BOOL isBirdsEye;
    
    ObjNode *on;
    
    int direction;
    BOOL isDetectingCollision;
    
    BOOL isMoving;
    BOOL isRotating;
    BOOL isBackingUp;
    float moveSpeed;
    
    float currentYRotation;
    float targetYRotation;
    float currentBackupPosition;
    float targetBackupPosition;
    
    BOOL isTurningLeft;
}

- (instancetype)initWithShader:(Renderer *)shader andLineShader:(LineRenderer *)lineShader {
    if((self = [super initWithName:"MainScene" shader:shader vertices:nil vertexCount:0 inidices:nil indexCount:0])) {

        lineRenderer = lineShader;
        
        physicsWorld = [[PhysicsWorldWrapper alloc] init];
        
        maze = [[MazeNode alloc] initWithShader:shader andWorld:physicsWorld];
        //maze.position = GLKVector3Make(4.9, 0, 6.5);
        maze.position = GLKVector3Make(4.9, 0, 5.8);
        
        _isDoingSomething = YES;
        
        //maze.parent = self;
        
        [self.children addObject:maze];
        

        //[self setupMinimap];
        
        Cell *startCell = [maze getCellX:0 Y:0];
        
        [physicsWorld removeCollisionObject:startCell.east.physicsInfo];
        
        [maze.children removeObject:startCell.east];
        //startCell.east = nil;
        
        
        //crate = [[Cube alloc] initWithName:"crate" andShader:shader];
        //crate.scale = 0.3;
        //crate.scaleX = 0.3;
        
        //crate.position = GLKVector3Make(0, 5, 0);
        
        //crate.parent = self;
        //[crate setupPhysicsInfo:kWallTag];
        //[physicsWorld addCollisionObject:crate.physicsInfo];
        
        //[self.children addObject:crate];
        //crate.isRotating = YES;
        
        
        //ObjNode *on = [[ObjNode alloc] initWithShader:shader andOBJFile:@"goat.obj" andTexture:@"Goat_Brown.png"];
        on = [[ObjNode alloc] initWithShader:shader andOBJFile:@"fox.obj" andTexture:@"fox.png"];
        
        on.scale = 0.4;
        
        on.modelOffset = GLKVector3Make(0, 0.5, -0.1);
        
        [on setupPhysicsInfo:kModelTag];
        [physicsWorld addCollisionObject:on.physicsInfo];
        on.position = GLKVector3Make(-0.1, -1.0, 2);
        
        //ObjNode *on = [[ObjNode alloc] initWithShader:shader andOBJFile:@"mech.obj" andTexture:@"mech.png"];
        //ObjNode *on = [[ObjNode alloc] initWithShader:shader andOBJFile:@"chicken.obj" andTexture:@"chicken_01.png"];
        //ObjNode *on = [[ObjNode alloc] initWithShader:shader andOBJFile:@"Polywhirl.obj" andTexture:@"polywhirl.png"];
        //ObjNode *on = [[ObjNode alloc] initWithShader:shader andOBJFile:@"airplane2.obj" andTexture:@"airplane2.png"];
        //ObjNode *on = [[ObjNode alloc] initWithShader:shader andOBJFile:@"griffin.obj" andTexture:@"griffin.png"];
        
        [self.children addObject:on];
        
        
        //self.position = GLKVector3Make(-10, -11, 10);
        //self.rotationX = GLKMathDegreesToRadians(-70);
        
        isBirdsEye = NO;
        
        self.posX = 0;
        self.posZ = 0;
        self.rotY = 0;
        
        direction = North;
        isDetectingCollision = YES;
        isMoving = YES;
        isRotating = NO;
        isBackingUp = NO;
        moveSpeed = 2.0;
        currentYRotation = 0.0;
        targetYRotation = 0.0;
        currentBackupPosition = 0.0;
        targetBackupPosition = 0.0;
        isTurningLeft = NO;
    }
    return self;
}

- (BOOL)checkIfPlayerIsInSameCellAsModel {
    
    int modelX = (int) (on.position.x + 1) / 3;
    int modelZ = (int) (on.position.z) / 3;
    
    int playerX = (int) (self.posX + 1) / 3;
    int playerZ = (int) (self.posZ) / 3;
    
    if(modelX == playerX && modelZ == playerZ) {
        return YES;
    }
    
    return NO;
}

- (void)translateModel:(CGPoint)p{
    NSLog(@"translateModel called");
    if(!_isDoingSomething){
        NSLog(@"called + isDoingSomething");
        on.position = GLKVector3Make(p.x/100, 0, p.y/100);
    }
    
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    [super updateWithDelta:dt];
    if(_isDoingSomething){
        if(isDetectingCollision) {
            PhysicsNode* pn = [physicsWorld checkCollisionAndReturnNode];
            
            if(pn != nil) {
                int tag = [pn.physicsInfo getTag];
                
                switch(tag) {
                    case 0:
                        //NSLog (@"zero");
                        break;
                    case 1:
                    {
                        //NSLog (@"one");
                        isMoving = NO;
                        //isRotating = YES;
                        //targetYRotation -= 90.0;
                        isDetectingCollision = NO;
                        isBackingUp = YES;
                        
                        switch(direction) {
                            case 0:
                                targetBackupPosition = on.position.z - on.depth / 4; //-
                                break;
                            case 1:
                                targetBackupPosition = on.position.x + on.depth / 4; //+
                                break;
                            case 2:
                                targetBackupPosition = on.position.z + on.depth / 4; //+
                                break;
                            case 3:
                                targetBackupPosition = on.position.x - on.depth / 4; // =
                                break;
                            default:
                                NSLog (@"Collision error");
                                break;
                        }
                        
                        break;
                    }
                    case 2:
                        //NSLog (@"two");
                        break;
                    case 99:
                        //NSLog (@"99");
                        break;
                    default:
                        NSLog (@"Collision tag error");
                        break;
                }
            }
        }
        
        
        
        if(isRotating) {
            if(isTurningLeft) {
                
                if(currentYRotation < targetYRotation) {
                    currentYRotation += (moveSpeed * 20.0) * dt;
                    on.rotationY = GLKMathDegreesToRadians(currentYRotation);
                } else {
                    currentYRotation = targetYRotation;
                    on.rotationY = GLKMathDegreesToRadians(currentYRotation);
                    isRotating = NO;
                    isMoving = YES;
                    isDetectingCollision = YES;
                    
                    if(direction != 0) {
                        direction--;
                    } else {
                        direction = 3;
                    }
                    
                    //[self chooseRandomDirection];
                    
                    //NSLog(@"changing direction: %i", direction);
                }
                
                
            } else {
                
                if(currentYRotation > targetYRotation) {
                    currentYRotation -= (moveSpeed * 20.0) * dt;
                    on.rotationY = GLKMathDegreesToRadians(currentYRotation);
                } else {
                    currentYRotation = targetYRotation;
                    on.rotationY = GLKMathDegreesToRadians(currentYRotation);
                    isRotating = NO;
                    isMoving = YES;
                    isDetectingCollision = YES;
                    
                    if(direction != 3) {
                        direction++;
                    } else {
                        direction = 0;
                    }
                    
                }
                
            }
        }
        
        if(isMoving) {
            switch(direction) {
                case 0:
                    //NSLog (@"north");
                    on.position = GLKVector3Make(on.position.x, on.position.y, on.position.z + moveSpeed * dt);
                    break;
                case 1:
                    //NSLog (@"east");
                    
                    on.position = GLKVector3Make(on.position.x - moveSpeed * dt, on.position.y, on.position.z);
                    break;
                case 2:
                    //NSLog (@"south");
                    on.position = GLKVector3Make(on.position.x, on.position.y, on.position.z - moveSpeed * dt);
                    break;
                case 3:
                    //NSLog (@"west");
                    on.position = GLKVector3Make(on.position.x + moveSpeed * dt, on.position.y, on.position.z);
                    break;
                default:
                    NSLog (@"Collision tag error");
                    break;
            }
        }
        
        if(isBackingUp) {
            switch(direction) {
                case 0:
                {
                    if(on.position.z > targetBackupPosition) {
                        on.position = GLKVector3Make(on.position.x, on.position.y, on.position.z - moveSpeed * dt);
                    } else {
                        on.position = GLKVector3Make(on.position.x, on.position.y, targetBackupPosition);
                        isBackingUp = NO;
                        isRotating = YES;
                        [self chooseRandomDirection];
                        //targetYRotation -= 90.0;
                        //isMoving = YES;
                        //isDetectingCollision = YES;
                    }
                    //on.position = GLKVector3Make(on.position.x, on.position.y, on.position.z - moveSpeed * dt);
                    break;
                }
                case 1:
                    
                    if(on.position.x < targetBackupPosition) {
                        on.position = GLKVector3Make(on.position.x + moveSpeed * dt, on.position.y, on.position.z);
                    } else {
                        on.position = GLKVector3Make(targetBackupPosition, on.position.y, on.position.z);
                        isBackingUp = NO;
                        isRotating = YES;
                        [self chooseRandomDirection];
                        //targetYRotation -= 90.0;
                        //isMoving = YES;
                        //isDetectingCollision = YES;
                    }
                    
                    //on.position = GLKVector3Make(on.position.x + moveSpeed * dt, on.position.y, on.position.z);
                    break;
                case 2:
                    if(on.position.z < targetBackupPosition) {
                        on.position = GLKVector3Make(on.position.x, on.position.y, on.position.z + moveSpeed * dt);
                    } else {
                        on.position = GLKVector3Make(on.position.x, on.position.y, targetBackupPosition);
                        isBackingUp = NO;
                        isRotating = YES;
                        [self chooseRandomDirection];
                        //targetYRotation -= 90.0;
                        //isMoving = YES;
                        //isDetectingCollision = YES;
                    }
                    
                    //on.position = GLKVector3Make(on.position.x, on.position.y, on.position.z + moveSpeed * dt);
                    break;
                case 3:
                    if(on.position.x > targetBackupPosition) {
                        on.position = GLKVector3Make(on.position.x - moveSpeed * dt, on.position.y, on.position.z);
                    } else {
                        on.position = GLKVector3Make(targetBackupPosition, on.position.y, on.position.z);
                        isBackingUp = NO;
                        isRotating = YES;
                        [self chooseRandomDirection];
                        //targetYRotation -= 90.0;
                        //isMoving = YES;
                        //isDetectingCollision = YES;
                    }
                    //on.position = GLKVector3Make(on.position.x - moveSpeed * dt, on.position.y, on.position.z);
                    break;
                default:
                    NSLog (@"Collision tag error");
                    break;
            }
        }
    }
    
}

- (void)chooseRandomDirection {
    int i = arc4random() % 2;
    
    if(i == 0) {
        targetYRotation -= 90.0;
        isTurningLeft = NO;
       /* if(direction != 3) {
            direction++;
        } else {
            direction = 0;
        }*/
        
        
        
    } else {
        targetYRotation += 90.0;
        isTurningLeft = YES;
       /* if(direction != 0) {
            direction--;
        } else {
            direction = 3;
        }*/
    }
    
    //NSLog(@"c: %f, t: %f", currentYRotation, targetYRotation);
}

- (void)toggleView {
    if(isBirdsEye) {
        self.position = savePosition;
        self.rotationX = saveRotation.x;

        self.rotationY = saveRotation.y;
        self.rotationZ = saveRotation.z;
        isBirdsEye = NO;
    } else {
        savePosition = self.position;
        saveRotation = GLKVector3Make(self.rotationX, self.rotationY, self.rotationZ);
        
        self.position = GLKVector3Make(-10, -9, 15);
        self.rotationX = GLKMathDegreesToRadians(-70);
        self.rotationY = GLKMathDegreesToRadians(0);
        self.rotationZ = GLKMathDegreesToRadians(0);

        isBirdsEye = YES;
    }

    
    
}


- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix {
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    
    [super renderWithParentModelViewMatrix:parentModelViewMatrix];

    //lineRenderer.modelViewMatrix = modelViewMatrix;
    //[lineRenderer prepareToDraw];
    //[physicsWorld debugDraw];
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
    
    //NSLog(@"%f, %f",self.posX, self.posZ);
    
    int playerX = (int) (self.posX + 1) / 3;
    int playerY = (int) (self.posZ) / 3;

    NSLog(@"%i, %i", playerX, playerY);
    
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
