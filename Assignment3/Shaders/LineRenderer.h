//
//  Renderer.h
//  Model
//
//  Created by Ryan Dieno on 2018-02-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;

@interface LineRenderer : NSObject

@property (nonatomic, assign) GLuint programHandle;
@property (nonatomic, assign) GLKMatrix4 modelViewMatrix;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;

- (id)initWithVertexShader:(NSString *)vertexShader
            fragmentShader:(NSString *)fragmentShader;
- (void)prepareToDraw;

@end
