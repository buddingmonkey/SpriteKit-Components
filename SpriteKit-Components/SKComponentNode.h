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

SK_EXPORT @interface SKComponentNode : SKNode {
}

@property (nonatomic) BOOL hasEnteredScene;
@property (nonatomic) NSMutableOrderedSet* components;


- (BOOL)addComponent:(id<SKComponent>)component withName:(NSString*)name;
- (BOOL)addComponent:(id<SKComponent>)component;

- (void)removeComponent:(id<SKComponent>)component;
- (void)removeComponentWithClass:(Class)className;
- (void)removeComponentWithName:(NSString*)name;

- (id<SKComponent>)getComponent:(Class)componentClass;
- (id<SKComponent>)getComponentWithName:(NSString*)name;

- (void)onEnter;
- (void)onExit;

- (void)removeFromParentWithCleanup:(BOOL)cleanup;

@end
