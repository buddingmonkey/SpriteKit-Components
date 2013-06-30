//
//  SpriteKitBehavior.h
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SKComponentPerformSelector(component, selectorName)  \
    if((component).enabled && [(component) respondsToSelector:@selector(selectorName)]) { \
        [(component) selectorName]; \
    }

#define SKComponentPerformSelectorWithObject(component, selectorName, object)  \
    if((component).enabled && [(component) respondsToSelector:@selector(selectorName:)]) { \
        [(component) selectorName:object]; \
    }

@protocol SKComponent <NSObject>

@property (nonatomic, readwrite) BOOL enabled;
@property (nonatomic, weak) SKNode *node;

@optional
- (void)start;
- (void)onEnter;
- (void)onExit;

- (void)didEvaluateActions;

- (void)didSimulatePhysics;
- (void)didBeginContact:(SKPhysicsContact *)contact;
- (void)didEndContact:(SKPhysicsContact *)contact;

- (void)onSelect;

- (void)update:(CFTimeInterval)deltaTime;

@end
