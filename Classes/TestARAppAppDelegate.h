//
//  TestARAppAppDelegate.h
//  TestARApp
//
//  Created by Massimo Donati on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestARAppViewController;

@interface TestARAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TestARAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestARAppViewController *viewController;

@end

