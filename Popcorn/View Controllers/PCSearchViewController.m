//
//  PCSearchViewController.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/16/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCSearchViewController.h"
#import "SearchCell.h"
#import "Movie.h"
#import "UIImageView+AFNetworking.h"
#import "PCMovieDetailViewController.h"
#import "JGProgressHUD.h"
#import "APIManager.h"

@interface PCSearchViewController () 
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) NSArray *filteredMovieObjects;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *moviesArray;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) NSString *currentSearchText;
@property (strong, nonatomic) JGProgressHUD *HUD;
-(void)searchAndFilterWithSearchString:(NSString *)searchText andPageNumber:(NSString *) pageNumber;
@end

@implementation PCSearchViewController

int currentPageNumber = 1;
bool isMoreDataLoading = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Set up activity indicator for infinite scrolling
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"Loading";
    
    //set delegate and data sources
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.moviesArray = [NSMutableArray new];
    
    self.filteredData = self.data;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// method to continuously load data if there is more data
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.searchTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.searchTableView.bounds.size.height;
        
        // when the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.searchTableView.isDragging) {
            self.isMoreDataLoading = true;
            // Start animating the progress indicator
            [self.HUD showInView:self.view];
            [self loadMoreData];
        }
    }
    
}

// helper function to load more data
-(void)loadMoreData{
    currentPageNumber += 1;
    [self searchAndFilterWithSearchString:self.currentSearchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber]];
    self.isMoreDataLoading = false;
    // Stop animating the progress indicator
    [self.HUD dismissAnimated:YES];
    // Reload the table view
    [self.searchTableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // dequeue a reusable Search cell
    SearchCell *cell = [self.searchTableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    // change array of dictionaries to an array of movies
    self.filteredMovieObjects = [Movie moviesWithDictionaries:self.filteredData];
    
    // Get current movie
    Movie *movie = self.filteredMovieObjects[indexPath.row];
    
    // set cell label to text from particular row in array
    cell.titleLabel.text = movie.title;
    cell.releaseDateLabel.text = movie.releaseDateString;
    
    // set poster picture
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:movie.posterUrl];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"cellToDetailSegue" sender:cell];
}

// Error method that creates an alert if there's an error from a network call and allows user to try again
-(void)networkCallErrorHandler:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    NSLog(@"%@", error.localizedDescription);
    
    // create a dismiss action
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss Error" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
    // add the dismiss action to the alertController
    [alert addAction:dismiss];
    
    NSLog(@"%@", [error localizedDescription]);
}

// helper function that filters network call results with search query
-(void)searchAndFilterWithSearchString:(NSString *)searchText andPageNumber:(NSString *) pageNumber{
    if ([searchText isEqualToString:@""]){
        self.filteredData = nil;
        currentPageNumber = 1;
        [self.searchTableView reloadData];
    }
    else if (searchText.length != 0) {
        // network call to get the search results with a completion handler
        [[APIManager shared] searchMoviesWithString:self.currentSearchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber] andResultsCompletionHandler:^(NSArray *results) {
            // set up predicate for searching movies
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
                return [item[@"title"] containsString:searchText];
            }];
            
            self.filteredData = [results filteredArrayUsingPredicate:predicate];
            [self.searchTableView reloadData];
        } andErrorCompletionHandler:^(NSError *error) {
            [self networkCallErrorHandler:error];
        }];
    }
    // if user hasn't typed anything then don't filter movies
    else {
        self.filteredData = self.moviesArray;
    }
}



// called when user starts typing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.currentSearchText = searchText;
    currentPageNumber = 1;
    
    // API call to search
    [[APIManager shared] searchMoviesWithString:self.currentSearchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber] andResultsCompletionHandler:^(NSArray *results) {
        // set up predicate for searching movies
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
            return [item[@"title"] containsString:searchText];
        }];
        
        self.filteredData = [results filteredArrayUsingPredicate:predicate];
        [self.searchTableView reloadData];
    } andErrorCompletionHandler:^(NSError *error){
        [self networkCallErrorHandler:error];
    }];
    
    // scroll back to the top
    [self.searchTableView setContentOffset:CGPointMake(0.0f, -self.searchTableView.contentInset.top) animated:YES];
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.currentSearchText = searchBar.text;
    [self searchAndFilterWithSearchString:self.currentSearchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.filteredData = nil;
    currentPageNumber = 1;
    [self.searchTableView reloadData];
    
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"cellToDetailSegue"]){
        // Get the detail view controller using [segue destinationViewController].
        PCMovieDetailViewController *detailVC = [segue destinationViewController];
        
        // Pass the selected cell's movie object to the detail view controller.
        SearchCell *cell = sender;
        NSIndexPath *cellPath = [self.searchTableView indexPathForCell:cell];
        detailVC.movie = self.filteredMovieObjects[cellPath.row];
    }
}

@end
