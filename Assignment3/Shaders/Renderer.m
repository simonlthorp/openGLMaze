//
//  Renderer.m
//  Model
//
//  Created by Ryan Dieno on 2018-02-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "Renderer.h"
#import "Vertex.h"

@implementation Renderer
{
    GLuint _programHandle;
    GLuint _modelViewMatrixUniform;
    GLuint _projectionMatrixUniform;
    GLuint _texUniform;
    
    GLuint _matColorUniform;
    GLuint _viewPositionUniform;
    
    GLuint _matSpecularIntensityUniform;
    GLuint _shininessUniform;
    
    GLuint _lightColorUniform;
    GLuint _lightAmbientInstensityUniform;
    GLuint _lightDiffuseIntensityUniform;
    GLuint _lightDirectionUniform;
    
    GLuint _flashlightDirectionUniform;
    GLuint _flashlightPositionUniform;
    GLuint _flashlightCutoffUniform;
    GLuint _flashlightOuterCutoffUniform;

    GLuint _flashlightEnabledUniform;
    
    GLuint _fogEnabledUniform;
    GLuint _fogColorUniform;
    //GLuint _fogModeUniform;
    GLuint _fogStartUniform;
    GLuint _fogEndUniform;
    
    bool isDay;
}

- (void) dayNightToggle{
    isDay = !isDay;
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:nil];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int) [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

- (void)compileVertexShader:(NSString *)vertexShader
             fragmentShader:(NSString *)fragmentShader {
    GLuint vertexShaderName = [self compileShader:vertexShader
                                         withType:GL_VERTEX_SHADER];
    GLuint fragmentShaderName = [self compileShader:fragmentShader
                                           withType:GL_FRAGMENT_SHADER];
    
    _programHandle = glCreateProgram();
    glAttachShader(_programHandle, vertexShaderName);
    glAttachShader(_programHandle, fragmentShaderName);
    
    glBindAttribLocation(_programHandle, VertexAttribPosition, "a_Position");
    glBindAttribLocation(_programHandle, VertexAttribColor, "a_Color");
    glBindAttribLocation(_programHandle, VertexAttribTexCoord, "a_TexCoord");
    glBindAttribLocation(_programHandle, VertexAttribNormal, "a_Normal");
    
    glLinkProgram(_programHandle);
    
    self.modelViewMatrix = GLKMatrix4Identity;
    _modelViewMatrixUniform = glGetUniformLocation(_programHandle, "u_ModelViewMatrix");
    _projectionMatrixUniform = glGetUniformLocation(_programHandle, "u_ProjectionMatrix");
    _texUniform = glGetUniformLocation(_programHandle, "u_Texture");
    
    _matColorUniform = glGetUniformLocation(_programHandle, "u_MatColor");
    
    _viewPositionUniform = glGetUniformLocation(_programHandle, "u_ViewPosition");
    
    _matSpecularIntensityUniform = glGetUniformLocation(_programHandle, "u_MatSpecularIntensity");
    _shininessUniform = glGetUniformLocation(_programHandle, "u_Shininess");
    
    _lightColorUniform = glGetUniformLocation(_programHandle, "u_Light.Color");
    _lightAmbientInstensityUniform = glGetUniformLocation(_programHandle, "u_Light.AmbientIntensity");
    _lightDiffuseIntensityUniform = glGetUniformLocation(_programHandle, "u_Light.DiffuseIntensity");
    _lightDirectionUniform = glGetUniformLocation(_programHandle, "u_Light.Direction");

    _flashlightDirectionUniform = glGetUniformLocation(_programHandle, "u_Spotlight.Direction");
    _flashlightPositionUniform = glGetUniformLocation(_programHandle, "u_Spotlight.Position");
    
    _flashlightCutoffUniform = glGetUniformLocation(_programHandle, "u_Spotlight.Cutoff");
    _flashlightOuterCutoffUniform = glGetUniformLocation(_programHandle, "u_Spotlight.OuterCutoff");
    
    _flashlightEnabledUniform = glGetUniformLocation(_programHandle, "flashlightEnabled");
    
    _fogEnabledUniform = glGetUniformLocation(_programHandle, "fogEnabled");
    _fogColorUniform = glGetUniformLocation(_programHandle, "u_FogColor");
    //_fogModeUniform = glGetUniformLocation(_programHandle, "u_FogMode");
    
    _fogStartUniform = glGetUniformLocation(_programHandle, "u_FogStart");
    _fogEndUniform = glGetUniformLocation(_programHandle, "u_FogEnd");

    
    GLint linkSuccess;
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
}

- (void)prepareToDraw {
    glUseProgram(_programHandle);
    glUniformMatrix4fv(_modelViewMatrixUniform, 1, 0, self.modelViewMatrix.m);
    glUniformMatrix4fv(_projectionMatrixUniform, 1, 0, self.projectionMatrix.m);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.texture);
    glUniform1i(_texUniform, 1);
    
    glUniform4f(_matColorUniform, self.matColor.r, self.matColor.g, self.matColor.b, self.matColor.a);
    
    glUniform3f(_viewPositionUniform, self.cameraPosition.x, self.cameraPosition.y, self.cameraPosition.z);
    
    glUniform1f(_matSpecularIntensityUniform, 0.0);
    glUniform1f(_shininessUniform, 32.0);
    
    glUniform3f(_lightColorUniform, 1, 1, 1);
    
    if(isDay){
        glUniform1f(_lightAmbientInstensityUniform, 0.2);
        glUniform1f(_lightDiffuseIntensityUniform, 1.0);
    }else{
        glUniform1f(_lightAmbientInstensityUniform, 0.2);
        glUniform1f(_lightDiffuseIntensityUniform, 0.2);
    }
    
    
    
    //glUniform1f(_lightDiffuseIntensityUniform, 1.0);
    glUniform3f(_lightDirectionUniform, -0.2f, -1.0f, -0.3f);//directional
    
    glUniform3f(_flashlightDirectionUniform, self.flashlightDirection.x, self.flashlightDirection.y, self.flashlightDirection.z);
    glUniform3f(_flashlightPositionUniform, self.flashlightPosition.x, self.flashlightPosition.y, self.flashlightPosition.z);

    
    if(self.flashlightMode) {
        glUniform1f(_flashlightCutoffUniform, cosf(GLKMathDegreesToRadians(35)));
    } else {
        glUniform1f(_flashlightCutoffUniform, cosf(GLKMathDegreesToRadians(25)));
    }
    
    //glUniform1f(_flashlightCutoffUniform, cosf(GLKMathDegreesToRadians(12.5)));
    //glUniform1f(_flashlightCutoffUniform, cosf(GLKMathDegreesToRadians(17.5)));

    glUniform1i(_flashlightEnabledUniform, self.flashlightEnabled);
    
    glUniform1i(_fogEnabledUniform, self.fogEnabled);
    glUniform3f(_fogColorUniform, 0.2, 0.2, 0.2);
    //glUniform1i(_fogModeUniform, self.fogMode);
    
    if(self.fogMode) {
        glUniform1f(_fogStartUniform, 0.5);
        glUniform1f(_fogEndUniform, 3.0);
    } else {
        glUniform1f(_fogStartUniform, 1.0);
        glUniform1f(_fogEndUniform, 4.0);
    }
}

- (instancetype)initWithVertexShader:(NSString *)vertexShader fragmentShader:
(NSString *)fragmentShader {
    if ((self = [super init])) {
        [self compileVertexShader:vertexShader fragmentShader:fragmentShader];
        self.cameraPosition = GLKVector3Make(0, 0, 0);
        self.flashlightPosition = GLKVector3Make(0, 0, 0);
        self.flashlightDirection = GLKVector3Make(0, 0, -1);
        
        self.flashlightEnabled = NO;
        self.flashlightMode = NO;
        self.fogEnabled = YES;
        self.fogMode = YES;
        isDay = YES;
    }
    return self;
}

@end
