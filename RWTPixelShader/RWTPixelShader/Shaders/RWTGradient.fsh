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
uniform int ShaderType;
uniform float r;
uniform float g;
uniform float b;

void main(void) {

    
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
    highp vec3 color = vec3(r,g,b);
    
    if(ShaderType == 0){
        highp vec3 normal = normalize(vec3(array[index1], array[index2], array[index3]) * vec3(color.b,color.g, z));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
        
    } else if(ShaderType == 1){
        highp vec3 normal = normalize(vec3(array[index1], array[index2], array[index3]) * vec3(color.b,color.g, position.x));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 2){
        highp vec3 normal = normalize(vec3(array[index1], array[index2], array[index3]) * vec3(color.g,color.g, position.x));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 3){
        highp vec3 normal = normalize( vec3(array[index1], array[index2], array[index3]) * vec3(color.b,color.g, position.x));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 4){
        highp vec3 normal = normalize(vec3(array[index1], array[index2] + 0.2, array[index3]) * vec3(color.b,color.g, position.x));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 5){
        highp vec3 normal = normalize(vec3(array[index1], array[index2], array[index3]) / vec3(color.b,color.g,color.r));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 6){
        highp vec3 normal = normalize(vec3(array[index1], array[index2], color.r) + vec3(color.b,color.g, array[index3]));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 7){
        highp vec3 normal = normalize(vec3(array[index1], color.g * color.r, color.r) * vec3(color.b,array[index2], array[index3]));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 8){
        highp vec3 normal = normalize(vec3(array[index1], array[index2], color.r) * vec3(color.b,z,color.g));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 9){
        highp vec3 normal = normalize(vec3(array[index1], array[index2], array[index1]) * color.bgr);
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 10){
        highp vec3 normal = normalize(vec3( position.y * color.g, position.x, color.r) * vec3(color.gb,z));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 11){
        highp vec3 normal = normalize(vec3(  position.x, color.r,  position.y*color.g) * vec3(z,color.gb));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 12){
         highp vec3 normal = normalize(vec3(array[index1] + color.g, array[index2], array[index3] + 0.15) + vec3(color.b,color.g,color.r));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 13){
         highp vec3 normal = normalize(vec3(array[index3], color.g * color.r, color.r) * vec3(color.b,array[index2], array[index3]));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 14){
         highp vec3 normal = normalize(vec3(array[index2], color.g * color.r, color.b * array[index2]) * vec3(color.b + 0.2,array[index2] * color.g, array[index3]));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }else if(ShaderType == 15){
         highp vec3 normal = normalize(vec3(array[index1] *  array[index2], color.g * array[index3], array[index2]) * vec3(color.b,color.b, array[index3]));
        gl_FragColor = vec4((normal+1.0 )/2.0, 1.);
    }
//    highp vec3 normal = normalize(vec3(array[index1], array[index2], array[index3]) * vec3(r,g,b));
    
}
