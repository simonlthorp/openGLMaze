//
//  VertexObject.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface VertexObject : NSObject

@property (nonatomic, assign) GLfloat x;
@property (nonatomic, assign) GLfloat y;
@property (nonatomic, assign) GLfloat z;

@property (nonatomic, assign) GLfloat r;
@property (nonatomic, assign) GLfloat g;
@property (nonatomic, assign) GLfloat b;
@property (nonatomic, assign) GLfloat a;

@property (nonatomic, assign) GLfloat u;
@property (nonatomic, assign) GLfloat v;

@property (nonatomic, assign) GLfloat nx;
@property (nonatomic, assign) GLfloat ny;
@property (nonatomic, assign) GLfloat nz;

-(id)initWithVertex:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z
                  R:(GLfloat)r G:(GLfloat)g B:(GLfloat)b A:(GLfloat)a
                  U:(GLfloat)u V:(GLfloat)v
                 NX:(GLfloat)nx NY:(GLfloat)ny NZ:(GLfloat)nz;

-(id)initWithVertex:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z;

@end
