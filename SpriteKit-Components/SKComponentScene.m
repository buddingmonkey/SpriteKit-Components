//
//  SKComponentScene.m
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import "SKComponentScene.h"

@implementation SKComponentScene

- (id)init
{
    self = [super init];
    if (self) {
        components = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) update:(NSTimeInterval)currentTime{
    [self recursiveUpdateNodes:currentTime withParent:self];
}

-(void) recursiveUpdateNodes:(CGFloat)deltaTime withParent:(SKNode*)parent{
    if ([parent conformsToProtocol:@protocol(SKBehavior)]){
        [((SKNode<SKBehavior>*)parent) update:deltaTime];
    }
    
    for (SKNode<SKBehavior>* node in parent.children) {
        [self recursiveUpdateNodes:deltaTime withParent:node];
    }
}

-(void) didSimulatePhysics{
    [self recursiveDidSimulatePhysics:self];
}

-(void) recursiveDidSimulatePhysics:(SKNode*)parent{
    if ([parent isKindOfClass:[SKComponentNode class]]){
        [((SKComponentNode*)parent) didSimulatePhysics];
    }
    
    for (SKComponentNode * node in parent.children) {
        [self recursiveDidSimulatePhysics:node];
    }
}

@end
