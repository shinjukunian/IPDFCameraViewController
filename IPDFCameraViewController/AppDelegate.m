//
//  AppDelegate.m
//  IPDFCameraViewController
//
//  Created by Maximilian Mackh on 11/01/15.
//  Copyright (c) 2015 Maximilian Mackh. All rights reserved.
//

#import "AppDelegate.h"
@import FeatureDetectionCameraView;

@interface AppDelegate ()
@property FeatureDetectionViewController *controller;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   self.controller=[[FeatureDetectionViewController alloc]initQRDetectionControllerWithCompletion:^BOOL(NSData *data){
    
        return YES;
    }];
    [self.window setRootViewController:self.controller];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
