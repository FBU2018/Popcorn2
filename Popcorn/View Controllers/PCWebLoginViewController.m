//
//  PCWebLoginViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/20/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCWebLoginViewController.h"
#import <WebKit/WebKit.h>


@interface PCWebLoginViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *viewForFrame;

@end

@implementation PCWebLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:[WKWebViewConfiguration new]];
//    self.webView.navigationDelegate = self;
//    [self.view addSubview:self.webView];
//    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
//
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|"
//                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(_webView)]];
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_webView]-0-|"
//                                                                      options:NSLayoutFormatDirectionLeadingToTrailing
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(_webView)]];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    NSURL *target = [NSURL URLWithString:@"https://www.themoviedb.org/login"];
//    NSURL *target = [NSURL URLWithString:@"https://www.themoviedb.org"];

    NSURLRequest *request = [NSURLRequest requestWithURL:target];
    [self.webView loadRequest:request];
}

- (void)webView:(WKWebView *)webView
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSURLCredential *creds = [[NSURLCredential alloc] initWithUser:@"username"
                                                          password:@"password"
                                                       persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, creds);
}


- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
