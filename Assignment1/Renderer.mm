//
//  Renderer.m
//  Assignment1
//
//  Created by Simon on 2/12/18.
//  Copyright © 2018 Simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renderer.h"
#import <GLKit/GLKit.h>
#include <chrono>
#include "GLESRenderer.hpp"

enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    UNIFORM_PASSTHROUGH,
    UNIFORM_SHADEINFRAG,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

//Attribute Index
enum
{
    ATRIB_VERTEX,
    ATRIB_NORMAL,
    NUM_ATTRIBUTES
};

@interface Renderer()
{
    GLKView *theView;
    GLESRenderer glesRenderer;
    GLuint programObject;
    std::chrono::time_point<std::chrono::steady_clock> lastTime;
    
    GLKMatrix4 mvp;
    GLKMatrix3 normalMatrix;
    
    float rotAngle;
    char isRotating;
    
    float *vertices, *normals, *texCoords;
    int *indices, numIndices;
    
    //GLKVector2  _translationStart;
    //GLKVector2  _translationEnd;
    
    float xTranslate;
    float yTranslate;
    bool isTranslating;
    
    float rotAxisY;
    float rotAxisX;
    bool isDragging;
    
    float scale;
    bool isPinching;
    
}

@end

@implementation Renderer

- (void)toggleRotate
{
    isRotating = !isRotating;
}

- (float)getXTranslate{
    return xTranslate;
}
- (float)getYTranslate{
    return yTranslate;
}
- (float)getRotAxisX{
    return rotAxisX;
}
- (float)getRotAxisY{
    return rotAxisY;
}

- (void)rotate: (CGPoint)p{
    if(!isRotating){
        rotAxisY = p.x/100;
        rotAxisX = p.y/100;
        
    }
    
}

- (void)zoom:(float)s{
    if(!isRotating){
        scale = s;
    }
   
}

- (void)reset{
    xTranslate = 0;
    yTranslate = 0;
    scale = 1;
    rotAxisY = 0;
    rotAxisX = 0;
}



- (void)translate:(CGPoint)p
{
    //t = GLKVector2MultiplyScalar(t, m);
    
    //float dx = _translationEnd.x + (t.x-_translationStart.x);
    //float dy = _translationEnd.y - (t.y-_translationStart.y);
    
    //_translationEnd = GLKVector2Make(dx, dy);
    //_translationStart = GLKVector2Make(t.x, t.y);
    if(!isRotating){
        xTranslate = p.x/100;
        yTranslate = -p.y/100;
        
        isTranslating = true;
    }
    
}

- (void)dealloc
{
    glDeleteProgram(programObject);
    
}

- (void)loadModels
{
    numIndices = glesRenderer.GenCube(1.0f, &vertices, &normals, &texCoords, &indices);
}

- (void)setup:(GLKView *)view
{
    
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if(!view.context){
        NSLog(@"Failed to create ES Context");
    }
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    theView = view;
    [EAGLContext setCurrentContext:view.context];
    
    if (![self setupShaders])
    {
        return;
    }
    

    scale = 1.0;
    isRotating = 1;
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glEnable(GL_DEPTH_TEST);
    lastTime = std::chrono::steady_clock::now();
    
}

- (void)update
{
    auto currentTime = std::chrono::steady_clock::now();
    auto elapsedTime = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastTime).count();
    lastTime = currentTime;
    
    
    
    //Perspective
    
    mvp = GLKMatrix4Translate(GLKMatrix4Identity, xTranslate, yTranslate, -5.0);
    
    if(isRotating)
    {
        rotAxisY += 0.001f * elapsedTime;
        if(rotAxisY >= 360.0f){
            rotAxisY = 0.0f;
        }
    }
    
    if(rotAxisY >= 6.28319f){
        rotAxisY = 0.0f;
    }
    if(rotAxisX >= 6.28319f){
        rotAxisX = 0.0f;
    }
    
    mvp = GLKMatrix4Rotate(mvp, rotAxisX, 1.0, 0.0, 0.0);
    mvp = GLKMatrix4Rotate(mvp, rotAxisY, 0.0, 1.0, 0.0);
   

    mvp = GLKMatrix4Scale(mvp, scale, scale, scale);

    
    
    
    normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(mvp), NULL);
    float asppect = (float)theView.drawableWidth / (float)theView.drawableHeight;
    GLKMatrix4 perspective = GLKMatrix4MakePerspective(60.0f * M_PI / 180.0f, asppect, 1.0f, 20.0f);
    
    mvp = GLKMatrix4Multiply(perspective, mvp);
    
}

- (void)draw:(CGRect)drawRect;
{
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *) mvp.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
    glUniform1i(uniforms[UNIFORM_PASSTHROUGH], false);
    glUniform1i(uniforms[UNIFORM_SHADEINFRAG], true);
    
    glViewport(0, 0, (int)theView.drawableWidth, (int)theView.drawableHeight);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glUseProgram(programObject);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3* sizeof(GLfloat), vertices);
    glEnableVertexAttribArray(0);
    glVertexAttrib4f(1, 1.0f, 0.0f, 0.0f, 0.0f);
    glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), normals);
    glEnableVertexAttribArray(2);
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, FALSE, (const float *)mvp.m);
    glDrawElements(GL_TRIANGLES, numIndices, GL_UNSIGNED_INT, indices);
}

- (bool)setupShaders
{
    //load shaders
    char *vShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:
                     [[NSString stringWithUTF8String:"Shader.vsh"] stringByDeletingPathExtension] ofType:
                     [[NSString stringWithUTF8String:"Shader.vsh"] pathExtension]] cStringUsingEncoding:1]);
    char *fShaderStr = glesRenderer.LoadShaderFile([[[NSBundle mainBundle] pathForResource:
                     [[NSString stringWithUTF8String:"Shader.fsh"] stringByDeletingPathExtension] ofType:
                     [[NSString stringWithUTF8String:"Shader.fsh"] pathExtension]] cStringUsingEncoding:1]);
    programObject = glesRenderer.LoadProgram(vShaderStr, fShaderStr);
    
    if(programObject == 0)
    {
        return false;
    }
    
    // Setup Uniform Variables
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(programObject, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(programObject, "normalMatrix");
    uniforms[UNIFORM_PASSTHROUGH] = glGetUniformLocation(programObject, "passthrough");
    uniforms[UNIFORM_SHADEINFRAG] = glGetUniformLocation(programObject, "shadeInFrag");
    
    return true;
}

@end




















