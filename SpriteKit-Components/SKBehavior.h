//
//  SpriteKitBehavior.h
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SKBehavior <NSObject>

@property (readwrite) BOOL enabled;

-(void) start;
-(void) onCollisionStart;
-(void) onCollision;
-(void) onCollisionEnd;
-(void) onSelect;
-(void) didSimulatePhysics;
-(void) update:(CGFloat)deltaTime;

@end
