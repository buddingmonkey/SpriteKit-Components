//
//  SKCNodeIsComponent.m
//  SpriteKit-Components
//
//  Created by Levi on 6/30/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import "SKCNodeIsComponent.h"

@implementation SKCNodeIsComponent
@synthesize node, enabled;

- (void)start {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(start)])
        [(id<SKComponent>)node start];
}

- (void)didEvaluateActions {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(didEvaluateActions)])
        [(id<SKComponent>)node didEvaluateActions];
}

- (void)didSimulatePhysics {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(didSimulatePhysics)])
        [(id<SKComponent>)node didSimulatePhysics];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(didBeginContact:)])
        [(id<SKComponent>)node didBeginContact:contact];
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(didEndContact:)])
        [(id<SKComponent>)node didEndContact:contact];
}

// Nodes get update, onEnter, and onExit automatically

- (void)onSceneSizeChanged:(CGSize)oldSize {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(onSceneSizeChanged:)])
        [(id<SKComponent>)node onSceneSizeChanged:oldSize];
}

- (void)dragStart:(SKCTouchState*)touchState {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(dragStart:)])
        [(id<SKComponent>)node dragStart:touchState];
}

- (void)dragMoved:(SKCTouchState*)touchState {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(dragMoved:)])
        [(id<SKComponent>)node dragMoved:touchState];
}

- (void)dragDropped:(SKCTouchState*)touchState {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(dragDropped:)])
        [(id<SKComponent>)node dragDropped:touchState];
}

- (void)dragCancelled:(SKCTouchState*)touchState {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(dragCancelled:)])
        [(id<SKComponent>)node dragCancelled:touchState];
}

- (void)onTap:(SKCTouchState*)touchState {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(onTap:)])
        [(id<SKComponent>)node onTap:touchState];
}

- (void)onLongPress:(SKCTouchState*)touchState {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(onLongPress:)])
        [(id<SKComponent>)node onLongPress:touchState];
}

- (void)onSelect:(SKCTouchState*)touchState {
    if (((id<SKComponent>*)node).enabled && [node respondsToSelector:@selector(onSelect:)])
        [(id<SKComponent>)node onSelect:touchState];
}


@end
