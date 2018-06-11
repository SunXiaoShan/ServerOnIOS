//
//  ViewController.m
//  ServerDemo
//
//  Created by Phineas.Huang on 2018/6/11.
//  Copyright © 2018 Phineas. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionRun:(id)sender {
    [[ServerManager sharedInstance] run];
    [self updateStatus];
}

- (IBAction)actionStop:(id)sender {
    [[ServerManager sharedInstance] stop];
    [self updateStatus];
    
}

- (void)updateStatus {
    NSString *content = [[ServerManager sharedInstance] isRunning] ? @"Server On" : @"Server Off";
    [self.label setText:content];
}

@end
