//
//  ViewController.m
//  Model
//
//  Created by Ryan Dieno on 2018-02-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import "ViewController.h"
#import "Vertex.h"
#import "Renderer.h"
#import "MainScene.h"
#import "Director.h"
#import "MixTest.h"

@interface ViewController ()

@end

@implementation ViewController
{
    Renderer *_shader;
    MainScene *_scene;
    MixTest *theObject;
    GLKMatrix4 _viewMatrix;
    float rotationY;
    float translationZ;
}

- (void)setupScene {
    
    [Director sharedInstance].view = self.view;
    [Director sharedInstance].vc = self;
    
    _shader = [[Renderer alloc] initWithVertexShader:@"Shader.vsh" fragmentShader:@"Shader.fsh"];
    _scene = [[MainScene alloc] initWithShader:_shader];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
    
    _viewMatrix = GLKMatrix4Identity;
    rotationY = 0;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;

    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [EAGLContext setCurrentContext:view.context];
    
    [self setupScene];
    
    //theObject = [[MixTest alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(255.0 / 255.0, 188.0 / 255.0, 103.0 / 255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    //GLKMatrix4 viewMatrix = GLKMatrix4Identity;
    //GLKMatrix4 viewMatrix = [_scene viewMatrix];
    [_scene renderWithParentModelViewMatrix:_viewMatrix];
}

-(void) update {
    //_viewMatrix = GLKMatrix4Translate(_viewMatrix, 0, 0, -M_PI * self.timeSinceLastUpdate);
    //_viewMatrix = GLKMatrix4Rotate(_viewMatrix, GLKMathDegreesToRadians(90), 0, 1, 0);


    //_viewMatrix = GLKMatrix4Translate(_viewMatrix,  0, 0, -M_PI_4 * self.timeSinceLastUpdate);
    //_viewMatrix = GLKMatrix4Rotate(_viewMatrix, rotationY, 0, 1, 0);
    
    
    [_scene updateWithDelta:self.timeSinceLastUpdate];
}
- (IBAction)touchesPanned:(UIPanGestureRecognizer *)sender {
    
    const float m = GLKMathDegreesToRadians(0.05f);
    CGPoint rotation = [sender translationInView:self.view];

    rotationY += rotation.x * m;
    translationZ += rotation.y * m;
    
    
    _viewMatrix = GLKMatrix4Rotate(_viewMatrix, rotationY, 0, 1, 0);
    _viewMatrix = GLKMatrix4Translate(_viewMatrix, 0, 0, translationZ);
    rotationY = 0;
    translationZ = 0;

}

@end
