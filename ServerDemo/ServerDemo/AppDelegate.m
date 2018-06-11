//
//  AppDelegate.m
//  ServerDemo
//
//  Created by Phineas.Huang on 2018/6/11.
//  Copyright © 2018 Phineas. All rights reserved.
//

#import "AppDelegate.h"
#import "ServerManager.h"

@interface AppDelegate ()<ServerManagerDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    UIBackgroundTaskIdentifier bgTask;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self forRunInBackground];
    [ServerManager sharedInstance].delegate = self;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)forRunInBackground {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    [locationManager setAllowsBackgroundLocationUpdates:YES];
    [locationManager requestAlwaysAuthorization];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self sendBackgroundLocationToServer:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Core location error!");
}

- (void)sendBackgroundLocationToServer:(CLLocation *)location {
    bgTask = [[UIApplication sharedApplication]
              beginBackgroundTaskWithExpirationHandler:
              ^{
                  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
              }];
    
    if (bgTask != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }
}

- (void)serverDebug:(ServerManager *)manager log:(NSString *)string {
    NSLog(@"Server - %@", string);
}


@end
