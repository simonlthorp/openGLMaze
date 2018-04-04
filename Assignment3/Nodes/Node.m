//
//  Model.m
//  Model
//
//  Created by Ryan Dieno on 2018-02-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Node.h"
#import "Renderer.h"

@implementation Node
{
    //char *_name;
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    Renderer *_shader;
    
    Vertex *mVertices;
    unsigned int mVertexCount;
}

static int idCounter = 0;

- (instancetype)initWithName:(char *)name shader:(Renderer *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount inidices:(GLuint *)indices indexCount:(unsigned int)indexCount; {
    if ((self = [super init])) {
        
        self.name = name;
        _vertexCount = vertexCount;
        _indexCount = indexCount;
        _shader = shader;
        self.position = GLKVector3Make(0, 0, 0);
        self.rotationX = 0;
        self.rotationY = 0;
        self.rotationZ = 0;
        self.scale = 1.0;
        self.scaleX = 1.0;
        self.scaleY = 1.0;
        self.scaleZ = 1.0;
        self.matColor = GLKVector4Make(1, 1, 1, 1);
        self.children = [NSMutableArray array];
        self.isRotating = NO;
        self.identitier = [self CreateID];
        
        if(vertices != nil) {
            mVertexCount = vertexCount;
            mVertices = vertices;
            [self computeVolume];
        }
        

        
        glGenVertexArraysOES(1, &_vao);
        glBindVertexArrayOES(_vao);
        
        // Generate vertex buffer
        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, vertexCount * sizeof(Vertex), vertices, GL_STATIC_DRAW);
        
        // Generate index buffer
        glGenBuffers(1, &_indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, indexCount * sizeof(GLuint), indices, GL_STATIC_DRAW);
        
        // Enable vertex attributes
        glEnableVertexAttribArray(VertexAttribPosition);
        glVertexAttribPointer(VertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Position));
        glEnableVertexAttribArray(VertexAttribColor);
        glVertexAttribPointer(VertexAttribColor, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Color));
        glEnableVertexAttribArray(VertexAttribTexCoord);
        glVertexAttribPointer(VertexAttribTexCoord, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, TexCoord));
        glEnableVertexAttribArray(VertexAttribNormal);
        glVertexAttribPointer(VertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (const GLvoid *) offsetof(Vertex, Normal));
        
        glBindVertexArrayOES(0);
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        
    }
    return self;
}

-(GLKMatrix4)modelMatrix {
    GLKMatrix4 modelMatrix = GLKMatrix4Identity;
    modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, self.position.z);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationX, 1, 0, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationY, 0, 1, 0);
    modelMatrix = GLKMatrix4Rotate(modelMatrix, self.rotationZ, 0, 0, 1);
    modelMatrix = GLKMatrix4Scale(modelMatrix, self.scaleX * self.scale, self.scaleY * self.scale, self.scaleZ * self.scale);
    return modelMatrix;
}

- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix {
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(parentModelViewMatrix, [self modelMatrix]);
    for(Node *child in self.children) {
        [child renderWithParentModelViewMatrix:modelViewMatrix];
    }
    
    _shader.modelViewMatrix = modelViewMatrix;
    _shader.texture = self.texture;
    _shader.matColor = self.matColor;
    [_shader prepareToDraw];
    
    glBindVertexArrayOES(_vao);
    glDrawElements(GL_TRIANGLES, _indexCount, GL_UNSIGNED_INT, 0);
    glBindVertexArrayOES(0);
    
}

- (void)updateWithDelta:(NSTimeInterval)dt {
    for(Node *child in self.children) {
        [child updateWithDelta:dt];
    }
}

- (void)loadTexture:(NSString *)filename {
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    
    NSDictionary *options = @{ GLKTextureLoaderOriginBottomLeft: @YES };
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
    
    if(info == nil) {
        NSLog(@"Error loading file: %@", error.localizedDescription);
    } else {
        self.texture = info.name;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (int)CreateID {
    [Node incrementIdCounter];
    return [Node idCounter];
}

- (void)computeWidth {
    GLfloat min = mVertices[0].Position[0];
    GLfloat max = mVertices[0].Position[0];
    
    for(int i = 0; i < mVertexCount; i++) {
        GLfloat current = mVertices[i].Position[0];
        
        if(current < min) {
            min = current;
        }
        
        if(current > max) {
            max = current;
        }
    }
    
    self.width = (max - min) * self.scaleX * self.scale;
}

- (void)computeHeight {
    GLfloat min = mVertices[0].Position[1];
    GLfloat max = mVertices[0].Position[1];
    
    for(int i = 0; i < mVertexCount; i++) {
        GLfloat current = mVertices[i].Position[1];
        
        if(current < min) {
            min = current;
        }
        
        if(current > max) {
            max = current;
        }
    }
    
    self.height = (max - min) * self.scaleY * self.scale;
}

- (void)computeDepth {
    GLfloat min = mVertices[0].Position[2];
    GLfloat max = mVertices[0].Position[2];
    
    for(int i = 0; i < mVertexCount; i++) {
        GLfloat current = mVertices[i].Position[2];
        
        if(current < min) {
            min = current;
        }
        
        if(current > max) {
            max = current;
        }
    }
    
    self.depth = (max - min) * self.scaleZ * self.scale;
}

- (void)computeVolume {
    [self computeWidth];
    [self computeHeight];
    [self computeDepth];
}

+ (int) idCounter {
    return idCounter;
}

+ (void) incrementIdCounter {
    idCounter++;
}

@end
