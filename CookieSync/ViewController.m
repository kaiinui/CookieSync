//
//  ViewController.m
//  CookieSync
//
//  Created by kaiinui on 2016/02/08.
//  Copyright © 2016年 kotori. All rights reserved.
//

#import "ViewController.h"
#import "KTRCookieSyncManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[KTRCookieSyncManager sharedManager] startWithURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/7817937/______Experiments/SFSafariViewControllerBridge.html"] withViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
