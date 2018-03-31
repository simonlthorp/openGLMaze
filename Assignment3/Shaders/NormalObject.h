//
//  NormalObject.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NormalObject : NSObject

@property (nonatomic, assign) float nx;
@property (nonatomic, assign) float ny;
@property (nonatomic, assign) float nz;

-(id)initWithNormalNX:(float)nx NY:(float)ny NZ:(float)nz;

@end
