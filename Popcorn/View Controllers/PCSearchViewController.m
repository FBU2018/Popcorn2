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
-(void)testCapitalize;
@end

@implementation PCSearchViewController

int currentPageNumber = 1;
bool isMoreDataLoading = false;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testCapitalize];
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
    
    // set rating
    cell.ratingLabel.text = [@"Average rating: " stringByAppendingString:[[movie.rating stringValue] stringByAppendingString:@"/10"]];;
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

// Defines actions that happen when user swipes right on a shelf and picks a button
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    SearchCell *tappedCell = cell;
    switch (index) {
        case 0:
        {
            //Watch trailer
            [self performSegueWithIdentifier:@"shelfToTrailer" sender:cell];
            break;
        }
        case 1:
        {
            //Add to shelf
            [self performSegueWithIdentifier:@"shelfToPicker" sender:cell];
            break;
        }
        default:
            break;
    }
}

// Defines buttons that are shown when user swipes right on a cell
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f]
                                                title:@"Trailer"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Add to"];
    
    return rightUtilityButtons;
}

// Manual segue to go to Details VC from tapped cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"cellToDetailSegue" sender:cell];
}

// Error method that creates an alert if there's an error from a network call and allows user to dismiss the error message
-(void)networkCallErrorHandler:(NSError *)error{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movie" message:@"There seems to be a problem with your search query. Please try again." preferredStyle:(UIAlertControllerStyleAlert)];
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
        // Update current search text
        self.currentSearchText = searchText;
//        // Capitalize first letter of search text
//        self.currentSearchText = [NSString stringWithFormat:@"%@%@",[[self.currentSearchText substringToIndex:1] uppercaseString],[self.currentSearchText substringFromIndex:1] ];

        // Change search text to be compatible with query characters
        self.currentSearchText = [self.currentSearchText stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        
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

-(void)testCapitalize{
    NSString *abc = @"this is test for people who do stuff";
    
    abc = [NSString stringWithFormat:@"%@%@",[[abc substringToIndex:1] uppercaseString],[abc substringFromIndex:1] ];
    NSLog(@"abc = %@",abc);
}


// called when user starts typing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(![searchText isEqualToString:@""]){
        self.currentSearchText = searchText;
        currentPageNumber = 1;
        

        
        // Change search text to be compatible with query characters
        self.currentSearchText = [self.currentSearchText stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        
        // API call to search
        [[APIManager shared] searchMoviesWithString:self.currentSearchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber] andResultsCompletionHandler:^(NSArray *results) {
            // Put search text for filtering into proper case
            self.currentSearchText = [self.currentSearchText lowercaseString];
            // Capitalize first letter of search text
            self.currentSearchText = [NSString stringWithFormat:@"%@%@",[[self.currentSearchText substringToIndex:1] uppercaseString],[self.currentSearchText substringFromIndex:1] ];
            
            // set up predicate for searching movies
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
                return [item[@"title"] containsString:self.currentSearchText];
            }];
            
            self.filteredData = [results filteredArrayUsingPredicate:predicate];
            [self.searchTableView reloadData];
        } andErrorCompletionHandler:^(NSError *error){
            [self networkCallErrorHandler:error];
        }];
        
        // scroll back to the top
        [self.searchTableView setContentOffset:CGPointMake(0.0f, -self.searchTableView.contentInset.top) animated:YES];
    }
    else{
        self.filteredData = nil;
        currentPageNumber = 1;
        [self.searchTableView reloadData];
    }
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
