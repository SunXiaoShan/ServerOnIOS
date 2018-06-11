//
//  ServerManager.m
//
//
//  Created by Phineas.Huang on 2018/6/11.
//  Copyright © 2018 Phineas. All rights reserved.
//

#import "ServerManager.h"

#import "RoutingHTTPServer.h"
#import "HTTPMessage.h"

#define TAG @"ServerManager"

@interface ServerManager()

@property (nonatomic, strong) RoutingHTTPServer *http;

@end

@implementation ServerManager

#pragma mark - public function

+ (instancetype)sharedInstance {
    static ServerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ServerManager alloc] init];
    });
    return instance;
}

- (void)run {
    if ([self isRunning] == NO) {
        NSError *error;
        if (![self.http start:&error]) {
            NSLog(@"Error starting HTTP server: %@", error);
            return;
        }
    }
}

- (void)stop {
    [self.http stop];
}

- (BOOL)isRunning {
    return [self.http isRunning];
}

#pragma mark - private function

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupServer];
    }
    return self;
}

- (void)setupServer {
    // Step 1: initial
    self.http = [[RoutingHTTPServer alloc] init];

    // Step 2: setup parameter
    //    [self.http setDefaultHeaders:@{}]; // TODO:
    [self.http setPort:SERVER_PORT];
    [self.http setDocumentRoot:[@"~/Sites" stringByExpandingTildeInPath]];

    // Step 3: setup route
    [self setupRoutes];

    // Step 4: start server
    NSError *error;
    if (![self.http start:&error]) {
        NSLog(@"Error starting HTTP server: %@", error);
        return;
    }

    NSLog(@"%@ - Host : %@ %ud",
          TAG,
          [self.http interface],
          [self.http isRunning]);
}

- (NSString *)getServerheader {
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [bundleInfo objectForKey:@"CFBundleShortVersionString"];
    if (!appVersion) {
        appVersion = [bundleInfo objectForKey:@"CFBundleVersion"];
    }
    NSString *serverHeader = [NSString stringWithFormat:@"%@/%@",
                              [bundleInfo objectForKey:@"CFBundleName"],
                              appVersion];
    return serverHeader;
}

- (void)setupRoutes {
    __weak ServerManager *weakSelf = self;

#ifdef DEBUG
    [self.http get:@"/hello_world_get" withBlock:^(RouteRequest *request, RouteResponse *response) {
        [response respondWithString:@"Hello World!!"];
        [weakSelf debug:@"Hello World!! GET"];
    }];

    [self.http post:@"/hello_world_post" withBlock:^(RouteRequest *request, RouteResponse *response) {
        NSData *bodyData = [request body];
        NSString *body = [[NSString alloc] initWithBytes:[bodyData bytes]
                                            length:[bodyData length]
                                           encoding:NSUTF8StringEncoding];
        [response respondWithString:body];
        [weakSelf debug:@"Hello World!! POST"];
    }];
#endif
}

#pragma mark - debug

- (void)debug:(NSString *)content {
    if ([self.delegate respondsToSelector:@selector(serverDebug:log:)]) {
        __weak ServerManager *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.delegate serverDebug:weakSelf log:content];
        });
    }
}

@end
