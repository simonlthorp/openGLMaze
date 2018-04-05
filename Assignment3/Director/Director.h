//
//  RDDirector.h
//  BrickBreaker
//
//  Created by Ryan Dieno on 2018-02-12.
//  Copyright © 2018 Ryan Dieno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"
@import GLKit;

@interface Director : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) ViewController *vc;

@end
