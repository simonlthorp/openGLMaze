//
//  VertexObject.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "VertexObject.h"

@implementation VertexObject

-(id)initWithVertex:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z
{
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.z = z;
        
        self.r = 0.0;
        self.g = 0.0;
        self.b = 0.0;
        self.a = 0.0;
        
        self.u = 0.0;
        self.v = 0.0;
        
        self.nx = 0.0;
        self.ny = 0.0;
        self.nz = 0.0;
    }
    return self;
}

-(id)initWithVertex:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z
                  R:(GLfloat)r G:(GLfloat)g B:(GLfloat)b A:(GLfloat)a
                  U:(GLfloat)u V:(GLfloat)v
                 NX:(GLfloat)nx NY:(GLfloat)ny NZ:(GLfloat)nz
{
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.z = z;
        
        self.r = r;
        self.g = b;
        self.b = g;
        self.a = a;
        
        self.u = u;
        self.v = v;
        
        self.nx = nx;
        self.ny = ny;
        self.nz = nz;
    }
    return self;
}

@end
