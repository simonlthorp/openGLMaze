//
//  ObjNode.m
//  COMP 8051 - Assignment 3
//
//  Created by Ryan Dieno on 2018-03-28.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "ObjNode.h"
#import "ObjLoader.h"
#import "ObjLoading.h"
#import "VertexObject.h"

@implementation ObjNode {
    int vertexCount;
    int indexCount;
}

- (instancetype)initWithShader:(Renderer *)shader andOBJFile:(NSString *)oFilename andTexture:(NSString *)tFilename; {
    
    //ObjLoader *ol = [[ObjLoader alloc] init];
    ObjLoading *ol = [[ObjLoading alloc] init];
    [ol loadObjFromFile:oFilename];
    
    Vertex *vertices = [self vertexArrayFromVertexObjectArray:ol.vertexDataArray];
    GLuint *indices = [self indexArrayFromIndexObjectArray:ol.indexDataArray];
    
    if ((self = [super initWithName:"OBJNode" shader:shader vertices:vertices vertexCount:vertexCount inidices:indices indexCount:indexCount])) {
        [self loadTexture:tFilename];
    }
    return self;
}

- (Vertex *) vertexArrayFromVertexObjectArray:(NSMutableArray *)voa {
    vertexCount = (int) voa.count;
    Vertex *vertices = malloc(sizeof(Vertex) * vertexCount);

    for(int i = 0; i < vertexCount; i++) {
        VertexObject *vo = [voa objectAtIndex:i];
        
        Vertex vert = {{vo.x, vo.y, vo.z}, {vo.r, vo.g, vo.b, vo.a}, {vo.u, vo.v}, {vo.nx, vo.ny, vo.nz}};
        vertices[i] = vert;
    }
    
    return vertices;
}

- (GLuint *) indexArrayFromIndexObjectArray:(NSMutableArray *)ioa {
    indexCount = (int) ioa.count;
    GLuint *indices = malloc(sizeof(GLuint) * indexCount);
    
    for(int i = 0; i < indexCount; i++) {
        unsigned int p = [[ioa objectAtIndex:i] intValue];
        GLuint test = (GLuint) p;
        indices[i] = test;
        //indices[i] = (GLubyte) [[ioa objectAtIndex:i] intValue];
    }
    
    return indices;
}

@end
