//
//  ServerManager.h
//
//
//  Created by Phineas.Huang on 2018/6/11.
//  Copyright © 2018 Phineas. All rights reserved.
//
//  Reference : https://github.com/mattstevens/RoutingHTTPServer

#import <Foundation/Foundation.h>
#import "ServerDefine.h"

@class ServerManager;
@protocol ServerManagerDelegate <NSObject>

- (void)serverDebug:(ServerManager *)manager log:(NSString *)string;

@end

@interface ServerManager : NSObject

@property (weak, nonatomic) id<ServerManagerDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)run;
- (void)stop;
- (BOOL)isRunning;

@end
