//
//  SKCNodeIsComponent.m
//  SpriteKit-Components
//
//  Created by Levi on 6/30/13.
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


#import "SKCNodeIsComponent.h"

@implementation SKCNodeIsComponent
@synthesize node, enabled;

- (void)awake {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(start)])
        [(id<SKComponent>)node awake];
}

- (void)didEvaluateActions {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(didEvaluateActions)])
        [(id<SKComponent>)node didEvaluateActions];
}

- (void)didSimulatePhysics {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(didSimulatePhysics)])
        [(id<SKComponent>)node didSimulatePhysics];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(didBeginContact:)])
        [(id<SKComponent>)node didBeginContact:contact];
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(didEndContact:)])
        [(id<SKComponent>)node didEndContact:contact];
}

// SKComponentNodes get update, onEnter, and onExit automatically

- (void)onSceneSizeChanged:(CGSize)oldSize {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(onSceneSizeChanged:)])
        [(id<SKComponent>)node onSceneSizeChanged:oldSize];
}

- (void)dragStart:(SKCTouchState*)touchState {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(dragStart:)])
        [(id<SKComponent>)node dragStart:touchState];
}

- (void)dragMoved:(SKCTouchState*)touchState {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(dragMoved:)])
        [(id<SKComponent>)node dragMoved:touchState];
}

- (void)dragDropped:(SKCTouchState*)touchState {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(dragDropped:)])
        [(id<SKComponent>)node dragDropped:touchState];
}

- (void)dragCancelled:(SKCTouchState*)touchState {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(dragCancelled:)])
        [(id<SKComponent>)node dragCancelled:touchState];
}

- (void)onTap:(SKCTouchState*)touchState {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(onTap:)])
        [(id<SKComponent>)node onTap:touchState];
}

- (void)onLongPress:(SKCTouchState*)touchState {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(onLongPress:)])
        [(id<SKComponent>)node onLongPress:touchState];
}

- (void)onSelect:(SKCTouchState*)touchState {
    if (((id<SKComponent>)node).enabled && [node respondsToSelector:@selector(onSelect:)])
        [(id<SKComponent>)node onSelect:touchState];
}

// SKComponentNodes can already override touchBegan/Moved/Ended/Cancelled, so no need to forward

@end
