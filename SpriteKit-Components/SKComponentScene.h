//
//  SKComponentScene.h
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKBehavior.h"
#import "SKComponentNode.h"

@interface SKComponentScene : SKScene{
    NSMutableDictionary* components;
}

@end
