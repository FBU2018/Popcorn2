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
#import "PCLibraryViewController.h"
#import "Parse.h"


@interface PCWebLoginViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *viewForFrame;
@property (strong, nonatomic) NSString *sessionId;
@property (strong, nonatomic) NSString *accountId;
@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *password;
@property(strong, nonatomic) NSString *requestTokenToSend;

@end

@implementation PCWebLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    //show authentication page, user must click "allow"
    NSString *targetString = [@"https://www.themoviedb.org/authenticate/" stringByAppendingString:self.targetURL];
    NSURL *target = [NSURL URLWithString:targetString];

    NSURLRequest *request = [NSURLRequest requestWithURL:target];
    [self.webView loadRequest:request];
}


- (IBAction)didTapBack:(id)sender {
    //get session id
    [[APIManager shared] getSession:^(NSString *sessionId, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            PFUser.currentUser[@"sessionId"] = sessionId;
            [PFUser.currentUser saveInBackground];
            //get account details (user id, etc)
            [[APIManager shared] getAccountDetails:^(NSString *userId, NSError *error) {
                if(error != nil){
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    NSLog(@"Successfully get account details, id: %@", userId);
                    PFUser.currentUser[@"accountId"] = userId;
                    [PFUser.currentUser saveInBackground];
                    // store returned account id to private property
                    self.accountId = userId;
                    NSLog(@"accountId: %@", userId);
                    //go to main tab bar controller
                    [self performSegueWithIdentifier:@"loginToMain" sender:nil];
                }
            }];
            // store returned session_id to private property
            self.sessionId = sessionId;
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
    
    if ([segue.identifier isEqualToString:@"loginToMain"]){   
        UITabBarController *tabVC = [segue destinationViewController];
        UINavigationController *navVC = tabVC.viewControllers[0];
        PCLibraryViewController *libraryVC = [navVC.viewControllers objectAtIndex:0];
        // Pass the current user's session id to the Library VC
        libraryVC.sessionId = self.sessionId;
        libraryVC.accountId = self.accountId;
    }
}


@end
