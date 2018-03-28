//
//  ViewController.h
//  Model
//
//  Created by Ryan Dieno on 2018-02-01.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <OpenGLES/ES2/gl.h>
//#import <OpenGLES/ES2/glext.h>

@import GLKit;

@interface ViewController : GLKViewController

@property (weak, nonatomic) IBOutlet UILabel *MinimapLabel;
@property (weak, nonatomic) IBOutlet UIView *consoleView;

@end

