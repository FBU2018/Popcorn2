//
//  PCLoginViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/20/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCLoginViewController.h"
#import "Parse.h"
#import "APIManager.h"

@interface PCLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation PCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)didTapLogin:(id)sender {
    [self loginUser];
}

- (IBAction)didTapNewAccount:(id)sender {
    if([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Email and password required"
                                                                       message:@"Please enter both your email and password"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    else{
        [self registerUser];
    }
}


- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    //    newUser.email = self.emailField.text;
    newUser.password = self.passwordTextField.text;
    newUser[@"following"] = @"";
    newUser[@"followers"] = @"";
    newUser[@"reviews"] = [NSMutableArray new];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error creating account"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {
            NSLog(@"User registered successfully");
            
            [[APIManager shared] getRequestToken:^(NSString *requestToken, NSError *error) {
                if(error != nil){
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    //authenticate with website
                }
            }];
            
//            PFUser *curr = PFUser.currentUser;
//            curr[@"UserId"] = @"7966256";
//            curr[@"Followers"] = [NSMutableArray new];
//            curr[@"Reviews"] = [NSMutableArray new];
//            [curr saveInBackground];
            
            [self performSegueWithIdentifier:@"loginToMain" sender:nil];
        }
    }];
}

- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User log in failed"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {
            NSLog(@"User logged in successfully");
            
            [self performSegueWithIdentifier:@"loginToMain" sender:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)didTapLogin:(id)sender {
////    [self performSegueWithIdentifier:@"loginToWebLogin" sender:nil];
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
