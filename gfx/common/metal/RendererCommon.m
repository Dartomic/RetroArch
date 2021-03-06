//
//  RendererCommon.m
//  MetalRenderer
//
//  Created by Stuart Carnie on 6/3/18.
//  Copyright © 2018 Stuart Carnie. All rights reserved.
//

#import "RendererCommon.h"
#import <Metal/Metal.h>

NSUInteger RPixelFormatToBPP(RPixelFormat format)
{
    switch (format)
    {
        case RPixelFormatBGRA8Unorm:
        case RPixelFormatBGRX8Unorm:
            return 4;
            
        case RPixelFormatB5G6R5Unorm:
        case RPixelFormatBGRA4Unorm:
            return 2;
            
        default:
            NSLog(@"Unknown format %ld", format);
            abort();
    }
}

static NSString * RPixelStrings[RPixelFormatCount];

NSString *NSStringFromRPixelFormat(RPixelFormat format)
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#define STRING(literal) RPixelStrings[literal] = @#literal
        STRING(RPixelFormatInvalid);
        STRING(RPixelFormatB5G6R5Unorm);
        STRING(RPixelFormatBGRA4Unorm);
        STRING(RPixelFormatBGRA8Unorm);
        STRING(RPixelFormatBGRX8Unorm);
#undef STRING
        
    });
    
    if (format >= RPixelFormatCount)
    {
        format = 0;
    }
    
    return RPixelStrings[format];
}

matrix_float4x4 matrix_proj_ortho(float left, float right, float top, float bottom)
{
   float near = 0;
   float far = 1;
   
   float sx = 2 / (right - left);
   float sy = 2 / (top - bottom);
   float sz = 1 / (far - near);
   float tx = (right + left) / (left - right);
   float ty = (top + bottom) / (bottom - top);
   float tz = near / (far - near);
   
   vector_float4 P = {sx, 0, 0, 0};
   vector_float4 Q = {0, sy, 0, 0};
   vector_float4 R = {0, 0, sz, 0};
   vector_float4 S = {tx, ty, tz, 1};
   
   matrix_float4x4 mat = {P, Q, R, S};
   return mat;
}
