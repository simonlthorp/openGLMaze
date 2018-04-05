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
#import "LineRenderer.h"

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
    float translationX;
    
    BOOL isBirdsEye;
    
    float saveRotationY;
    float saveTranslationZ;
    float saveTranslationX;
}
- (IBAction)fogMode:(id)sender {
    _shader.fogMode = !_shader.fogMode;
}

- (IBAction)fogButton:(id)sender {
    _shader.fogEnabled = !_shader.fogEnabled;
}

- (IBAction)flashlightButton:(id)sender {
    _shader.flashlightEnabled = !_shader.flashlightEnabled;
}


- (IBAction)dayNightToggleButton:(id)sender {
    [_shader dayNightToggle];
}

- (void)setupScene {
    
    [Director sharedInstance].view = self.view;
    [Director sharedInstance].vc = self;
    
    _shader = [[Renderer alloc] initWithVertexShader:@"Shader.vsh" fragmentShader:@"Shader.fsh"];
    LineRenderer *lineShader = [[LineRenderer alloc] initWithVertexShader:@"LineVertexShader.glsl" fragmentShader:@"LineFragmentShader.glsl"];
    lineShader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
    
    _scene = [[MainScene alloc] initWithShader:_shader andLineShader:lineShader];
    _shader.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(85.0), self.view.bounds.size.width / self.view.bounds.size.height, 1, 150);
    
    _viewMatrix = GLKMatrix4Identity;
    rotationY = GLKMathDegreesToRadians(180.0);
    
    saveRotationY = 0;
    saveTranslationZ = 0.0;
    saveTranslationX = 0.0;
    isBirdsEye = NO;
    
    //translationZ = -5.0;
    
    
}

- (void)setupMinimap {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    GLKView *view = (GLKView *)self.view;

    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    [EAGLContext setCurrentContext:view.context];
    
    [self setupScene];
    
    //theObject = [[MixTest alloc] init];
    _shader.flashlightEnabled = NO;
    _shader.fogEnabled = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(255.0 / 255.0, 188.0 / 255.0, 103.0 / 255.0, 1.0);
    //glClearColor(0.2, 0.2, 0.2, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    //glClearDepthf(1);
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [_scene renderWithParentModelViewMatrix:_viewMatrix];
}

-(void) update {
    _viewMatrix = GLKMatrix4MakeYRotation(rotationY);
    _viewMatrix = GLKMatrix4Translate(_viewMatrix, -translationX, 0, -translationZ);
    
    _scene.posX = translationX;
    _scene.posZ = translationZ;
    _scene.rotY = rotationY;
    
    //_shader.cameraPosition = GLKVector3Make(-translationX, 0, -translationZ);
    //NSLog(@"%f, %f, %f", _shader.cameraPosition.x, _shader.cameraPosition.y, _shader.cameraPosition.z);

    //_shader.flashlightPosition = GLKVector3Make(-translationX, 0, -translationZ);
    //_shader.flashlightDirection = GLKVector3Make(0, rotationY, 0);
    
    [_scene updateWithDelta:self.timeSinceLastUpdate];
    
    
    if([_scene checkIfPlayerIsInSameCellAsModel]) {
        //NSLog(@"yes");
    } else {
        //NSLog(@"no");  
    }
}
    
- (IBAction)touchesPanned:(UIPanGestureRecognizer *)sender {
    CGPoint rotation = [sender translationInView:self.view];
    [sender setTranslation:CGPointZero inView:self.view];
    
    float x = rotation.x / self.view.frame.size.width;
    float y = rotation.y / self.view.frame.size.height;
    
    rotationY += x * 2.0;
    
    if(rotationY > M_PI * 2) {
        rotationY -= M_PI * 2;
    } else if(rotationY < -M_PI * 2) {
        rotationY += M_PI * 2;
    }
    
    translationX -= sin(rotationY) * y * 5.0;
    translationZ += cos(rotationY) * y * 5.0;
}

- (IBAction)twoFingersTapped:(UITapGestureRecognizer *)sender {
    _consoleView.hidden = !_consoleView.hidden;
    [_scene setupMinimap];
}

- (IBAction)rotationSlider:(UISlider *)sender {
    
    [_scene rotateModel:sender.value];
    
}

- (IBAction)moveObject:(UIPanGestureRecognizer *)sender {
    //NSLog(@"moveObject called");
    if([_scene checkIfPlayerIsInSameCellAsModel]){
       // NSLog(@"movebject - player/model in same cell");
        CGPoint p = [sender translationInView:sender.view];
        
        [_scene translateModel:p];
    }
    
}
- (IBAction)scaleObject:(UISlider *)sender {
    
    if([_scene checkIfPlayerIsInSameCellAsModel]){
        
        [_scene scaleModel:sender.value];
        
    }
    
}
- (IBAction)threeFingersDoubleTapped:(id)sender {
    [self toggleObjectMovement:(UIButton *)sender];
}

- (IBAction)toggleObjectMovement:(UIButton *)sender {
    //NSLog(@"toggle object movement");
    if([_scene checkIfPlayerIsInSameCellAsModel]){
        //NSLog(@"toggle object movement - in same cell");
        _scene.isDoingSomething = !_scene.isDoingSomething;
        
    }
    
}

- (IBAction)doubleTapped:(UITapGestureRecognizer *)sender {
    _viewMatrix = GLKMatrix4Identity;
    translationX = 0;
    translationZ = 0;
    rotationY = GLKMathDegreesToRadians(180.0);
}

- (IBAction)viewButtonTapped:(id)sender {
    
    if(isBirdsEye) {
        rotationY = saveRotationY;
        translationZ = saveTranslationZ;
        translationZ = saveTranslationZ;
        isBirdsEye = NO;
    } else {

        saveRotationY = rotationY;
        saveTranslationZ = translationZ;
        saveTranslationX = translationX;
        
        rotationY = GLKMathDegreesToRadians(180.0);
        translationZ = 0.0;
        translationX = 0.0;
        
        isBirdsEye = YES;
    }
    
    [_scene toggleView];
}

-(float)getRotationY {
    return rotationY;
}

@end
