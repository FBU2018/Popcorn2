//
//  PCProfileViewController.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/23/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCProfileViewController.h"
#import "Parse.h"
#import "APIManager.h"
#import "LibraryCell.h"
#import "PCShelfViewController.h"
#import "ParseUI.h"

@interface PCProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *shelves; // array of dictionaries about each shelf
@property (strong, nonatomic) NSMutableArray *allMovies; //contains all Movie objects in all of user's lists
@property (strong, nonatomic) NSMutableArray *moviesInList; //helper
@property (strong, nonatomic) NSArray *filteredData; //for search

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *userShelvesLabel;

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;


@end

@implementation PCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // check if showing the logged in user's profile or another user's profile
    if(self.currentUser == nil){
        self.currentUser = [PFUser currentUser];
    }

    //sets all labels at the top of the screen
    [self setViews];
    
    // Call method to get users list given their session id
    [self getProfileLists];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (IBAction)didTapFollow:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setViews{
    // Show the current users username and followers and following count
    self.usernameLabel.text = self.currentUser.username;
    self.userShelvesLabel.text = [self.currentUser.username stringByAppendingString:@"'s Shelves"];
    
    //set image if file is not nil
    PFFile *imageFile = self.currentUser[@"userImage"];
    if(imageFile != nil){
        self.profileImage.file = imageFile;
        [self.profileImage loadInBackground];
    }
    //make it a circle
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    //gesture recognizer
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.profileImage setUserInteractionEnabled:YES];
    [self.profileImage addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)didTap:(id)sender {
    //when tapped, goes to an image picker
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //image picker presented, can pick images
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    self.profileImage.image = editedImage;
    PFFile *userImageFile = [PFFile fileWithData: UIImageJPEGRepresentation(editedImage, 1.0)];
    
    //Save user's profile image
    self.currentUser[@"userImage"] = userImageFile;
    [self.currentUser saveInBackground];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// Define a method that gets a given user's lists
-(void)getProfileLists{
    [[APIManager shared] getShelvesWithSessionId:self.currentUser[@"sessionId"] andAccountId:self.currentUser[@"accountId"] andCompletionBlock:^(NSDictionary *shelves, NSError *error) {

        if(error == nil){
            self.shelves = shelves[@"results"];
            self.filteredData = self.shelves;
            NSLog(@"Successfully got all of profile user's shelves");
            [self.tableView reloadData];
            
            // for updating allMovies array
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileLibraryCell"];
    unsigned long count = self.filteredData.count;
    
    // configure details of the cell
    //fill cells in backwards order: newly created shelves will now appear at the bottom
    [cell configureCell:self.filteredData[count - 1 - indexPath.row]];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shelves.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"libraryToShelf" sender:cell];
}

 #pragma mark - Navigation
 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"libraryToShelf"]){
        //pass the shelfId and shelves array
        LibraryCell *tappedCell = sender;
        PCShelfViewController *receiver = [segue destinationViewController];
        receiver.shelfId = tappedCell.shelfId;
        receiver.shelves = self.shelves;
    }
}

@end
