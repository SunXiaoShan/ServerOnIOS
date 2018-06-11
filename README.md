# ServerOnIOS

Step 1: Add all of files in /Server folder

Step 2: import ServerManager

Step 3: Setup custom port on ServerDefine.h

Step 4: Add initial manager
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [ServerManager sharedInstance];
    return YES;
}
```

&

```
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [[ServerManager sharedInstance] run];
}
```

Other
You could set custom parameter on setupServer of ServerManager.m

