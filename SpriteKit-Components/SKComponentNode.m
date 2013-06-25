//
//  SKComponentNode.m
//  ReEntry
//
//  Created by Andrew Eiche on 6/19/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import "SKComponentNode.h"

@implementation SKComponentNode
- (id)init
{
    self = [super init];
    if (self) {
        components = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(NSString*) addComponent:(NSObject<SKBehavior>*) component{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    NSString* guid = (__bridge NSString *) uuidStr;
    components[guid] = component;
    return guid;
}

-(void) removeComponentWithComponent:(NSObject<SKBehavior>*) component{
    NSString* key;
    for (NSString* k in components.allKeys) {
        if (components[k] == component){
            key = k;
        }
    }
    
    if (key != nil){
        [self removeComponentWithKey:key];
    }
}

-(void) removeComponentWithKey:(NSString*) uuid{
    [components removeObjectForKey:uuid];
}

-(void) update:(CGFloat)deltaTime{
    for (NSObject<SKBehavior>* b in components.allValues) {
        if (b.enabled){
            [b update:deltaTime];
        }
    }
}

-(void) didSimulatePhysics{
    for (NSObject<SKBehavior>* b in components.allValues) {
        if (b.enabled) {
            [b didSimulatePhysics];
        }
    }
}

@end
