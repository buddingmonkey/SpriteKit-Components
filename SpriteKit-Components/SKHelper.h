//
//  Utilities.h
//  SpriteKit-Components
//
//  Created by Levi on 6/12/13.
//
//  The MIT License
//
//  Copyright (c) 2013 Levi Lansing (ZephLabs, LLC)
//  Copyright (c) 2013 Andrew Eiche (Birdcage Games, LLC)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKShapeNode (SK_Helper)
+ (instancetype)nodeWithPathReleased:(CGPathRef)path;
+ (instancetype)nodeWithPathReleased:(CGPathRef)path withFillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor;
@end

@interface SKEmitterNode (SK_Helper)
+ (instancetype)nodeWithEmitterNamed:(NSString *)emitterFileName;
@end

@interface SKAction (SK_Helper)
+ (instancetype)runBlock:(dispatch_block_t)block afterDelay:(CFTimeInterval)delay;
@end

#define skp CGPointMake
#define skpEquals CGPointEqualToPoint

CGPoint skpNormalize(CGPoint pt);
float skpMagnitude(CGPoint pt);
CGPoint skpAdd(CGPoint pt1, CGPoint pt2);
CGPoint skpSubtract(CGPoint pt1, CGPoint pt2);
CGPoint skpMultiply(CGPoint pt, float scalar);