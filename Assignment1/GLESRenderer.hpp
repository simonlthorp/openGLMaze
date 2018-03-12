//
//  GLESRenderer.hpp
//  Assignment1
//
//  Created by Simon on 2/12/18.
//  Copyright © 2018 Simon. All rights reserved.
//

#ifndef GLESRenderer_hpp
#define GLESRenderer_hpp

#include <stdlib.h>

#include <OpenGLES/ES3/gl.h>

class GLESRenderer
{
public:
    char *LoadShaderFile(const char *shaderFileName);
    GLuint LoadShader(GLenum type, const char *shaderSrc);
    GLuint LoadProgram(const char *vertShaderSrc, const char *fragShaderSrc);
    
    int GenCube(float scale, float **vertices, float **normals, float **texCoords, int **indices);
};

#endif /* GLESRenderer_hpp */
