//
//  Utilities.m
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

#import <SpriteKit/SpriteKit.h>
#import "SKHelper.h"

@implementation SKShapeNode (SK_Helper)
+ (instancetype)nodeWithPathReleased:(CGPathRef)path {
    SKShapeNode *node = [SKShapeNode node];
    node.path = path;
    CGPathRelease(path);
    return node;
}
+ (instancetype)nodeWithPathReleased:(CGPathRef)path withFillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor {
    SKShapeNode *node = [SKShapeNode node];
    node.path = path;
    node.fillColor = fillColor;
    node.strokeColor = strokeColor;
    CGPathRelease(path);
    return node;
}

@end


#pragma mark - SKEmitterNode Category
@implementation SKEmitterNode (SK_Helper)
+ (instancetype)nodeWithEmitterNamed:(NSString *)emitterFileName {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:emitterFileName ofType:@"sks"]];
}
@end


@implementation SKAction (SK_Helper)
+ (instancetype)runBlock:(dispatch_block_t)block afterDelay:(CFTimeInterval)delay {
    return [SKAction sequence:@[[SKAction waitForDuration:delay], [SKAction runBlock:block]]];
}
@end

CGPoint skpNormalize(CGPoint pt) {
    if (pt.x == 0 && pt.y == 0)
        return CGPointZero;
    float m = sqrtf(pt.x * pt.x + pt.y * pt.y);
    return CGPointMake(pt.x/m, pt.y/m);
}

float skpMagnitude(CGPoint pt) {
    if (pt.x == 0 && pt.y == 0)
        return 0;
    return sqrtf(pt.x * pt.x + pt.y * pt.y);
}

CGPoint skpAdd(CGPoint pt1, CGPoint pt2) {
    return CGPointMake(pt1.x + pt2.x, pt1.y + pt2.y);
}

CGPoint skpSubtract(CGPoint pt1, CGPoint pt2) {
    return CGPointMake(pt1.x - pt2.x, pt1.y - pt2.y);
}

CGPoint skpMultiply(CGPoint pt, float scalar) {
    return CGPointMake(pt.x * scalar, pt.y * scalar);
}
