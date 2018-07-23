//
//  PCWebLoginViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/20/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCWebLoginViewController.h"
#import <WebKit/WebKit.h>
#import "APIManager.h"
#import "PCWebLogin2ViewController.h"


@interface PCWebLoginViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *viewForFrame;

@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *password;

@property(strong, nonatomic) NSString *requestTokenToSend;

@end

@implementation PCWebLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSString *targetString = [@"https://www.themoviedb.org/authenticate/" stringByAppendingString:self.targetURL];
    NSURL *target = [NSURL URLWithString:targetString];

    NSURLRequest *request = [NSURLRequest requestWithURL:target];
    [self.webView loadRequest:request];
}


- (IBAction)didTapBack:(id)sender {
    [[APIManager shared] getSession:^(NSString *sessionId, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            //get request token for 4, then access token for 4
            NSLog(@"session id: %@", sessionId);
            [[APIManager shared] postRequestToken4:^(NSString *requestToken, NSError *error) {
                if(error != nil){
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    NSLog(@"Request token 4: %@", requestToken);
                    self.requestTokenToSend = requestToken;
                    [self performSegueWithIdentifier:@"toNextAuth" sender:nil];
                    //another web view to approve, then create access token
                }
            }];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"toNextAuth"]){
        PCWebLogin2ViewController *receiver = [segue destinationViewController];
        receiver.requestToken = self.requestTokenToSend;
    }
}


@end
