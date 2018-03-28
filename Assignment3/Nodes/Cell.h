//
//  Cell.h
//  COMP 8051 - Assignment 2
//
//  Created by Ryan Dieno on 2018-03-10.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Wall.h"
#import "Node.h"
#import "Cube.h"

@interface Cell : NSObject

@property (nonatomic, assign) BOOL visited;
@property (nonatomic, strong) Wall *north;
@property (nonatomic, strong) Wall *east;
@property (nonatomic, strong) Wall *west;
@property (nonatomic, strong) Wall *south;
@property (nonatomic, strong) Cube *floor;

-(id)init;
-(void)createFloorAndAddToParentNode:(Node *)parent andShader:(Renderer *)shader;

@end
