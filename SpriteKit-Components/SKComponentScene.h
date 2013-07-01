//
//  SKComponentScene.h
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKComponent.h"
#import "SKComponentNode.h"

#define SKComponentSceneForNode(node)   (SKComponentScene*)([(node).scene isKindOfClass:[SKComponentScene class]] ? (node).scene : Nil)


SK_EXPORT @interface SKComponentScene : SKScene <SKPhysicsContactDelegate> {
}

@property (nonatomic) CFTimeInterval dt;

-(void) registerComponentNode:(SKComponentNode*)node;
-(void) unregisterComponentNode:(SKComponentNode*)node;

@end
