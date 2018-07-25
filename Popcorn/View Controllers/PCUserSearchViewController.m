//
//  PCUserSearchViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/24/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCUserSearchViewController.h"
#import "Parse.h"
#import "UserSearchCell.h"
#import "PCProfileViewController.h"

@interface PCUserSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property(strong, nonatomic) NSArray *users;
@property(strong, nonatomic) NSArray *filteredUsers;

@end

@implementation PCUserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.users = [NSArray new];
    
    [self getUserArray];
}

- (void)getUserArray{
    //get array of PFUsers from Parse
    
    // construct query
    PFQuery *query = [PFUser query];
//    [query orderByDescending:@"createdAt"];
//    self.numTimes++;
//    query.limit = self.numTimes * 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if (users != nil) {
            self.users = users;
            self.filteredUsers = users;
//            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserSearchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserSearchCell"];
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
        self.filteredUsers = [self.users filteredArrayUsingPredicate:predicate];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"userSearchToProfile"]){
        UserSearchCell *cell = sender;
        PCProfileViewController *receiver = [segue destinationViewController];
        receiver.currentUser = cell.user;
    }
}


@end
