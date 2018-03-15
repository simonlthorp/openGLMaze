//
//  Renderer.h
//  Model
//
//  Created by Ryan Dieno on 2018-02-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>



@import GLKit;

@interface Renderer : NSObject

@property (nonatomic, assign) GLuint programHandle;
@property (nonatomic, assign) GLKMatrix4 modelViewMatrix;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
@property (assign) GLuint texture;
@property (assign) GLKVector4 matColor;
@property (assign) GLKVector3 matAmbient;
@property (assign) GLKVector3 matDiffuse;
@property (assign) GLKVector3 matSpecular;
@property (assign) float matShininess;
@property (assign) GLKVector3 flashlightPosition;
@property (assign) GLKVector3 flashlightDirection;
@property (assign) GLKVector3 cameraPosition;
@property (assign) BOOL flashlightEnabled;
@property (assign) BOOL flashlightMode;
@property (assign) BOOL fogEnabled;
@property (assign) BOOL fogMode;
    
- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader;
- (void)prepareToDraw;

@end
