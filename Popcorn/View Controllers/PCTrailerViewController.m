//
//  PCTrailerViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/18/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCTrailerViewController.h"
#import "APIManager.h"
#import <WebKit/WebKit.h>


@interface PCTrailerViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation PCTrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showTrailer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTrailer{
    //Make call to get the trailer URL
    [[APIManager shared] getTrailerURL:[self.movie.movieID stringValue] completion:^(NSURL *url, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully got URL");
            //Use URL to make a request, show inside the webView
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            [self.webView loadRequest:request];
        }
    }];
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
