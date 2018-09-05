//
//  RWTGradient.fsh
//  RWTPixelShader
//
//  Created by Ricardo on 3/23/14.
//  Copyright (c) 2014 RayWenderlich. All rights reserved.
//

// Precision
precision highp float;

// Uniforms
uniform vec2 uResolution;

uniform int index1;
uniform int index2;
uniform int index3;

uniform float r;
uniform float g;
uniform float b;

void main(void) {

    
//        highp  float z = sqrt(0.25 - position.x * position.x - position.y * position.y);
//        z /= 0.35;
//        //highp vec3 normal = normalize(vec3( z, position.y,  position.x) * color.bgr);
//        //highp vec3 normal = normalize(vec3(  position.x, color.r,  position.y) * vec3(z,color.gb));
//        //highp vec3 normal = normalize(vec3( position.y, position.x, color.r) * vec3(color.gb,z));
//        //highp vec3 normal = normalize(vec3( position.y, color.r, position.x) * vec3(color.b,z,color.g));
//        //highp vec3 normal = normalize(vec3(z, color.r, position.y) * vec3(color.b,color.g, position.x));
//        //            highp vec3 normal = normalize(vec3(z, color.r, position.y) + vec3(color.b,color.g, position.x));
//        // highp vec3 normal = normalize(vec3(z, position.x, position.y) + vec3(color.b,color.g,color.r));
//        //highp vec3 normal = normalize(vec3(z, position.y, position.x) / vec3(color.b,color.g,color.r));
//        //highp vec3 normal = normalize(vec3(position.y + 0.3,  position.x,z)* vec3(color.b,color.g, position.x));
//        //            highp vec3 normal = normalize(vec3(position.y,position.x,z)* vec3(color.b,color.g, position.x));
//        //highp vec3 normal = normalize(vec3(position.y,position.y,z)* vec3(color.g,color.g, position.x));
//        //            highp vec3 normal = normalize(vec3(z,position.y,z)* vec3(color.b,color.g, position.x));
//        highp vec3 normal = normalize(vec3(position.x,position.y,z)* vec3(color.b,color.g, z));

    
    vec2 center = vec2(0.6375, 0.6375);
    float radius = 0.475;
    vec2 position = gl_FragCoord.xy / uResolution - center;
//    if (length(position) > radius) {
//        discard;
//    }
    highp float z = sqrt(radius*radius - position.x*position.x - position.y * position.y);
    z /= radius;
    highp float array[3];
    array[0] = position.x;
    array[1] = position.y;
    array[2] = z;
    highp vec3 normal = normalize(vec3(array[index1], array[index2], array[index3]) * vec3(r,g,b));
  gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
}
