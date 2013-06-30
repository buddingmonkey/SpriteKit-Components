//
//  SKComponentScene.m
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import "SKComponentScene.h"

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
        _deltaTime = 0;
    } else {
        _deltaTime = currentTime - lastFrameTime;
    }
    lastFrameTime = currentTime;

    
    // remove requested components
    [componentNodes minusHashTable:componentNodesToRemove];
    [componentNodesToRemove removeAllObjects];

    
    // look for new SKComponent nodes and make them enter the scene
    recursiveFindNewNodes(self);
    
    
    // add new componenets
    [componentNodes unionHashTable:componentNodesToAdd];
    [componentNodesToAdd removeAllObjects];
    
    
    // perform update on all regiseterd components
    for (SKComponentNode* node in componentNodes) {
        for (id<SKComponent> component in node.components) {
            if (component.enabled && [component respondsToSelector:@selector(update:)])
                [component update:_deltaTime];
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
    for (SKComponentNode* node in componentNodes) {
        for (id<SKComponent> component in node.components) {
            SKComponentPerformSelectorWithObject(component, didBeginContact, contact);
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    for (SKComponentNode* node in componentNodes) {
        for (id<SKComponent> component in node.components) {
            SKComponentPerformSelectorWithObject(component, didEndContact, contact);
        }
    }
}
@end
