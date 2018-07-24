//
//  PCWebLogin2ViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/23/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCWebLogin2ViewController.h"
#import <WebKit/WebKit.h>
#import "APIManager.h"

@interface PCWebLogin2ViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;


@end

@implementation PCWebLogin2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *targetString = [@"https://www.themoviedb.org/auth/access?request_token=" stringByAppendingString:self.requestToken];
    NSURL *target = [NSURL URLWithString:targetString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:target];
    [self.webView loadRequest:request];
}

- (void)getAccess{
    
    
//    [[APIManager shared] createAccessToken4:^(NSString *accessToken, NSString *accountId, NSError *error) {
//        if(error != nil){
//            NSLog(@"Error: %@", error.localizedDescription);
//        }
//        else{
//            NSLog(@"account id: %@", accountId);
////            [self performSegueWithIdentifier:@"loginToMain" sender:nil];
//        }
//    }];
    
    [[APIManager shared] getAccountDetails:^(NSString *userId, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully get account details, id: %@", userId);
            [self performSegueWithIdentifier:@"loginToMain" sender:nil];
        }
    }];
}

- (IBAction)didTapClose:(id)sender {
    [self getAccess];
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
