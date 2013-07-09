//
//  SKComponent.h
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

@class SKCTouchState;

SK_EXPORT @protocol SKComponent <NSObject>

@property (nonatomic, readwrite) BOOL enabled;

@optional
@property (nonatomic, weak) SKNode *node;

@optional
// triggered when the component is added to a component node
- (void)awake;

// when the node is added to the scene
- (void)onEnter;

// when the node is removed from the scene
- (void)onExit;

// called every frame. dt = time since last frame
- (void)update:(CFTimeInterval)dt;

// SpriteKit - forwarded from SKScene
- (void)onSceneSizeChanged:(CGSize)oldSize;

// SpriteKit - forwarded from SKScene
- (void)didEvaluateActions;

#pragma mark -- Physics Handlers --

// SpriteKit - forwarded from SKScene
- (void)didSimulatePhysics;

// SpriteKit - forwarded from SKScene when this node is one of the nodes in contact
- (void)didBeginContact:(SKPhysicsContact *)contact;
- (void)didEndContact:(SKPhysicsContact *)contact;


#pragma mark -- Touch Handlers --

// all touch handlers are only triggered if the tough down is inside the node content area

// called once a touch moves beyond the SKComponentNode dragThreshold (defaults to 4 units)
- (void)dragStart:(SKCTouchState*)touchState;

// called every time a touch moves after dragging has started
- (void)dragMoved:(SKCTouchState*)touchState;

// called on touch up after dragging has started
- (void)dragDropped:(SKCTouchState*)touchState;

// called if the touch is canceled after dragging has started
- (void)dragCancelled:(SKCTouchState*)touchState;


// called on Touch Up if UITouch tap count >= 1 and touch is not classified as dragging or a long touch
- (void)onTap:(SKCTouchState*)touchState;

// called if touch is held for SKComponentNode longPressTime (defaults to 1 second)
// AND touch has not moved beyond dragThreshold
- (void)onLongPress:(SKCTouchState*)touchState;

// equivalent to iOS Touch Up Inside. Typically used for menu items rather than tap
- (void)onSelect:(SKCTouchState*)touchState;

@end
