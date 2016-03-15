//
//  WebViewController.m
//  demo222
//
//  Created by suning on 16/3/10.
//  Copyright © 2016年 suning. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (nonatomic,weak) UIWebView *webView;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.delegate = self;
}

- (void)setURL:(NSString *)URL{
    _URL = URL;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSURL *url = [NSURL URLWithString:self.URL];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

}

- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
