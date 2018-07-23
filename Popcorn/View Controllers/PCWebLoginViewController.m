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

@property(strong, nonatomic) NSString *username;
@property(strong, nonatomic) NSString *password;

@end

@implementation PCWebLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    //shows alert to input username and password
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Log in" message: nil
//                                                                       preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Username";
//        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    }];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Password";
//        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    }];
//
//    //Cancel and create options
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//    }]];
//
//    [alertController addAction:[UIAlertAction actionWithTitle:@"Log in" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        NSArray * textfields = alertController.textFields;
//        UITextField * namefield = textfields[0];
//        UITextView * passfield = textfields[1];
//
//        self.username = namefield.text;
//        self.password = namefield.text;
//
//    }]];
//    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //shows alert to input username and password
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Log in" message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Username";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Password";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    //Cancel and create options
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Log in" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        UITextView * passfield = textfields[1];
        
        self.username = namefield.text;
        self.password = passfield.text;
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    NSURL *target = [NSURL URLWithString:@"https://www.themoviedb.org/login"];
//    NSURL *target = [NSURL URLWithString:@"https://www.themoviedb.org"];

    NSURLRequest *request = [NSURLRequest requestWithURL:target];
    [self.webView loadRequest:request];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    //receive a authenticate and challenge with the user credential
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodNTLM] &&
        [challenge previousFailureCount] == 0)
    {
        NSURLCredential *credentail = [NSURLCredential
                                       credentialWithUser:self.username
                                       password:self.password
                                       persistence:NSURLCredentialPersistenceForSession];
        
        
        [[challenge sender] useCredential:credentail forAuthenticationChallenge:challenge];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Message" message:@"Invalid credentails" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
//        [alert release];
    }
}

- (void)webView:(WKWebView *)webView
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSLog(@"got to completion handler");
    
    NSURLCredential *creds = [[NSURLCredential alloc] initWithUser:self.username
                                                          password:self.password
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
