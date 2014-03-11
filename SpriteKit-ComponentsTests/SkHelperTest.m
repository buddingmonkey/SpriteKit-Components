//
//  SkHelperTest.m
//  SpriteKit-Components
//
//  Created by Sufiyan Yasa on 10/12/13.
//  Copyright (c) 2013 Andrew Eiche. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SKHelper.h"

@interface SkHelperTest : XCTestCase

@end

@implementation SkHelperTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSkpAdd
{
    CGPoint result = CGPointMake(3, 3);
    CGPoint test = skpAdd(CGPointMake(1, 1), CGPointMake(2, 2));
    XCTAssertEqual(test.x, result.x, @"testSkpAdd failed");
    XCTAssertEqual(test.y, result.y, @"testSkpAdd failed");
}

- (void)testSkpSubtract
{
    CGPoint result = CGPointMake(1, 1);
    CGPoint test = skpSubtract(CGPointMake(3, 3), CGPointMake(2, 2));
    XCTAssertEqual(test.x, result.x, @"skpSubtract failed");
    XCTAssertEqual(test.y, result.y, @"skpSubtract failed");
}

- (void)testSkpMultiply
{
    CGPoint test = skpMultiply(CGPointMake(2, 2), 3);
    XCTAssertEqual(test.x, 6, @"skpMultiply failed");
    XCTAssertEqual(test.y, 6, @"skpMultiply failed");
}

- (void)testSkpDistance
{
    CGPoint pointA = CGPointMake(2, 2);
    CGPoint pointB = CGPointMake(3, 3);
    CGFloat distance = skpDistance(pointA, pointB);
    XCTAssertNotEqual(distance, 0, @"skpDistance failed");
}

@end
