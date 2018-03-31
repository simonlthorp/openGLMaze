//
//  TextureObject.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextureObject : NSObject


@property (nonatomic, assign) float u;
@property (nonatomic, assign) float v;

-(id)initWithTextureU:(float)u V:(float)v;

@end
