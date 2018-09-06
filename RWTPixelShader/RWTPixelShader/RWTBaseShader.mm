//
//  RWTBaseShader.m
//  RWTPixelShader
//
//  Created by Ricardo on 3/23/14.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

#import "RWTBaseShader.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/gltypes.h>
#import <OpenGLES/ES2/glext.h>
static GLfloat const RWTBaseShaderQuad[8] = {

  -1.f, -1.f,
  -1.f, +1.f,
  +1.f, -1.f,
  +1.f, +1.f,
};

@interface RWTBaseShader ()

// Program Handle
@property (assign, nonatomic, readonly) GLuint program;

// Attribute Handles
@property (assign, nonatomic, readonly) GLuint aPosition;

// Uniform Handles
@property (assign, nonatomic, readonly) GLuint uResolution;
@property (assign, nonatomic, readonly) GLuint uTime;


@property (assign, nonatomic, readonly) GLuint __index1;
@property (assign, nonatomic, readonly) GLuint __index2;
@property (assign, nonatomic, readonly) GLuint __index3;
@property (assign, nonatomic, readonly) GLuint __shaderType;
@property (assign, nonatomic, readonly) GLuint __r;
@property (assign, nonatomic, readonly) GLuint __g;
@property (assign, nonatomic, readonly) GLuint __b;

@end

@implementation RWTBaseShader

#pragma mark - Lifecycle
- (instancetype)initWithVertexShader:(NSString *)vsh fragmentShader:(NSString *)fsh {
  self = [super init];
  if (self) {
    // Program
    _program = [self programWithVertexShader:vsh fragmentShader:fsh];
    
    // Attributes
    _aPosition = glGetAttribLocation(_program, "aPosition");
    
    // Uniforms
    _uResolution = glGetUniformLocation(_program, "uResolution");
    _uTime = glGetUniformLocation(_program, "uTime");
    
      ___index1 = glGetUniformLocation(_program, "index1");
      ___index2 = glGetUniformLocation(_program, "index2");
      ___index3 = glGetUniformLocation(_program, "index3");
      ___shaderType = 0;
      ___r = glGetUniformLocation(_program, "r");
      ___g = glGetUniformLocation(_program, "g");
      ___b = glGetUniformLocation(_program, "b");
      ___shaderType = glGetUniformLocation(_program, "ShaderType");
      self.index1 = 0;
      self.index2 = 1;
      self.index3 = 2;
      self.r = 0.4;
      self.g = 0.6;
      self.b = 0.8;
    // Configure OpenGL ES
    [self configureOpenGLES];
  }
  return self;
}

#pragma mark - Public
#pragma mark - Render
- (void)renderInRect:(CGRect)rect atTime:(NSTimeInterval)time {
  // Uniforms
    glViewport(50, 50, 350, 350);
  glUniform2f(self.uResolution, 350, 350);
  glUniform1f(self.uTime, time);
    
    glUniform1i(self.__index1, self.index1);
    glUniform1i(self.__index2, self.index2);
    glUniform1i(self.__index3, self.index3);
    glUniform1i(self.__shaderType, self.shaderType);
    glUniform1f(self.__r, self.r);
    glUniform1f(self.__g, self.g);
    glUniform1f(self.__b, self.b);
  
  // Draw
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);

    if(self.captureImage){
        self.captureImage = NO;
        [self captureIconImage];
    }
}

-(void)captureIconImage{
    CGFloat imageWidth = 350;
    CGFloat imageHeight = 350;
    CGFloat length = imageWidth * imageHeight * 4;
    GLubyte *effectData = (GLubyte *)calloc(length, sizeof(GLubyte *));
    glReadPixels(50, 50, 350, 350, GL_BGRA, GL_UNSIGNED_BYTE, effectData);
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, effectData, length, NULL);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * imageWidth;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, bitsPerComponent,
                                        bitsPerPixel, bytesPerRow, colorSpaceRef,
                                        bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpaceRef);
    [self.captureDelegate captureImage:myImage];
}

#pragma mark - Private
#pragma mark - Configurations
- (void)configureOpenGLES {
  // Program
    
  glUseProgram(_program);
  
  // Attributes
  glEnableVertexAttribArray(_aPosition);
  glVertexAttribPointer(_aPosition, 2, GL_FLOAT, GL_FALSE, 0, RWTBaseShaderQuad);
}

#pragma mark - Compile & Link
- (GLuint)programWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh {
  // Build shaders
  GLuint vertexShader = [self shaderWithName:vsh type:GL_VERTEX_SHADER];
  GLuint fragmentShader = [self shaderWithName:fsh type:GL_FRAGMENT_SHADER];
  
  // Create program
  GLuint programHandle = glCreateProgram();
  
  // Attach shaders
  glAttachShader(programHandle, vertexShader);
  glAttachShader(programHandle, fragmentShader);
  
  // Link program
  glLinkProgram(programHandle);
  
  // Check for errors
  GLint linkSuccess;
  glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
  if (linkSuccess == GL_FALSE) {
    GLchar messages[1024];
    glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
    NSLog(@"%@:- GLSL Program Error: %s", [self class], messages);
  }
  
  // Delete shaders
  glDeleteShader(vertexShader);
  glDeleteShader(fragmentShader);
  
  return programHandle;
}

- (GLuint)shaderWithName:(NSString*)name type:(GLenum)type {
  // Load the shader file
  NSString* file;
  if (type == GL_VERTEX_SHADER) {
    file = [[NSBundle mainBundle] pathForResource:name ofType:@"vsh"];
  } else if (type == GL_FRAGMENT_SHADER) {
    file = [[NSBundle mainBundle] pathForResource:name ofType:@"fsh"];
  }
  
  // Create the shader source
  const GLchar* source = (GLchar*)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
  
  // Create the shader object
  GLuint shaderHandle = glCreateShader(type);
  
  // Load the shader source
  glShaderSource(shaderHandle, 1, &source, 0);
  
  // Compile the shader
  glCompileShader(shaderHandle);
  
  // Check for errors
  GLint compileSuccess;
  glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
  if (compileSuccess == GL_FALSE) {
    GLchar messages[1024];
    glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
    NSLog(@"%@:- GLSL Shader Error: %s", [self class], messages);
  }
  
  return shaderHandle;
}

@end
