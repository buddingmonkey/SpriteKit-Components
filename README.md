SpriteKit-Components
====================

A component model for iOS 7+ SpriteKit Framework. Add components that perform specific behaviors to your nodes. Benefits to using the component based model include:

 - Lets you write reusable behaviors that you can apply to any node and reuse across projects
 - Adds an update method with delta time called for every SKComponentNode and behavior
 - Adds onEnter and onExit methods akin to Cocos2d's model for every SKComponentNode which lets you perform set up and tear down when your nodes are added to and removed from the scene.
 - Simplifies basic touch interaction to automatically support select, tap, drag, drop, and long presses

Project Setup
-------
 1. Start with a SpriteKit Game project
 2. Drag and drop in SpriteKit-Components.xcodeproj into your project workspace
 3. Add SpriteKit-Components to your target dependencies
 4. Add libSpriteKit-Components.a to your Link Binary With Libraries build phase
 5. Add SKComponents.h to your project and include it in your prefix.pch header if you never want to have to include it again

Component Model Usage
-------
Your base scene must inherit from SKComponentScene. SKComponentScene is the component model host that ensures all SKComponentNodes are found and registered.

Your scene graph should be based on SKComponentNodes, which should have your graphical/rendering nodes as their children. SKComponentNodes can be added anywhere in the scene.

Add behaviors to your SKComponentNodes with `[node addComponent:[MyComponent new]];`

Example Component - ApplyAlpha to all children
-------

SKComponentNodes automatically apply their alpha value to their direct children, but lets say you want to apply that alpha to your node's children's children's children, and so on.

DeepAlpha.h

    @interface DeepAlpha : NSObject<SKComponent> {
        float previousAlpha;
    }
    @end


DeepAlpha.m

    #import "DeepAlpha.h"
    
    @implementation DeepAlpha
    @synthesize node,enabled;

    - (void)onEnter {
        recursivelyApplyAlpha(node, node.alpha);
    }
    
    - (void)didEvaluateActions {
        if (previousAlpha != node.alpha) {
            recursivelyApplyAlpha(node, node.alpha);
            previousAlpha = node.alpha;
        }
    }
    
    void recursivelyApplyAlpha(SKNode* node, float alpha) {
        for (SKNode *child in node.children) {
            child.alpha = alpha;
            if (child.children.count > 0)
                recursivelyApplyAlpha(child, alpha);
        }
    }
    @end

onEnter and didEvaluateActions will automatically be called when you add this component to a node in the scene. Add this component to one of your SKComponentNodes and any time you change the alpha on your component node, it will set the alpha on every descendent. 

To use this component, just add it to any SKComponentNode like this:

    SKNode* node = [SKComponentNode node];
    [node addComponent:[DeepAlpha new]];
    // add sprites or shapes as children of your node, then add it to the scene
    [scene addChild:node];

Example Component - Adding Touch Interaction
---------------------------------------

First off, don't forget to turn on user interaction on your SKComponentNode with `node.userInteractionEnabled = YES;`. A good place to do it would be in the component's start method.

Every app has buttons. Let's make a component that responds to a touch-up-inside type gesture.

    @implementation SKCSelectTest
    @synthesize node, enabled;

    - (void)start {
        node.userInteractionEnabled = YES;
    }

    - (void)onSelect:(SKCTouchState*)touchState {
        // do something
    }
    @end

OMG that was too easy. Let's make a component that will let you drag a node around the screen instead:

    @implementation SKCDraggable
    @synthesize node, enabled;
    @synthesize startPosition;
    
    - (void)start {
        node.userInteractionEnabled = YES;
    }

    - (void)dragStart:(SKCTouchState*)touchState {
        // we could do something here to clue the user in on the fact that we started dragging
        startPosition = node.position;
    }
    
    - (void)dragMoved:(SKCTouchState*)touchState {
        // check out the skHelper.m for a couple shorthand functions/methods for vector` math
        node.position = skpAdd(node.position, touchState.touchLocation);
    }
    
    - (void)dragDropped:(SKCTouchState*)touchState {
        // we could show the user we dropped successfully here
    }
    
    - (void)dragCancelled:(SKCTouchState*)touchState {
        node.position = startPosition;
    }
    @end

SKComponentNodes can be a component too
----------------------------
If you sublcass an SKComponentNode and you want to make use of the component callbacks without creating an extra component, just implement the `SKComponent` protocol. 
Now your node gets all the component callbacks too.
Just make sure you call `[super onEnter/onExit/update:]` so the component node can do it's behind the scenes magic.
