//
//  ObjLoader.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-27.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "ObjLoader.h"
#import "SimpleVertex.h"
#import "VertexObject.h"
#import "TextureObject.h"
#import "NormalObject.h"

@import GLKit;

@implementation ObjLoader {
    BOOL smoothed;
    BOOL calcNormals;
    
    NSMutableArray *vertexArray;
    NSMutableArray *textureArray;
    NSMutableArray *normalArray;
}

- (id)init {
    if((self = [super init])) {
        smoothed = YES;
        calcNormals = YES;
    }
    return self;
}

-(void)loadObjFromFile:(NSString *)filename {
    [vertexArray removeAllObjects];
    [textureArray removeAllObjects];
    [normalArray removeAllObjects];
    [self.vertexDataArray removeAllObjects];
    [self.indexDataArray removeAllObjects];
    
    vertexArray = [[NSMutableArray alloc] init];
    textureArray = [[NSMutableArray alloc] init];
    normalArray = [[NSMutableArray alloc] init];
    _vertexDataArray = [[NSMutableArray alloc] init];
    _indexDataArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    if(content == nil) {
        NSLog(@"Error loading file: %@", error.localizedDescription);
    } else {
        NSArray<NSString *> *lines = [content componentsSeparatedByString:@"\n"];
        for(NSString *line in lines) {
            if([line hasPrefix:@"v "]) {
                [self readVertex:line];
            } else if([line hasPrefix:@"vt "]) {
                [self readTexture:line];
            } else if(!calcNormals && [line hasPrefix:@"vn "]) {
                [self readNormal:line];
            } else if([line hasPrefix:@"f "]) {
                [self readFace:line];
            }
        }
        if (calcNormals || normalArray.count == 0) {
            [self calculateNormals];
        }
    }
}

- (void)readVertex:(NSString *)line {
    NSArray<NSString *> *strings = [line componentsSeparatedByString:@" "];
    float x = [strings[1] floatValue];
    float y = [strings[2] floatValue];
    float z = [strings[3] floatValue];
    SimpleVertex *vertex = [[SimpleVertex alloc] initWithVertex:x Y:y Z:z];
    [vertexArray addObject:vertex];
    
    if(smoothed) {
        int vertexIndex = (int) vertexArray.count - 1;
        SimpleVertex *vertex = vertexArray[vertexIndex];
        VertexObject *vo = [[VertexObject alloc] initWithVertex:vertex.x Y:vertex.y Z:vertex.z];
        [_vertexDataArray addObject:vo];
    }
}

- (void)readTexture:(NSString *)line {
    NSArray<NSString *> *strings = [line componentsSeparatedByString:@" "];
    float u = [strings[1] floatValue];
    float v = [strings[2] floatValue];
    TextureObject *to = [[TextureObject alloc] initWithTextureU:u V:v];
    [textureArray addObject:to];
}

- (void)readNormal:(NSString *)line {
    NSArray<NSString *> *strings = [line componentsSeparatedByString:@" "];
    float nx = [strings[1] floatValue];
    float ny = [strings[2] floatValue];
    float nz = [strings[3] floatValue];
    NormalObject *no = [[NormalObject alloc] initWithNormalNX:nx NY:ny NZ:nz];
    [normalArray addObject:no];
}

- (void)readFace:(NSString *)line {
    NSArray<NSString *> *strings = [line componentsSeparatedByString:@" "];
    NSMutableArray *stringArray  = [NSMutableArray arrayWithArray:strings];
    [stringArray removeObjectAtIndex:0];
    
    for(NSString *string in stringArray) {
        NSArray<NSString *> *a = [string componentsSeparatedByString:@"/"];
        
        int vertexIndex = (int) [a[0] integerValue] - 1;
        if(!smoothed) {
            SimpleVertex *vertex = vertexArray[vertexIndex];
            vertexIndex = (int) [_vertexDataArray count];
            VertexObject *vo = [[VertexObject alloc] initWithVertex:vertex.x Y:vertex.y Z:vertex.z];
            [_vertexDataArray addObject:vo];
        }
        
        [_indexDataArray addObject:[NSNumber numberWithInt:vertexIndex]];
        
        if (a.count >= 2) {
            int textureIndex = (int) [a[1] integerValue];
            TextureObject *to = textureArray[textureIndex - 1];
            
            VertexObject *vo = _vertexDataArray[vertexIndex];
            vo.u = to.u;
            vo.v = to.v;
            _vertexDataArray[vertexIndex] = vo;
        }
        
        if(!calcNormals && a.count == 3) {
            int normalIndex = (int) [a[2] integerValue];
            NormalObject *no = normalArray[normalIndex - 1];
            VertexObject *vo = _vertexDataArray[vertexIndex];
            vo.nx += no.nx;
            vo.ny += no.ny;
            vo.nz += no.nz;
            _vertexDataArray[vertexIndex] = vo;
        }
    }
    if(stringArray.count == 4) {
        int count = (int) _indexDataArray.count;
        int i = [_indexDataArray[count - 4] intValue];
        int j = [_indexDataArray[count - 2] intValue];
        
        [_indexDataArray addObject: [NSNumber numberWithInt:i]];
        [_indexDataArray addObject: [NSNumber numberWithInt:j]];
    }
}

- (void)calculateNormals {
    for(int i = 0; i < _indexDataArray.count / 3; i++) {
        int v1Index = [_indexDataArray[i * 3] intValue];
        int v2Index = [_indexDataArray[i * 3 + 1] intValue];
        int v3Index = [_indexDataArray[i * 3 + 2] intValue];
        
        VertexObject *v1 = _vertexDataArray[v1Index];
        VertexObject *v2 = _vertexDataArray[v2Index];
        VertexObject *v3 = _vertexDataArray[v3Index];
        
        GLKVector3 u = GLKVector3Make(v2.x - v1.x,
                                      v2.y - v1.y,
                                      v2.z - v1.z);
        
        GLKVector3 v = GLKVector3Make(v3.x - v1.x,
                                      v3.y - v1.y,
                                      v3.z - v1.z);
        
        GLKVector3 normal = GLKVector3CrossProduct(u, v);
        
        v1.nx += (float) normal.x;
        v1.ny += (float) normal.y;
        v1.nz += (float) normal.z;
        
        v2.nx += (float) normal.x;
        v2.ny += (float) normal.y;
        v2.nz += (float) normal.z;
        
        v3.nx += (float) normal.x;
        v3.ny += (float) normal.y;
        v3.nz += (float) normal.z;
        
        _vertexDataArray[v1Index] = v1;
        _vertexDataArray[v2Index] = v2;
        _vertexDataArray[v3Index] = v3;
    }
}

@end
