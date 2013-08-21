//
//  SKComponentNode.h
//  SpriteKit-Componenets
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
@property (nonatomic) CGPoint absoluteLocation;
@property (nonatomic) CGPoint touchDelta;
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
