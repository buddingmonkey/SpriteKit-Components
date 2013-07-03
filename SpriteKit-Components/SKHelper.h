//
//  Utilities.h
//  Reentry
//
//  Created by Levi on 6/12/13.
//  Copyright (c) 2013 Booz Allen Hamilton. All rights reserved.
//

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