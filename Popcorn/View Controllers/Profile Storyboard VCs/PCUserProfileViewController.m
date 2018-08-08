//
//  PCUserProfileViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCUserProfileViewController.h"
#import "ParseUI.h"
#import "APIManager.h"
#import "ProfileInfoCell.h"
#import "LibraryCell.h"
#import "PCShelfViewController.h"
#import <Parse/Parse.h>
#import "PFUser+ExtendedUser.h"
#import "AppDelegate.h"
#import "PCLoginViewController.h"
#import "JGProgressHUD.h"

@interface PCUserProfileViewController () <UITableViewDelegate, UITableViewDataSource, ProfileInfoCellDelegate>


@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) JGProgressHUD *HUD;
@property (strong, nonatomic) NSArray *shelves; // array of dictionaries about each shelf
@property (strong, nonatomic) NSMutableArray *allMovies; //contains all Movie objects in all of user's lists
@property (strong, nonatomic) NSMutableArray *moviesInList; //helper
@property (nonatomic) BOOL following;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutButton;


-(void)alertWithString:(NSString *)message;
- (IBAction)didTapSearch:(id)sender;


@end

@implementation PCUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

-(void)setUpView{
    if(self.currentUser == nil){
        // showing logged in user's profile
        self.currentUser = [PFUser currentUser];
    }
    else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    // Determine if loggedin User is already following current User
    PFUser *loggedInUser = PFUser.currentUser;
    [self.currentUser retrieveRelationsWithObjectID:self.currentUser.relations.objectId andCompletion:^(Relations *userRelations) {
        if([userRelations.myfollowers containsObject:loggedInUser.username]){
            // if user is already being followed then update following bool
            self.following = YES;
        }
        else{
            // if user is not already being followed then update following bool
            self.following = NO;
        }
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //setting refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getProfileLists) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"Loading";
    [self.HUD showInView:self.view];
    
    // Call method to get user's list given their session id
    [self getProfileLists];
}

// Define a method that gets a given user's lists
-(void)getProfileLists{
    [[APIManager shared] getShelvesWithSessionId:self.currentUser[@"sessionId"] andAccountId:self.currentUser[@"accountId"] andCompletionBlock:^(NSArray *results, NSError *error) {
        
        if(error == nil){
            self.shelves = results;
            NSLog(@"Successfully got all of profile user's shelves");
            [self.refreshControl endRefreshing];
            [self.HUD dismissAnimated:YES];
            [self.tableView reloadData];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapLogOut:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to log out?"
                                                                   message:nil
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    //cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //do nothing
    }];
    [alert addAction:cancelAction];
    
    //logout action
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Log Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //actually log out
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PCLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"PCLoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
        [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            // PFUser.current() will now be nil
        }];
    }];
    [logoutAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
    [alert addAction:logoutAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        //profileInfoCell
        ProfileInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileInfoCell" forIndexPath:indexPath];
        cell.delegate = self;
        [cell configureCell:self.currentUser withFollowing:self.following];
        return cell;
    }
    else{
        //LibraryCell
        LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileLibraryCell" forIndexPath:indexPath];
        cell.delegate = self;
//        unsigned long count = self.shelves.count;
        
        // configure details of the cell, -1 to account for other cell
        [cell configureCell:self.shelves[indexPath.row-1]];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row != 0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        LibraryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"libraryToShelf" sender:cell];
    }
    else{
        //top profile info part
        ProfileInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shelves.count + 1;
}

-(void)alertWithString:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Okay action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self setUpView];
            }];
    }];
                               
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)didTapSearch:(id)sender {
     [self performSegueWithIdentifier:@"profileToUserSearch" sender:nil];
}


- (void)profileInfoCell:(ProfileInfoCell *)cell didTapFollow:(PFUser *)user {
    PFUser *loggedInUser = PFUser.currentUser;
    // Call follow method if user is not already following current user, otherwise unfollow
    if(!self.following){
        // Was not following current user
        [loggedInUser follow:user withCompletionBlock:^(BOOL success) {
            if(success){
                self.following = YES;
                [self alertWithString:@"Successfully followed!"];
                [cell setButton];
                [self.tableView reloadData];
            }
        }];
    }
    else{
        // Was already following current user
        [loggedInUser unfollow:user withCompletionBlock:^(BOOL success) {
            if(success){
                self.following = NO;
                [self alertWithString:@"Successfully unfollowed!"];
                [cell setButton];
                [self.tableView reloadData];
            }
        }];
    }
    [self.tableView reloadData];
}

- (void)profileInfoCell:(ProfileInfoCell *)cell didTapPicture:(PFUser *)user{
    //when tapped, goes to an image picker if you're on your own profile
    if([user.username isEqualToString:PFUser.currentUser.username]){
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:imagePickerVC animated:YES completion:^{
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //image picker presented, can pick images
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    PFFile *userImageFile = [PFFile fileWithData: UIImageJPEGRepresentation(editedImage, 1.0)];
    
    //Save user's profile image
    self.currentUser[@"userImage"] = userImageFile;
    [self.currentUser saveInBackground];
    
    self.currentUser = PFUser.currentUser;
    [self dismissViewControllerAnimated:YES completion:^{
        [self getProfileLists];
    }];
}

- (void)profileInfoCell:(ProfileInfoCell *)cell didTapSearchUsers:(PFUser *)user{
    [self performSegueWithIdentifier:@"profileToUserSearch" sender:nil];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     if([segue.identifier isEqualToString:@"libraryToShelf"]){
         //pass the shelfId and shelves array
         LibraryCell *tappedCell = sender;
         PCShelfViewController *receiver = [segue destinationViewController];
         receiver.shelfId = tappedCell.shelfId;
         receiver.shelves = self.shelves;
     }
 }
 



@end
