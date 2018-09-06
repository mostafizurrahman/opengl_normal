//
//  RWTBaseShader.h
//  RWTPixelShader
//
//  Created by Ricardo on 3/23/14.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

@protocol GLCaptureIcon<NSObject>
-(void)captureImage:(UIImage *)imageIcon;
@end

@interface RWTBaseShader : NSObject

- (instancetype)initWithVertexShader:(NSString*)vsh fragmentShader:(NSString*)fsh;
- (void)renderInRect:(CGRect)rect atTime:(NSTimeInterval)time;
@property (readwrite) BOOL captureImage;
@property (readwrite, weak) id<GLCaptureIcon> captureDelegate;
@property (readwrite) int index1, index2, index3;

@property (readwrite) CGFloat r, g, b;
@property (readwrite) int shaderType;

@end
