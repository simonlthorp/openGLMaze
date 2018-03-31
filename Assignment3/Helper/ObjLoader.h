//
//  ObjLoader.h
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
@import GLKit;

@interface ObjLoader : NSObject

@property (nonatomic, strong) NSMutableArray *vertexDataArray;
@property (nonatomic, strong) NSMutableArray *indexDataArray;

- (id)init;
- (void)loadObjFromFile:(NSString *)filename;
- (void)readVertex:(NSString *)line;
- (void)readTexture:(NSString *)line;
- (void)readNormal:(NSString *)line;
- (void)readFace:(NSString *)line;
- (void)calculateNormals;

@end
