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


@interface PCShelfViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SWTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (strong, nonatomic) NSArray *movieArray; //all movies in the shelf
@property (strong, nonatomic) NSArray *filteredData; //for search

@end

@implementation PCShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.movieArray = [NSArray new];
    self.filteredData = [NSArray new];
    
    if(self.shelfId != nil){
        [self getMovies: [self.shelfId stringValue]];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Movie *movie, NSDictionary *bindings) {
            return [movie.title containsString:searchText];
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
    
    //TODO: eventually combine the following into setCell method in searchCell
    Movie *movie = self.filteredData[indexPath.row];
    cell.movie = movie;
    cell.titleLabel.text = movie.title;
    cell.releaseDateLabel.text = movie.releaseDateString;
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:movie.posterUrl];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Remove"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f]
                                                title:@"Trailer"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Add to"];

    return rightUtilityButtons;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"shelfToDetail" sender:cell];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    SearchCell *tappedCell = cell;
    switch (index) {
        case 0:
        {
            //Remove from shelf
            [[APIManager shared] removeItem:[self.shelfId stringValue] forItem:tappedCell.movie completion:^(NSError *error) {
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
            break;
        }
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredData.count;
}

- (void)getMovies: (NSString *) movieId{

    [[APIManager shared] getShelfMovies:movieId completion:^(NSArray *movies, NSError *error) {
        if(error == nil){
            NSLog(@"Successfully got movies on shelves");
            
            NSMutableArray *moviesArray = [NSMutableArray array];
            moviesArray = [Movie moviesWithDictionaries:movies];
            self.filteredData = moviesArray;
            self.movieArray = moviesArray;
            [self.tableView reloadData];
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
    }
    else if([segue.identifier isEqualToString:@"shelfToTrailer"]){
        SearchCell *tappedCell = sender;
        PCTrailerViewController *receiver = [segue destinationViewController];
        receiver.movie = tappedCell.movie;
    }
}


@end
