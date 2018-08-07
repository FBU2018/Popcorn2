//
//  ShelfViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCShelfViewController.h"
#import "SearchCell.h"
#import "APIManager.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"
#import "PCMovieDetailViewController.h"
#import <SWTableViewCell.h>
#import "PCTrailerViewController.h"
#import "PCShelfPickerViewController.h"
#import "Parse.h"

@interface PCShelfViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (strong, nonatomic) NSArray *movieArray; //all movies in the shelf
@property (strong, nonatomic) NSArray *filteredData; //for search
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PCShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // 0 footer
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.movieArray = [NSArray new];
    self.filteredData = [NSArray new];
    
    if(self.shelfId != nil){
        [self getMovies: [self.shelfId stringValue]];
    }
    //setting refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(performGetMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)performGetMovies{
    [self getMovies:[self.shelfId stringValue]];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if(self.shelfId != nil){
        [self getMovies:[self.shelfId stringValue]];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *movie, NSDictionary *bindings) {
            //case doesn't affect searching
            NSString *modifiedSearchText = [searchText lowercaseString];
            //make each starting letter capital
            modifiedSearchText = [NSString stringWithFormat:@"%@%@",[[modifiedSearchText substringToIndex:1] uppercaseString],[modifiedSearchText substringFromIndex:1] ];
            return [movie.title containsString:modifiedSearchText];
        }];
        self.filteredData = [self.movieArray filteredArrayUsingPredicate:predicate];
        NSLog(@"%@", self.filteredData);
    }
    else {
        self.filteredData = self.movieArray;
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.filteredData = self.movieArray;
    [self.tableView reloadData];
    
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    Movie *movie = self.filteredData[indexPath.row];
    cell.movie = movie;
    
    [cell configureCell:movie];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons
{
    //3 options in swipeable cell: Remove, Trailer, Add to
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:0.8f]
                                                title:@"Remove"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.3f green:0.0f blue:1.0f alpha:0.4f]
                                                title:@"Trailer"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.0]
                                                title:@"Add to"];

    return rightUtilityButtons;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"shelfToDetail" sender:cell];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    SearchCell *tappedCell = cell;
    switch (index) {
        case 0:
        {
            //Remove from shelf
            [[APIManager shared] removeItem:[self.shelfId stringValue] forItem:tappedCell.movie withSessionId: PFUser.currentUser[@"sessionId"] completion:^(NSError *error) {
                if(error == nil){
                    NSLog(@"succesfully removed item from list");
                    [self getMovies:[self.shelfId stringValue]];
                }
                else{
                    NSLog(@"error: %@", error.localizedDescription);
                }
            }];
            break;
        }
        case 1:
        {
            //Watch trailer
            [self performSegueWithIdentifier:@"shelfToTrailer" sender:cell];
            break;
        }
        case 2:
        {
            //Add to shelf
            [self performSegueWithIdentifier:@"shelfToPicker" sender:cell];
            break;
        }
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredData.count;
}

- (void)getMovies: (NSString *) shelfId{
    //gets movies for given shelfId and updates tableview
    [[APIManager shared] getShelfMovies:shelfId completion:^(NSArray *movies, NSError *error) {
        if(error == nil){
            NSLog(@"Successfully got movies on shelves");
            
            NSMutableArray *moviesArray = [NSMutableArray array];
            moviesArray = [Movie moviesWithDictionaries:movies];
            self.filteredData = moviesArray;
            self.movieArray = moviesArray;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            
            if(self.movieArray.count == 0){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Movies"
                                                                               message:@"This shelf has no movies"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
                // create an ok action, add to alert
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //go back to Library
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{
                }];
            }
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"shelfToDetail"]){
        SearchCell *tappedCell = sender;
        PCMovieDetailViewController *receiver = [segue destinationViewController];
        receiver.movie = tappedCell.movie;
        receiver.shelves = self.shelves;
    }
    else if([segue.identifier isEqualToString:@"shelfToTrailer"]){
        SearchCell *tappedCell = sender;
        PCTrailerViewController *receiver = [segue destinationViewController];
        receiver.movie = tappedCell.movie;
    }
    else if([segue.identifier isEqualToString:@"shelfToPicker"]){
        SearchCell *tappedCell = sender;
        PCShelfPickerViewController *receiver = [segue destinationViewController];
        receiver.movie = tappedCell.movie;
        receiver.shelves = self.shelves;
    }
}


@end
