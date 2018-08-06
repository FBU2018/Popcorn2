//
//  PCUserSearchViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/24/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCUserSearchViewController.h"
#import "PFUser+ExtendedUser.h"
#import "UserSearchCell.h"
//#import "PCProfileViewController.h"
#import "PCUserProfileViewController.h"

@interface PCUserSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UserSearchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(strong, nonatomic) NSMutableArray *users;
@property(strong, nonatomic) NSMutableArray *filteredUsers;

@end

@implementation PCUserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.users = [NSMutableArray new];
    
    [self getUserArray];
}

- (void)getUserArray{
    //get array of PFUsers from Parse
    
    // construct query
    PFQuery *query = [PFUser query];
    //most active users show up first
    [query orderByDescending:@"updatedAt"];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.users = [users mutableCopy];
            for(PFUser *user in users){
                if([user.username isEqualToString:PFUser.currentUser.username]){
                    [self.users removeObject:user];
                }
            }
            self.filteredUsers = self.users;
//            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSearchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserSearchCell"];
    cell.delegate = self;
    [cell configureCell:self.filteredUsers withIndexPath:indexPath];
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //filter for users with name given
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(PFUser *user, NSDictionary *bindings) {
            NSString *usernameLower = [user.username lowercaseString];
            NSString *searchTextLower = [searchText lowercaseString];
            return [usernameLower containsString:searchTextLower];
        }];
        NSArray *tempArray = [self.users filteredArrayUsingPredicate:predicate];
        self.filteredUsers = [tempArray mutableCopy];
    }
    else {
        self.filteredUsers = self.users;
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //reset filter, cancel search text
    self.filteredUsers = self.users;
    [self.tableView reloadData];
    
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userSearchCell:(UserSearchCell *)cell didTapFollow:(PFUser *)user{
    NSLog(@"Follow pressed");
    PFUser *loggedInUser = PFUser.currentUser;
    if(!cell.following){
        // Was not following current user
        [loggedInUser follow:cell.user withCompletionBlock:^(BOOL success) {
            NSLog(@"Successfully followed!");
            [cell setButton];
//            [self.tableView reloadData];
//            [self alertWithString:@"Successfully followed!"];
//            [self getProfileLists];
        }];
    }
    else{
        // Was already following current user
        [loggedInUser unfollow:cell.user withCompletionBlock:^(BOOL success) {
            NSLog(@"Successfully unfollowed!");
            [cell setButton];
//            [self.tableView reloadData];
//            [self alertWithString:@"Successfully unfollowed!"];
//            [self getProfileLists];
        }];
    }
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"userSearchToProfile"]){
        UserSearchCell *cell = sender;
        PCUserProfileViewController *receiver = [segue destinationViewController];
        receiver.currentUser = cell.user;
    }
}


@end
