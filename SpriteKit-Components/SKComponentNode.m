//
//  SKComponentNode.m
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import "SKComponentNode.h"
#import "SKComponentScene.h"

@interface SKComponentNode() {
    NSMutableOrderedSet *componentKeys;
}
@end

@implementation SKComponentNode
@synthesize components=components;
- (id)init
{
    self = [super init];
    if (self) {
        componentKeys = [NSMutableOrderedSet orderedSet];
        components = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (void)dealloc {
    components = Nil;
}

- (BOOL)addComponent:(id<SKComponent>)component withName:(NSString*)name {
    return [self _addComponent:component withKey:name];
}

- (BOOL)addComponent:(id<SKComponent>)component{
    return [self _addComponent:component withKey:(id<NSCopying>)[component class]];
}

- (BOOL)_addComponent:(id<SKComponent>)component withKey:(id<NSCopying>)key {
    if ([componentKeys containsObject:key])
        return NO;
    [components addObject:component];
    [componentKeys addObject:key];
    component.node = self;
    component.enabled = YES;
    SKComponentPerformSelector(component, start);

    return YES;
}

- (void)removeComponent:(id<SKComponent>)component{
    int index = [components indexOfObject:component];
    [self _removeComponentWithKey:[componentKeys objectAtIndex:index]];
}

- (void)removeComponentWithClass:(Class)className {
    [self _removeComponentWithKey:className];
}

- (void)removeComponentWithName:(NSString*)name {
    [self _removeComponentWithKey:name];
}

- (void)_removeComponentWithKey:(id)key {
    int index = [componentKeys indexOfObject:key];
    if (index == NSNotFound) {
        return;
    }
    
    [componentKeys removeObjectAtIndex:index];
    [components removeObjectAtIndex:index];
}


- (id<SKComponent>)getComponentWithName:(NSString*)name {
    int index = [componentKeys indexOfObject:name];
    return [components objectAtIndex:index];
}

- (id<SKComponent>)getComponent:(Class)componentClass {
    int index = [componentKeys indexOfObject:componentClass];
    return [components objectAtIndex:index];
}

- (void)onEnter {
    if (_hasEnteredScene)
        return;

    self.hasEnteredScene = YES;
    
    // register self with scene
    SKComponentScene* scene = SKComponentSceneForNode(self);
    [scene registerComponentNode:self];

    // perform onEnter for all components
    for (id<SKComponent> component in components) {
        SKComponentPerformSelector(component, onEnter);
    }
    
    // notify SKComponent children, recursively
    for (SKNode *node in self.children) {
        skc_applyOnEnter(node);
    }
}

- (void)onExit {
    if (!_hasEnteredScene)
        return;
    
    self.hasEnteredScene = NO;

    // unregister self with scene
    SKComponentScene* scene = SKComponentSceneForNode(self);
    [scene registerComponentNode:self];

    // perform onExit for all components
    for (id<SKComponent> component in components) {
        SKComponentPerformSelector(component, onExit);
    }

    for (SKNode *node in self.children) {
        skc_applyOnExit(node);
    }
}


// recursively run onEnter on all SKComponentNode decendents
void skc_applyOnEnter(SKNode* node) {
    if ([node isKindOfClass:[SKComponentNode class]]) {
        if (!((SKComponentNode*)node).hasEnteredScene)
            [(SKComponentNode*)node onEnter];
    } else {
        for (SKNode* child in node.children) {
            skc_applyOnEnter(child);
        }
    }
}

// recursively run onExit on all SKComponentNode decendents
void skc_applyOnExit(SKNode* node) {
    if ([node isKindOfClass:[SKComponentNode class]]) {
        if (((SKComponentNode*)node).hasEnteredScene)
            [(SKComponentNode*)node onExit];
    } else {
        for (SKNode* child in node.children) {
            skc_applyOnExit(child);
        }
    }
}



- (void)addChild:(SKNode *)node {
    [super addChild:node];
    
    if (_hasEnteredScene) {
        skc_applyOnEnter(node);
    }
}

- (void)insertChild:(SKNode *)node atIndex:(NSInteger)index {
    [super insertChild:node atIndex:index];

    if (_hasEnteredScene) {
        skc_applyOnEnter(node);
    }
}

- (void)removeChildrenInArray:(NSArray *)nodes {
    for (SKNode* node in nodes) {
        skc_applyOnExit(node);
    }
    
    [super removeChildrenInArray:nodes];
}
- (void)removeAllChildren {
    for (SKNode *node in self.children) {
        skc_applyOnExit(node);
    }
    [super removeAllChildren];
}

- (void)removeFromParent {
    [self onExit];
    [super removeFromParent];
}


- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    
    // set alpha on all immediate descendents
    for (SKNode *child in self.children) {
        child.alpha = alpha;
    }
}

@end
