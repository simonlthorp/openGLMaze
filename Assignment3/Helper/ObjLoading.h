//
//  ObjLoading.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-29.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface ObjLoading : NSObject

@property (nonatomic, strong) NSMutableArray *vertexDataArray;
@property (nonatomic, strong) NSMutableArray *indexDataArray;

- (id)init;
- (void)loadObjFromFile:(NSString *)filename;
- (void)readVertex:(NSString *)line;
- (void)readTexture:(NSString *)line;
- (void)readNormal:(NSString *)line;
- (void)readFaces:(NSString *)line;

@end
