//
//  RWTViewController.m
//  RWTPixelShader
//
//  Created by Ricardo on 3/23/14.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

#import "RWTViewController.h"
#import "RWTBaseShader.h"

@interface RWTViewController ()

// Shader
@property (strong, nonatomic, readwrite) RWTBaseShader* shader;

@end

@implementation RWTViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Set up context
  EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  [EAGLContext setCurrentContext:context];
  
  // Set up view
  GLKView *glkView = (GLKView *)self.view;
  glkView.context = context;
  
  // OpenGL ES settings
  glClearColor(1.0f, 1.f, 1.00f, 1.f);
  
  // Initialize shader
  self.shader = [[RWTBaseShader alloc] initWithVertexShader:@"RWTBase" fragmentShader:@"RWTGradient"];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClear(GL_COLOR_BUFFER_BIT);
  
  [self.shader renderInRect:rect atTime:self.timeSinceFirstResume];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}

- (IBAction)redChange:(UISlider *)sender {
    self.shader.r = sender.value;
    
}

- (IBAction)greenChange:(UISlider *)sender {
    self.shader.g = sender.value;
}

- (IBAction)blueChange:(UISlider *)sender {
    self.shader.b = sender.value;
}
- (IBAction)generateRandomIndex:(id)sender {
    int index = (int)arc4random_uniform(3);
    self.index1.text = [NSString stringWithFormat:@"%d",index];
    self.shader.index1 = index;
    index = (int)arc4random_uniform(3);
    self.index2.text = [NSString stringWithFormat:@"%d",index];
    self.shader.index2 = index;
    index = (int)arc4random_uniform(3);
    self.index3.text = [NSString stringWithFormat:@"%d",index];
    self.shader.index3 = index;
}

@end
