//
//  SpriteKit_ComponentsTests.m
//  SpriteKit-ComponentsTests
//
//  Created by Andrew Eiche on 6/25/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SKComponentNode.h"

@interface MockComponent : NSObject <SKComponent>

@end

@implementation MockComponent
@synthesize node,enabled;
@end


@interface SpriteKit_ComponentsTests : XCTestCase

@end

@implementation SpriteKit_ComponentsTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
    [set addObject:@"test1"];
    [set addObject:@"test2"];
    [set addObject:@"test3"];
    [set addObject:[NSString class]];
    [set addObject:[NSString class]];
    [set addObject:[NSDictionary class]];
    [set addObject:@"test2"];
    
    
    int index = [set indexOfObject:@"test2"];
    if (index == NSNotFound)
        XCTFail(@"can't find test2 in set");
    if (index != 1)
        XCTFail(@"test2 not in order");

    index = [set indexOfObject:[NSString class]];
    if (index == NSNotFound)
        XCTFail(@"can't find [NSString class] in set");
    if (index != 3)
        XCTFail(@"[NSString class] not in order");
    if (set.count != 5)
        XCTFail(@"Set is the wrong size");
}

- (void) testGetNodeWithUnregisteredClass {
    SKComponentNode *node = [SKComponentNode node];
    NSObject *obj = [node getComponent:[NSObject class]];
    XCTAssertNil(obj, @"Object must be nil");
}

- (void) testGetNodeWithRegisteredClass {
    SKComponentNode *node = [SKComponentNode node];
    [node addComponent:[[MockComponent alloc] init]];
    MockComponent *obj = [node getComponent:[MockComponent class]];
    XCTAssertNotNil(obj, @"Object must not be nil");
}


- (void) testGetNodeWithUnregisteredName {
    SKComponentNode *node = [SKComponentNode node];
    NSObject *obj = [node getComponentWithName:@"test"];
    XCTAssertNil(obj, @"Object must be nil");
}

- (void) testGetNodeWithRegisteredName {
    SKComponentNode *node = [SKComponentNode node];
    [node addComponent:[[MockComponent alloc] init] withName:@"test"];
    MockComponent *obj = [node getComponentWithName:@"test"];
    XCTAssertNotNil(obj, @"Object must not be nil");
}
@end
