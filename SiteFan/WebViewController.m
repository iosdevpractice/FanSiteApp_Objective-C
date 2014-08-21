//
//  WebViewController.m
//  SiteFan
//
//  Created by Wiley Wimberly on 8/18/14.
//  Copyright (c) 2014 Warm Fuzzy Apps, LLC. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (void)loadView
{
    self.webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"url: %@", self.url);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:self.url]];
}

@end
