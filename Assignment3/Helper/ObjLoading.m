//
//  ObjLoading.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-29.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "ObjLoading.h"
#import "SimpleVertex.h"
#import "VertexObject.h"
#import "TextureObject.h"
#import "NormalObject.h"

@implementation ObjLoading {
    BOOL smoothed;
    BOOL calcNormals;
    
    NSMutableArray *vertexArray;
    NSMutableArray *textureArray;
    NSMutableArray *normalArray;
    
    NSMutableDictionary *triangleInt;
    int triangleCount;
}


- (id)init {
    if((self = [super init])) {
        vertexArray = [[NSMutableArray alloc] init];
        textureArray = [[NSMutableArray alloc] init];
        normalArray = [[NSMutableArray alloc] init];
        _vertexDataArray = [[NSMutableArray alloc] init];
        _indexDataArray = [[NSMutableArray alloc] init];
        
        triangleInt = [[NSMutableDictionary alloc] init];
        triangleCount = 0;
        
        smoothed = NO;
        calcNormals = NO;
    }
    return self;
}

-(void)loadObjFromFile:(NSString *)filename {
    [vertexArray removeAllObjects];
    [textureArray removeAllObjects];
    [normalArray removeAllObjects];
    [self.vertexDataArray removeAllObjects];
    [self.indexDataArray removeAllObjects];

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
            } else if([line hasPrefix:@"vn "]) {
                [self readNormal:line];
            } else if([line hasPrefix:@"f "]) {
                [self readFaces:line];
            }
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

- (void)readFaces:(NSString *)line {
    NSArray<NSString *> *strings = [line componentsSeparatedByString:@" "];
    NSMutableArray *stringArray  = [NSMutableArray arrayWithArray:strings];
    [stringArray removeObjectAtIndex:0];
    
    for(int i = 0; i < stringArray.count; i++) {
        NSString *hash = stringArray[i];
        if([triangleInt objectForKey:hash] == nil) {
            [_indexDataArray addObject:[NSNumber numberWithInt:triangleCount]];
            triangleInt[hash] = [NSNumber numberWithInt:triangleCount];
            triangleCount++;
            
            NSArray<NSString *> *faceIndices = [hash componentsSeparatedByString:@"/"];
            
            int vIndex = [faceIndices[0] intValue];
            int vtIndex = [faceIndices[1] intValue];
            int vnIndex = [faceIndices[2] intValue];
            SimpleVertex *vertex = [vertexArray objectAtIndex:vIndex - 1];
            TextureObject *to = [textureArray objectAtIndex:vtIndex - 1];
            NormalObject *no = [normalArray objectAtIndex:vnIndex - 1];
            
            VertexObject *vo = [[VertexObject alloc] initWithVertex:vertex.x Y:vertex.y Z:vertex.z
                                                                  R:0.0 G:0.0 B:0.0 A:1.0
                                                                  U:to.u V:to.v
                                                                 NX:no.nx NY:no.ny NZ:no.nz];
            [_vertexDataArray addObject:vo];
            
        } else {
            int index = [triangleInt[hash] intValue];
            [_indexDataArray addObject:[NSNumber numberWithInt:index]];
        }
    }


}


@end
