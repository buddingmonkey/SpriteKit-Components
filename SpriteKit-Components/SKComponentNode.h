//
//  SKComponentNode.h
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKComponent.h"

#define SKGetComponent(__skComponentNode, __className)  ((__className*)[__skComponentNode getComponent:[__className class]])

void skc_applyOnEnter(SKNode* node);
void skc_applyOnExit(SKNode* node);


SK_EXPORT @interface SKCTouchState : NSObject

@property (nonatomic, weak) UITouch *touch;
@property (nonatomic) CGPoint absoluteTouchStart;
@property (nonatomic) CGPoint touchStart;
@property (nonatomic) CGPoint touchLocation;
@property (nonatomic) BOOL isDragging;
@property (nonatomic) CFTimeInterval touchTime;
@property (nonatomic) BOOL isLongPress;

@end



SK_EXPORT @interface SKComponentNode : SKNode {
}

@property (nonatomic) BOOL hasEnteredScene;
@property (nonatomic) NSMutableOrderedSet* components;
@property (nonatomic) float dragThreshold;
@property (nonatomic) float longPressTime;
@property (nonatomic) SKCTouchState *touchState;


- (BOOL)addComponent:(id<SKComponent>)component withName:(NSString*)name;
- (BOOL)addComponent:(id<SKComponent>)component;

- (void)removeComponent:(id<SKComponent>)component;
- (void)removeComponentWithClass:(Class)className;
- (void)removeComponentWithName:(NSString*)name;

- (id<SKComponent>)getComponent:(Class)componentClass;
- (id<SKComponent>)getComponentWithName:(NSString*)name;

- (void)onEnter;
- (void)onExit;

- (void)update:(CFTimeInterval)dt;

@end
