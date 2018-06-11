//
//  ViewController.m
//  ClientDemo
//
//  Created by Phineas.Huang on 2018/6/11.
//  Copyright © 2018 Phineas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionGet:(id)sender {
    [self testGet];
}

- (IBAction)actionPost:(id)sender {
    NSString *xmlString = @"test";
    
    [self verifyMethod:@"POST"
                  path:@"/hello_world_post" // xml
           contentType:@"text/xml"
           inputString:xmlString
        responseString:@"supergreen"];
}

- (void)testGet {
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL
                                         URLWithString:@"http://127.0.0.1:8080/hello_world_get"]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10
     ];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    NSData *response1 =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse error:&requestError];
    
    NSString *responseString = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
    NSLog(@"[2]responseString : %@", responseString);
    
    NSString *msg = [NSString stringWithFormat:@"Get result : %@", responseString];
    [self.label setText:msg];
}

- (void)verifyMethod:(NSString *)method path:(NSString *)path contentType:(NSString *)contentType inputString:(NSString *)inputString responseString:(NSString *)expectedResponseString {
    
    int port = 8080;
    NSError *error = nil;
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *baseURLString = [NSString stringWithFormat:@"http://127.0.0.1:%d", port];
    
    NSString *urlString = [baseURLString stringByAppendingString:path];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%ld", [data length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    
    NSURLResponse *response;
    NSHTTPURLResponse *httpResponse;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    httpResponse = (NSHTTPURLResponse *)response;
    
    NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"XXX - responseString : %@", responseString);
    NSString *msg = [NSString stringWithFormat:@"Post result : %@", responseString];
    [self.label setText:msg];
}

@end
