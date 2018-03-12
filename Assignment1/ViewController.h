//
//  ViewController.h
//  Assignment1
//
//  Created by Simon on 2/9/18.
//  Copyright © 2018 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Renderer.h"
#import "MixTest.h"

@interface ViewController : GLKViewController{
    MixTest *theObject;
}

@property (strong, nonatomic) Renderer* renderer;

@end

