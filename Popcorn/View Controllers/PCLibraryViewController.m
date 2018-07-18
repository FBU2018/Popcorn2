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


@interface PCLibraryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SWTableViewCellDelegate>

//array of shelf dictionaries
@property (strong, nonatomic) NSArray *shelves; //array of dictionaries about each shelf
@property (strong, nonatomic) NSMutableArray *allMovies; //contains all Movie objects in all of user's lists
@property (strong, nonatomic) NSMutableArray *moviesInList; //helper
@property (strong, nonatomic) NSArray *filteredData; //for search

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation PCLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.shelves = [NSArray new];
    self.filteredData = [NSArray new];
    self.moviesInList = [NSMutableArray new];
    self.allMovies = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    
    [self getLists];

}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *shelf, NSDictionary *bindings) {
            return [shelf[@"name"] containsString:searchText];
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
    LibraryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"libraryToShelf" sender:cell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryCell" forIndexPath:indexPath];
    unsigned long count = self.filteredData.count;
    [cell configureCell:self.filteredData[count - 1 - indexPath.row]];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    return rightUtilityButtons;
}

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
    [[APIManager shared] createList:name completion:^(NSString *listId, NSError *error) {
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
    [[APIManager shared] getShelves:^(NSDictionary *shelves, NSError *error) {
        if(error == nil){
            self.shelves = shelves[@"results"];
            self.filteredData = self.shelves;
            NSLog(@"Successfully got all of user's shelves");
            [self.tableView reloadData];
            
            //for updating allMovies array
            [self updateAllLists];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)updateAllLists{
    //creates array of all movies in all lists and stores in array allMovies
    [self.allMovies removeAllObjects];
    NSMutableArray *shelfIds = [NSMutableArray new];
    for(NSDictionary *list in self.shelves){
        NSNumber *shelfIdNum = list[@"id"];
        NSString *shelfId = [shelfIdNum stringValue];
        [shelfIds addObject:shelfId];
    }
    //have gotten all shelf id numbers, now getting movies from each shelf (which adds to the allMovies array)
    for(NSString *shelfId in shelfIds){
        [self getMovies:shelfId];
    }
}


- (void)getMovies: (NSString *) movieId{
    //HELPER METHOD for updateAllLists: gets movies for given shelf id and stores in moviesInList
    [[APIManager shared] getShelfMovies:movieId completion:^(NSArray *movies, NSError *error) {
        if(error == nil){
            NSLog(@"Successfully got movies on shelves");
            
            NSMutableArray *moviesArray = [NSMutableArray array];
            moviesArray = [Movie moviesWithDictionaries:movies];
            self.moviesInList = moviesArray;
            
            //updating for updateAllLists
            [self.allMovies addObjectsFromArray:self.moviesInList];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (IBAction)didTapPlus:(id)sender {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Create a New Shelf" message: nil
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Create" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        
        if([namefield.text isEqualToString:@""] == NO){
            [self createList:namefield.text];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (IBAction)didTapDelete:(id)sender {
    [[APIManager shared] deleteList:@"82362" completion:^(NSError *error) {
        if(error == nil){
            NSLog(@"Successfully deleted shelf");
            [self getLists];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)deleteList: (NSString*) shelfId{
    [[APIManager shared] deleteList:shelfId completion:^(NSError *error) {
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
        LibraryCell *tappedCell = sender;
        PCShelfViewController *receiver = [segue destinationViewController];
        receiver.shelfId = tappedCell.shelfId;
    }
}


@end
