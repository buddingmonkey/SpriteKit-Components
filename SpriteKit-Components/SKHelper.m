//
//  Utilities.m
//  Reentry
//
//  Created by Levi on 6/12/13.
//  Copyright (c) 2013 Booz Allen Hamilton. All rights reserved.
//

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
