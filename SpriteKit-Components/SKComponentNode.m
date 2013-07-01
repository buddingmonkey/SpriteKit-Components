//
//  SKComponentNode.m
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import "SKComponentNode.h"
#import "SKComponentScene.h"

@implementation SKCTouchState

@end


@interface SKComponentNode() {
    NSMutableOrderedSet *componentKeys;
    BOOL isFingerDown;
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
        
        self.dragThreshold = 4;
        self.longPressTime = 1;
        
        self.touchState = [SKCTouchState new];
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
    if ([component respondsToSelector:@selector(node)])
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

- (void)update:(CFTimeInterval)dt {
    if (isFingerDown) {
        _touchState.touchTime += dt;
        if (!_touchState.isLongPress && !_touchState.isDragging && _touchState.touchTime > self.longPressTime) {
            _touchState.isLongPress = YES;
            for (id<SKComponent> component in components) {
                SKComponentPerformSelectorWithObject(component, onLongPress, _touchState);
            }            
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (!isFingerDown) {
            isFingerDown = YES;
            _touchState.touch = touch;
            _touchState.absoluteTouchStart = [touch locationInNode:self.scene];
            _touchState.touchStart = [touch locationInNode:self];
            _touchState.touchLocation = _touchState.touchStart;
            _touchState.touchTime = 0;
            _touchState.isLongPress = NO;
            _touchState.isDragging = NO;            
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (isFingerDown && touch == _touchState.touch) {
            CGPoint location = [touch locationInNode:self];
            _touchState.touchLocation = location;

            if (!_touchState.isDragging) {
                CGPoint d = CGPointMake(location.x-_touchState.touchStart.x, location.y-_touchState.touchStart.y);
                float m = d.x*d.x + d.y*d.y;
                if (m > _dragThreshold*_dragThreshold) {
                    _touchState.isDragging = YES;
                    for (id<SKComponent> component in components) {
                        SKComponentPerformSelectorWithObject(component, dragStart, _touchState);
                    }
                }
            }
            if (_touchState.isDragging) {
                for (id<SKComponent> component in components) {
                    SKComponentPerformSelectorWithObject(component, dragMoved, _touchState);
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (isFingerDown && touch == _touchState.touch) {
            isFingerDown = NO;
            CGPoint location = [touch locationInNode:self];
            _touchState.touchLocation = location;

            if (_touchState.isDragging) {
                CGRect frame = [self calculateAccumulatedFrame];
                frame.origin.x = -frame.size.width/2;
                frame.origin.y = -frame.size.height/2;
                BOOL isSelect = CGRectContainsPoint(frame, location);

                for (id<SKComponent> component in components) {
                    if (component.enabled) {
                        SKComponentPerformSelectorWithObject(component, dragDropped, _touchState);
                        if (isSelect)
                            SKComponentPerformSelectorWithObject(component, onSelect, _touchState);
                    }
                }
            } else if (touch.tapCount > 0 && !_touchState.isLongPress) {
                for (id<SKComponent> component in components) {
                    SKComponentPerformSelectorWithObject(component, onTap, _touchState);
                    SKComponentPerformSelectorWithObject(component, onSelect, _touchState);
                }
            } else {
                CGRect frame = [self calculateAccumulatedFrame];
                frame.origin.x = -frame.size.width/2;
                frame.origin.y = -frame.size.height/2;
                if (CGRectContainsPoint(frame, location)) {
                    for (id<SKComponent> component in components) {
                        SKComponentPerformSelectorWithObject(component, onSelect, _touchState);
                    }
                }
            }
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (isFingerDown && touch == _touchState.touch) {
            isFingerDown = NO;
            
            if (_touchState.isDragging) {
                _touchState.touchLocation = [touch locationInNode:self];
                for (id<SKComponent> component in components) {
                    SKComponentPerformSelectorWithObject(component, dragCancelled, _touchState);
                }
            }
        }
    }
}

@end
