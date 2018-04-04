//
//  SimpleVertex.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleVertex : NSObject

@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float z;

-(id)initWithVertex:(float)x Y:(float)y Z:(float)z;

@end
