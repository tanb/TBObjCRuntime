//
//  TBAppDelegate.m
//  TBObjCRuntime
//
//  Created by tanB on 8/3/13.
//  Copyright (c) 2013 tanB. All rights reserved.
//

#import "TBAppDelegate.h"
#import "TBObjCRuntime.h"

@implementation TBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // sample
    NSLog(@"%@", tb_descriptionForClassName(@"UIView"));
    NSLog(@"%@", tb_descriptionForProtocolName(@"UIAppearance"));
    return YES;
}

@end
