//
//  RWTViewController.m
//  RWTPixelShader
//
//  Created by Ricardo on 3/23/14.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

#import "RWTViewController.h"
#import "RWTBaseShader.h"

@interface RWTViewController ()<GLCaptureIcon>{
    int count;
}

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
    self.shader.captureDelegate = self;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  glClear(GL_COLOR_BUFFER_BIT);
  
  [self.shader renderInRect:rect atTime:self.timeSinceFirstResume];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view  endEditing:YES];
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

- (IBAction)generateImage:(id)sender {
    self.shader.captureImage = YES;
}
- (IBAction)shaderType:(UITextField *)sender {
    int type = (int) sender.text.integerValue;
    self.shader.shaderType = type;
}
-(void)captureImage:(UIImage *)imageIcon{
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *documentPath = [rootPath stringByAppendingPathComponent:@"brush_gradient.json"];
    NSString *imageName = [self getImageName];
    NSString *imagePath = [rootPath stringByAppendingPathComponent:imageName];
    NSData *imageData = UIImageJPEGRepresentation(imageIcon, 0.99);
    if([imageData writeToFile:imagePath atomically:YES])NSLog(@"image icon saved success!!!##@@@");
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentPath]){
        if([[NSFileManager defaultManager] createFileAtPath:documentPath contents:nil attributes:nil]){
            NSLog(@"JSON FILE CREATED");
        }
    }
    NSError *error;
    NSString *oldString = [[NSString alloc] initWithContentsOfFile:documentPath encoding:NSUTF8StringEncoding error:&error];
    if(oldString.length == 0){
        oldString = @"{\"gradien_brush_json\" : [";
    } else{
        oldString = [[oldString stringByReplacingOccurrencesOfString:@"]}" withString:@""] stringByAppendingString:@","];
    }
    
    NSMutableString *newJson = [NSMutableString stringWithFormat:@"{\"brush_id\" : \"brush_%d\",",count++];
    [newJson appendString:[NSString stringWithFormat:@"\"index1\" : \"%d\",",self.shader.index1]];
    [newJson appendString:[NSString stringWithFormat:@"\"index2\" : \"%d\",",self.shader.index2]];
    [newJson appendString:[NSString stringWithFormat:@"\"index3\" : \"%d\",",self.shader.index3]];
    [newJson appendString:[NSString stringWithFormat:@"\"r\" : \"%0.3f\",",self.shader.r]];
   [newJson appendString:[NSString stringWithFormat:@"\"g\" : \"%0.3f\",",self.shader.g]];
    [newJson appendString:[NSString stringWithFormat:@"\"b\" : \"%0.3f\",",self.shader.b]];
    [newJson appendString:[NSString stringWithFormat:@"\"shader_type\" : \"%d\",",0]];
    [newJson appendString:[NSString stringWithFormat:@"\"brush_icon\" : \"%@\"}]}",imageName]];
    oldString = [NSString stringWithFormat:@"%@%@",oldString,newJson];
    NSLog(@"\n\n %@ \n\n",oldString);
    NSData *jsonData = [NSData dataWithBytes:[oldString UTF8String] length:oldString.length];
    if([jsonData writeToFile:documentPath atomically:YES]){
        NSLog(@"json write SUCCESS");
    }
}

-(NSString *)getImageName {
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendFormat:@"0_"];
    [string appendFormat:@"%@", [NSString stringWithFormat:@"%d_%d_%d_%0.3f_%0.3f_%0.3f.jpg",self.shader.index1,
                          self.shader.index2,self.shader.index3,self.shader.r,self.shader.g,self.shader.b]];
    return string;
    
}

@end
