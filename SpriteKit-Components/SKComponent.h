//
//  SKComponent.h
//  SpriteKit-Components
//
//  Created by Andrew Eiche on 6/19/13.
//
//  The MIT License
//
//  Copyright (c) 2013 Andrew Eiche (Birdcage Games, LLC)
//  Copyright (c) 2013 Levi Lansing (ZephLabs, LLC)
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

// standard touchesBegan event, called prior to touchState based events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

// standard touchesMoved event, called prior to touchState based events
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

// standard touchesEnded event, called prior to touchState based events
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

// standard touchesCancelled event, called prior to touchState based events
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
