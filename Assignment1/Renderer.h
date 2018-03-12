//
//  Renderer.h
//  Assignment1
//
//  Created by Simon on 2/12/18.
//  Copyright © 2018 Simon. All rights reserved.
//

#ifndef Renderer_h
#define Renderer_h
#import <GLKit/GLKit.h>

@interface Renderer : NSObject

- (void)setup:(GLKView *)view;
- (void)loadModels;
- (void)update;
- (void)draw:(CGRect)drawRect;
- (void)toggleRotate;
- (void)rotate:(CGPoint)p;
- (void)translate:(CGPoint)p;
- (void)zoom:(float)s;
- (void)reset;

- (float)getXTranslate;
- (float)getYTranslate;
- (float)getRotAxisX;
- (float)getRotAxisY;

@end


#endif /* Renderer_h */
