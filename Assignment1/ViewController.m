//
//  ViewController.m
//  Assignment1
//
//  Created by Simon on 2/9/18.
//  Copyright © 2018 Simon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    Renderer *glesRenderer;
    
    bool isCPP;
    
}

@end

@implementation ViewController



- (IBAction)doubleTap:(id)sender {
    
    [glesRenderer toggleRotate];
    
}


- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender {
    
    float f = sender.scale;
    [glesRenderer zoom:f];
}

- (IBAction)dragGesture:(UIPanGestureRecognizer *)sender {
    
    if(sender.numberOfTouches == 1){
        NSLog(@"pan 1 finger");
        CGPoint p = [sender translationInView:sender.view];
        
        [glesRenderer rotate:p];
        //if([sender.state == UIGestureRecognizerStateEnded]){
          //  [glesRenderer endDrag];
        //}
        
    }
    
    if(sender.numberOfTouches == 2){
        NSLog(@"pan 2 finger");
        
        CGPoint p = [sender translationInView:sender.view];

        [glesRenderer translate:p];
    }
    
    
    
}


- (void)viewDidLoad {
    NSLog(@"view did load");
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    glesRenderer = [[Renderer alloc] init];
    GLKView *view = (GLKView *)self.view;
    isCPP = false;
    [glesRenderer setup:view];
    [glesRenderer loadModels];
    theObject = [[MixTest alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update{
    [glesRenderer update];

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [glesRenderer draw:rect];
}

@end
