//
//  SKComponentScene.h
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

#import <SpriteKit/SpriteKit.h>
#import "SKComponent.h"
#import "SKComponentNode.h"

#define SKComponentSceneForNode(node)   (SKComponentScene*)([(node).scene isKindOfClass:[SKComponentScene class]] ? (node).scene : Nil)


SK_EXPORT @interface SKComponentScene : SKScene <SKPhysicsContactDelegate> {
}

@property (nonatomic) CFTimeInterval dt;
@property (nonatomic) CFTimeInterval dtLimit;

- (void) registerComponentNode:(SKComponentNode*)node;
- (void) unregisterComponentNode:(SKComponentNode*)node;
- (void)update:(NSTimeInterval)currentTime __attribute__((objc_requires_super));
@end
