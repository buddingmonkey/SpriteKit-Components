//
//  SKComponentScene.m
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
        [self initialize];
    }
    return self;
}

-(id) init {
    if ((self = [super init])) {
        [self initialize];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

-(void) initialize {
    if (!skComponentNodeClass)
        skComponentNodeClass = [SKComponentNode class];
    componentNodes = [NSHashTable weakObjectsHashTable];
    componentNodesToAdd = [NSHashTable weakObjectsHashTable];
    componentNodesToRemove = [NSHashTable weakObjectsHashTable];
    lastFrameTime = 0;
    _dtLimit = .1;
    
    self.physicsWorld.contactDelegate = self;
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

- (void)update:(NSTimeInterval)currentTime __attribute__((objc_requires_super)) {
    // calculate delta time
    if (lastFrameTime == 0) {
        _dt = 0;
    } else {
        _dt = MIN(currentTime - lastFrameTime, _dtLimit);
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
    if ([contact.bodyA.node isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyA.node).components) {
            SKComponentPerformSelectorWithObject(component, didBeginContact, contact);
        }
    }
    if ([contact.bodyB.node isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyB.node).components) {
            SKComponentPerformSelectorWithObject(component, didBeginContact, contact);
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact {
    if ([contact.bodyA.node isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyA.node).components) {
            SKComponentPerformSelectorWithObject(component, didEndContact, contact);
        }
    }
    if ([contact.bodyB.node isKindOfClass:[SKComponentNode class]]) {
        for (id<SKComponent> component in ((SKComponentNode*)contact.bodyB.node).components) {
            SKComponentPerformSelectorWithObject(component, didEndContact, contact);
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
