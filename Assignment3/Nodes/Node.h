//
//  Model.h
//  Model
//
//  Created by Ryan Dieno on 2018-02-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import <OpenGLES/ES2/glext.h>

@class Renderer;
@import GLKit;

@interface Node : NSObject

@property (nonatomic, strong) Renderer *shader;
@property (nonatomic, assign) GLKVector3 position;
@property (nonatomic) float rotationX;
@property (nonatomic) float rotationY;
@property (nonatomic) float rotationZ;
@property (nonatomic) float scale;
@property (nonatomic) float scaleX;
@property (nonatomic) float scaleY;
@property (nonatomic) float scaleZ;
@property (nonatomic) GLuint texture;
@property (assign) GLKVector4 matColor;
@property (assign) float width;
@property (assign) float height;
@property (assign) float depth;
@property (assign) int identitier;
@property (assign) BOOL isRotating;
@property (nonatomic, weak) Node *parent;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, assign) char *name;

- (instancetype)initWithName:(char *)name shader:(Renderer *)shader vertices:(Vertex *)vertices vertexCount:(unsigned int)vertexCount inidices:(GLuint *)indices indexCount:(unsigned int)indexCount;
- (void)renderWithParentModelViewMatrix:(GLKMatrix4)parentModelViewMatrix;
- (void)updateWithDelta:(NSTimeInterval)dt;
- (GLKMatrix4)modelMatrix;
- (void)loadTexture:(NSString *)filename;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (int)CreateID;
- (void)computeWidth;
- (void)computeHeight;
- (void)computeDepth;
- (void)computeVolume;

+ (int) idCounter;
+ (void) incrementIdCounter;

@end
