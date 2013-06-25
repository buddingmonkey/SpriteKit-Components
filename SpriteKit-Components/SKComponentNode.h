//
//  SKComponentNode.h
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKBehavior.h"

@interface SKComponentNode : SKNode{
    NSMutableDictionary* components;
}

// Subclasses should not override this method.
-(void) update:(CGFloat) deltaTime;

//Subclasses should not override this method.
-(void) didSimulatePhysics;

//Subclasses should not override this method.
-(void) removeComponentWithComponent:(NSObject<SKBehavior>*) component;

//Subclasses should not override this method.
-(void) removeComponentWithKey:(NSString*) uuid;

@end
