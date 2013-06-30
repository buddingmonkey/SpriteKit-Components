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
}
@end

@implementation SKComponentNode
@synthesize components=components;
- (id)init
{
    self = [super init];
    if (self) {
        components = [[NSMutableDictionary alloc] init];
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
    Class componentClass = [component class];
    [components setObject:components forKey:(id<NSCopying>)componentClass];
}

- (BOOL)_addComponent:(id<SKComponent>)component withKey:(id<NSCopying>)key {
    if ([components objectForKey:key])
        return NO;
    
    [components setObject:component forKey:key];
    component.node = self;
    component.enabled = YES;
    SKComponentPerformSelector(component, start);

    if (_hasEnteredScene) {
        SKComponentScene* scene = SKComponentSceneForNode(self);
        [scene registerComponent:component];
    }

    return YES;
}

- (void)removeComponent:(id<SKComponent>)component{
    for (NSString* key in components) {
        if (components[key] == component){
            [self _removeComponentWithKey:key];
            return;
        }
    }
}

- (void)removeComponentWithClass:(Class)className {
    [self _removeComponentWithKey:className];
}

- (void)removeComponentWithName:(NSString*)name {
    [self _removeComponentWithKey:name];
}

- (void)_removeComponentWithKey:(id)key {
    id<SKComponent> component = [components objectForKey:key];
    if (!component) {
        return;
    }
    
    if (_hasEnteredScene) {
        SKComponentScene* scene = SKComponentSceneForNode(self);
        [scene unregisterComponent:component];
    }
    
    [components removeObjectForKey:key];
}


- (id<SKComponent>)getComponentWithName:(NSString*)name {
    return [components objectForKey:name];
}

- (id<SKComponent>)getComponent:(Class)componentClass {
    id<SKComponent> component = [components objectForKey:componentClass];
    return component;
}

- (void)onEnter {
    if (_hasEnteredScene)
        return;

    self.hasEnteredScene = YES;
    
    // register self with scene

    // register components with scene
    SKComponentScene* scene = SKComponentSceneForNode(self);
    for (id<SKComponent> component in components.objectEnumerator) {
        [scene registerComponent:component];
        SKComponentPerformSelector(component, onEnter);
    }
    
    // notify SKComponent children, recursively
    applyOnEnter(self);
}

// recursively run onEnter on all SKComponentNode decendents
void applyOnEnter(SKNode* node) {
    for (SKNode* child in node.children) {
        if ([child isKindOfClass:[SKComponentNode class]]) {
            if (!((SKComponentNode*)child)->_hasEnteredScene)
                [(SKComponentNode*)child onEnter];
        } else {
            applyOnEnter(child);
        }
    }
}

- (void)onExit {
    if (!_hasEnteredScene)
        return;
    
    self.hasEnteredScene = NO;

    // clean up

    // unregister components with scene
    SKComponentScene* scene = SKComponentSceneForNode(self);
    for (id<SKComponent> component in components.objectEnumerator) {
        SKComponentPerformSelector(component, onExit);
        [scene unregisterComponent:component];
    }

    applyOnExit(self);
}


// recursively run onEnter on all SKComponentNode decendents
void applyOnExit(SKNode* node) {
    for (SKNode* child in node.children) {
        if ([child isKindOfClass:[SKComponentNode class]]) {
            if (((SKComponentNode*)child)->_hasEnteredScene)
                [(SKComponentNode*)child onExit];
        } else {
            applyOnExit(child);
        }
    }
}


- (void)addChild:(SKNode *)node {
    [super addChild:node];
    
    if (_hasEnteredScene) {
        if ([node isKindOfClass:[SKComponentNode class]]) {
            if (!((SKComponentNode*)node)->_hasEnteredScene)
                [(SKComponentNode*)node onEnter];
        } else {
            applyOnEnter(node);
        }
    }
}

- (void)insertChild:(SKNode *)node atIndex:(NSInteger)index {
    [super insertChild:node atIndex:index];

    if (_hasEnteredScene) {
        if ([node isKindOfClass:[SKComponentNode class]]) {
            if (!((SKComponentNode*)node)->_hasEnteredScene)
                [(SKComponentNode*)node onEnter];
        } else {
            applyOnEnter(node);
        }
    }
}

- (void)removeChildrenInArray:(NSArray *)nodes {
    for (SKNode* node in nodes) {
        if ([node isKindOfClass:[SKComponentNode class]]) {
            if (((SKComponentNode*)node).hasEnteredScene)
                [(SKComponentNode*)node onExit];
        } else {
            applyOnExit(node);
        }
    }
    
    [super removeChildrenInArray:nodes];
}
- (void)removeAllChildren {
    [self onExit];
    [super removeAllChildren];
}

- (void)removeFromParent {
    [self onExit];
    [super removeFromParent];
}

- (void)removeFromParentWithCleanup:(BOOL)cleanup {
    if (cleanup) {
        [self onExit];
    }
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
