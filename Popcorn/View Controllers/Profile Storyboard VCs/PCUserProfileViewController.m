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

@interface PCUserProfileViewController () <UITableViewDelegate, UITableViewDataSource, ProfileInfoCellDelegate>


@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *shelves; // array of dictionaries about each shelf
@property (strong, nonatomic) NSMutableArray *allMovies; //contains all Movie objects in all of user's lists
@property (strong, nonatomic) NSMutableArray *moviesInList; //helper

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PCUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.currentUser == nil){
        // showing logged in user's profile
        self.currentUser = [PFUser currentUser];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //setting refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getProfileLists) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Call method to get users list given their session id
    [self getProfileLists];
}

// Define a method that gets a given user's lists
-(void)getProfileLists{
    [[APIManager shared] getShelvesWithSessionId:self.currentUser[@"sessionId"] andAccountId:self.currentUser[@"accountId"] andCompletionBlock:^(NSDictionary *shelves, NSError *error) {
        
        if(error == nil){
            self.shelves = shelves[@"results"];
            NSLog(@"Successfully got all of profile user's shelves");
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
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
        [cell configureCell:self.currentUser];
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


- (void)profileInfoCell:(ProfileInfoCell *)cell didTapFollow:(PFUser *)user {
    //    //check that user is not yourself
    //    if([self.currentUser[@"accountId"] isEqualToString:PFUser.currentUser[@"accountId"]] == NO){
    //        //if not following, follow
    //        //if following, unfollow
    //    }
    NSLog(@"follow pressed");
    
    
//    // Get logged in user's PFUser object
//    PFUser *loggedInUser = [PFUser currentUser];
//    // Update array of following in logged in users PFUser object
//    [loggedInUser[@"following"] addObject:self.currentUser.username];
//    // Update array of followers in other users PFUser object
//    [self.currentUser[@"followers"] addObject:loggedInUser.username];
//    // Save current and logged-in's users objects to Parse
//    NSArray *objects = [NSArray arrayWithObjects:self.currentUser, loggedInUser, nil];
//    [PFObject saveAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
//
//    }];
//
//    NSLog(@"Ruchas following: %@", loggedInUser[@"following"]);
//    NSLog(@"Sarahs followers: %@", self.currentUser[@"followers"]);
    
}

- (void)profileInfoCell:(ProfileInfoCell *)cell didTapPicture:(PFUser *)user{
    //when tapped, goes to an image picker
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:^{
    }];
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
