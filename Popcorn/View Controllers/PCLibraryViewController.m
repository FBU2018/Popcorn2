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

@interface PCLibraryViewController () <UITableViewDelegate, UITableViewDataSource/*, UISearchBarDelegate*/>

//array of shelf dictionaries
@property (strong, nonatomic) NSArray *shelves;
@property (strong, nonatomic) NSMutableArray *allMovies; //contains all movie objects in all of user's lists
@property (strong, nonatomic) NSMutableArray *moviesInList;
@property (strong, nonatomic) NSArray *filteredData;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation PCLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.shelves = [NSArray new];
    self.moviesInList = [NSMutableArray new];
    self.allMovies = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.searchBar.delegate = self;
    
    
    [self getLists];

}

//TO DISCUSS: move searching all movies to stretch goal?

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//
//    if (searchText.length != 0) {
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *movie, NSDictionary *bindings) {
//            return [movie.title containsString:searchText];
//        }];
//
//        self.filteredData = [self.allMovies filteredArrayUsingPredicate:predicate];
//        NSLog(@"allMovies: %@", self.allMovies);
//
//        NSLog(@"%@", self.filteredData);
//    }
//    else {
//        self.filteredData = self.allMovies;
//    }
//
//    [self.tableView reloadData];
//}
//
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
//    self.searchBar.showsCancelButton = YES;
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
//    self.filteredData = self.allMovies;
//    [self.tableView reloadData];
//
//    self.searchBar.showsCancelButton = NO;
//    self.searchBar.text = @"";
//    [self.searchBar resignFirstResponder];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LibraryCell" forIndexPath:indexPath];
    [cell configureCell:self.shelves[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shelves.count;
}


- (IBAction)didTapCreate:(id)sender {
    [[APIManager shared] createList:@"Test" completion:^(NSString *listId, NSError *error) {
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
