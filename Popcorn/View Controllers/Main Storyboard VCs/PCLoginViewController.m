//
//  PCLoginViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/20/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCLoginViewController.h"
#import "PFUser+ExtendedUser.h"
#import "APIManager.h"
#import "PCWebLoginViewController.h"

@interface PCLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) NSString *targetURL;


@end

@implementation PCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.passwordTextField.secureTextEntry = YES;
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
    // Initialize a relations object
    Relations *relations = [Relations object];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    //    newUser.email = self.emailField.text;
    newUser.password = self.passwordTextField.text;
    newUser[@"accountId"] = @"";
    newUser[@"sessionId"] = @"";
    newUser[@"following"] = [NSMutableArray new];
    newUser[@"followers"] = [NSMutableArray new];
    newUser[@"reviews"] = [NSMutableArray new];
    newUser.relations = relations;
    
    //set image to temporary image
    UIImage *myImage = [UIImage imageNamed:@"person placeholder"];
    PFFile *temporaryImage = [PFFile fileWithData: UIImageJPEGRepresentation(myImage, 1.0)];
    newUser[@"userImage"] = temporaryImage;
    
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
            //User has successfully made Parse account
            NSLog(@"User registered successfully");
            
            [PFUser logInWithUsernameInBackground:newUser.username password:newUser.password block:^(PFUser * user, NSError *  error) {
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
                    //User has successfully logged into Parse account
                    NSLog(@"User logged in successfully");
                    [relations saveInBackground];

                    //get request token
                    [[APIManager shared] getRequestToken3:^(NSString *requestToken, NSError *error) {
                        if(error != nil){
                            NSLog(@"Error: %@", error.localizedDescription);
                        }
                        else{
                            NSLog(@"request token: %@", requestToken);
                            self.targetURL = requestToken;
                            //authenticate with website
                            [self performSegueWithIdentifier:@"loginToWebLogin" sender:self];
                        }
                    }];
                }
            }];
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
            
            //get request token
            [[APIManager shared] getRequestToken3:^(NSString *requestToken, NSError *error) {
                if(error != nil){
                    NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    NSLog(@"request token: %@", requestToken);
                    self.targetURL = requestToken;
                    //authenticate with website
                    [self performSegueWithIdentifier:@"loginToWebLogin" sender:self];
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
    if([segue.identifier isEqualToString:@"loginToWebLogin"]){
        PCWebLoginViewController *reciever = [segue destinationViewController];
        reciever.targetURL = self.targetURL;
    }
}


@end
