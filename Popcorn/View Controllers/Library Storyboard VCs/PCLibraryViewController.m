//
//  LibraryViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCLibraryViewController.h"
#import "APIManager.h"
#import "LibraryCell.h"
#import "Movie.h"
#import "PCShelfViewController.h"
#import "UIImageView+AFNetworking.h"
#import <SWTableViewCell.h>
#import "AppDelegate.h"
#import "Parse/Parse.h"
#import "PCLoginViewController.h"
#import "JGProgressHUD.h"


@interface PCLibraryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SWTableViewCellDelegate>

//array of shelf dictionaries
@property (strong, nonatomic) NSArray *shelves; //array of dictionaries about each shelf
@property (strong, nonatomic) NSMutableArray *allMovies; //contains all Movie objects in all of user's lists
@property (strong, nonatomic) NSMutableArray *moviesInList; //helper
@property (strong, nonatomic) NSArray *filteredData; //for search

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITabBarItem *tabBarButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) JGProgressHUD *HUD;

@end

@implementation PCLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"Loading";
    [self.HUD showInView:self.view];

    //instantiate all arrays
    self.shelves = [NSArray new];
    self.filteredData = [NSArray new];
    self.moviesInList = [NSMutableArray new];
    self.allMovies = [NSMutableArray new];
    //sets delegates
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self getLists];
    
    //setting refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getLists) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self getLists];
}

- (IBAction)didTapSafari:(id)sender {
    [self performSegueWithIdentifier:@"libraryToSafari" sender:nil];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //filter for shelfs with its name including search text
    if (searchText.length != 0) {
        //case does not matter
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *shelf, NSDictionary *bindings) {
            NSString *modifiedSearchText = [searchText lowercaseString];
            //make each starting letter capital
            modifiedSearchText = [NSString stringWithFormat:@"%@%@",[[modifiedSearchText substringToIndex:1] uppercaseString],[modifiedSearchText substringFromIndex:1] ];
            return [shelf[@"name"] containsString:modifiedSearchText];
        }];
        self.filteredData = [self.shelves filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredData);
    }
    else {
        self.filteredData = self.shelves;
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //reset filter, cancel search text
    self.filteredData = self.shelves;
    [self.tableView reloadData];

    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LibraryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"libraryToShelf" sender:cell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryCell" forIndexPath:indexPath];
    unsigned long count = self.filteredData.count;
    
    //fill cells in backwards order: newly created shelves will now appear at the bottom
    [cell configureCell:self.filteredData[count - 1 - indexPath.row]];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons
{
    //swipeable cell has one delete option
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    double sizeView = self.view.frame.size.height;
//    double yOffset = scrollView.frame.size.height;
//    if(sizeView+yOffset >= scrollView.frame.size.height){
////        scrollView.scrollEnabled = NO;
//        
//        NSLog(@"reached");
////        [scrollView setContentSize:CGSizeMake(375, sizeView + yOffset)];
//        
////        CGPoint offset = scrollView.contentOffset;
////        [scrollView setContentOffset:offset];
//        
////        scrollView.scrollEnabled = NO;
////        scrollView.scrollEnabled = YES;
//        
////        CGPoint offset = scrollView.contentOffset;
////        offset.x -= 1.0;
////        offset.y -= 1.0;
////        [scrollView setContentOffset:offset animated:NO];
////        offset.x += 1.0;
////        offset.y += 1.0;
////        [scrollView setContentOffset:offset animated:NO];
//    }
//
//}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            //Delete button was pressed
            NSLog(@"Delete button was pressed");
            LibraryCell *sender = cell;
            NSNumber *shelfId = sender.shelfId;
            NSString *shelfIdString = [shelfId stringValue];
            [self deleteList:shelfIdString];
            
            break;
        }
        default:
            break;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredData.count;
}


- (void)createList:(NSString *)name {
    //create new list with given name
    [[APIManager shared] createList:name withSessionId: PFUser.currentUser[@"sessionId"] completion:^(NSString *listId, NSError *error) {
        if(error){
            NSLog(@"Error creating list: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully created list");
            [self getLists];
            [self.tableView reloadData];
        }
    }];
}

- (void)getLists{
    //gets a dictionary of all of user's saved lists
    [[APIManager shared] getShelvesWithSessionId:PFUser.currentUser[@"sessionId"] andAccountId: PFUser.currentUser[@"accountId"] andCompletionBlock:^(NSArray *results, NSError *error) {
        if(error == nil){
            self.shelves = results;
            self.filteredData = self.shelves;
            NSLog(@"Successfully got all of user's shelves");
            [self.refreshControl endRefreshing];
            [self.HUD dismissAnimated:YES];
            [self.tableView reloadData];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}


- (IBAction)didTapPlus:(id)sender {
    //shows alert to create new shelf
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Create a New Shelf" message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    //Cancel and create options
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        
        //create list if name is inputted
        if([namefield.text isEqualToString:@""] == NO){
            [self createList:namefield.text];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)deleteList: (NSString*) shelfId{
    //makes request to delete the shelf with the given shelfId
    [[APIManager shared] deleteList:shelfId withSessionId: PFUser.currentUser[@"sessionId"] completion:^(NSError *error) {
        if(error == nil){
            NSLog(@"Successfully deleted shelf");
            [self getLists];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
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
