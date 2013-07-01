//
//  SKComponentScene.m
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import "SKComponentScene.h"
#import "SKCNodeIsComponent.h"

@interface SKComponentScene() {
    NSHashTable* componentNodes;
    NSHashTable* componentNodesToRemove;
    NSHashTable* componentNodesToAdd;
    CFTimeInterval lastFrameTime;
}

@end


@implementation SKComponentScene

static Class skComponentNodeClass;

-(id)initWithSize:(CGSize)size {
    if ((self = [super initWithSize:size])) {
        if (!skComponentNodeClass)
            skComponentNodeClass = [SKComponentNode class];
        componentNodes = [NSHashTable weakObjectsHashTable];
        componentNodesToAdd = [NSHashTable weakObjectsHashTable];
        componentNodesToRemove = [NSHashTable weakObjectsHashTable];
        lastFrameTime = 0;
        
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)dealloc {
    componentNodes = Nil;
}

- (void)registerComponentNode:(SKComponentNode *)node {
    if (![componentNodes containsObject:node]) {
        
        [componentNodesToAdd addObject:node];
        
        // auto configure nodes that implement the SKComponent protocol
        if ([node conformsToProtocol:@protocol(SKComponent)]) {
            [node addComponent:[SKCNodeIsComponent new]];
        }
        
    } else {
        [componentNodesToRemove removeObject:node];
    }
}

- (void)unregisterComponentNode:(SKComponentNode *)node {
    if ([componentNodes containsObject:node]) {
        [componentNodesToRemove addObject:node];
    } else {
        [componentNodesToAdd removeObject:node];
    }
}

- (void)update:(NSTimeInterval)currentTime {
    // calculate delta time
    if (lastFrameTime == 0) {
        _dt = 0;
    } else {
        _dt = currentTime - lastFrameTime;
    }
    lastFrameTime = currentTime;

    
    // remove requested components
    [componentNodes minusHashTable:componentNodesToRemove];
    [componentNodesToRemove removeAllObjects];

    
    // look for new SKComponentNodes and make them enter the scene
    recursiveFindNewNodes(self);
    
    
    // add new nodes
    [componentNodes unionHashTable:componentNodesToAdd];
    [componentNodesToAdd removeAllObjects];
    
    
    // perform update on all registerd nodes
    for (SKComponentNode* node in componentNodes) {
        [node update:_dt];
        for (id<SKComponent> component in node.components) {
            if (component.enabled && [component respondsToSelector:@selector(update:)])
                [component update:_dt];
        }
    }
    
    /** @todo: consider looping for as long as there are new components to add */
}

/** @todo:  this may cause problems if onEnter modifies the scene graph
 *          doesn't matter if we require all SKComponent nodes belong to other SKComponent nodes
 *          or we generate a list, then perform onEnter (also affects SKComponentNode onEnter)
 */
void recursiveFindNewNodes(SKNode* node) {
    for (SKNode *child in node.children) {
        if ([child isKindOfClass:skComponentNodeClass]) {
            SKComponentNode* componentNode = (SKComponentNode*)child;
            if (!componentNode.hasEnteredScene) {
                [componentNode onEnter];
            }
        }

        recursiveFindNewNodes(child);
    }
}

- (void)addChild:(SKNode *)node {
    [super addChild:node];
    skc_applyOnEnter(node);
}

- (void)insertChild:(SKNode *)node atIndex:(NSInteger)index {
    [super insertChild:node atIndex:index];
    skc_applyOnEnter(node);
}

- (void)removeChildrenInArray:(NSArray *)nodes {
    for (SKNode* node in nodes) {
        skc_applyOnExit(node);
    }
    
    [super removeChildrenInArray:nodes];
}
- (void)removeAllChildren {
    for (SKNode* node in self.children) {
        skc_applyOnExit(node);
    }
    [super removeAllChildren];
}

- (void)didEvaluateActions {
    [super didEvaluateActions];
    
    for (SKComponentNode* node in componentNodes) {
        for (id<SKComponent> component in node.components) {
            SKComponentPerformSelector(component, didEvaluateActions);
        }
    }
}

- (void)didSimulatePhysics{
    [super didSimulatePhysics];
    
    for (SKComponentNode* node in componentNodes) {
        for (id<SKComponent> component in node.components) {
            SKComponentPerformSelector(component, didSimulatePhysics);
        }
    }
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if ([contact.bodyA isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyA).components) {
            SKComponentPerformSelectorWithObject(component, didBeginContact, contact);
        }
    }
    if ([contact.bodyB isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyB).components) {
            SKComponentPerformSelectorWithObject(component, didBeginContact, contact);
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    if ([contact.bodyA isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyA).components) {
            SKComponentPerformSelectorWithObject(component, didBeginContact, contact);
        }
    }
    if ([contact.bodyB isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyB).components) {
            SKComponentPerformSelectorWithObject(component, didBeginContact, contact);
        }
    }
}
- (void)didChangeSize:(CGSize)oldSize {
    [super didChangeSize:oldSize];
    
    for (SKComponentNode* node in componentNodes) {
        for (id<SKComponent> component in node.components) {
            SKComponentPerformSelectorWithObject(component, onSceneSizeChanged, oldSize);
        }
    }
    
}
@end
