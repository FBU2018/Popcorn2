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
#import "PCInfiniteScrollActivityIndicator.h"

@interface PCSearchViewController () 
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) NSArray *filteredMovieObjects;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *moviesArray;
@property (assign, nonatomic) BOOL isMoreDataLoading;
@property (strong, nonatomic) NSString *currentSearchText;
 -(void) searchMoviesWithString:(NSString *)searchString andPageNumber:(NSString*)pageNumber andCompletionHandler:(void (^) (NSArray*))completionHandler;
-(void)searchAndFilterWithSearchString:(NSString *)searchText andPageNumber:(NSString *) pageNumber;
@end

@implementation PCSearchViewController

int currentPageNumber = 1;
bool isMoreDataLoading = false;
PCInfiniteScrollActivityIndicator *loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.searchTableView.contentSize.height, self.searchTableView.bounds.size.width, PCInfiniteScrollActivityIndicator.defaultHeight);
    loadingMoreView = [[PCInfiniteScrollActivityIndicator alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.searchTableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.searchTableView.contentInset;
    insets.bottom += PCInfiniteScrollActivityIndicator.defaultHeight;
    self.searchTableView.contentInset = insets;
    
    //set delegate and data sources
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchBar.delegate = self;
    self.
    
    //
    self.moviesArray = [NSArray new];
    
    
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
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.searchTableView.contentSize.height, self.searchTableView.bounds.size.width, PCInfiniteScrollActivityIndicator.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            [self loadMoreData];
        }
    }
    
}

-(void)loadMoreData{
    currentPageNumber += 1;
    [self searchAndFilterWithSearchString:self.currentSearchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber]];
    self.isMoreDataLoading = false;
    // Stop the loading indicator
    [loadingMoreView stopAnimating];
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

// define a completion block for the search network call
-(void)searchMoviesWithString:(NSString *)searchString andPageNumber:(NSString *)pageNumber andCompletionHandler:(void (^)(NSArray *))completionHandler{
    
    // place search string in URL
    NSString *baseUrl = @"https://api.themoviedb.org/3/search/movie?api_key=69308a1aa1f4a3c54b17a53c591eadb0&language=en-US&query=";
    NSString *searchUrl = [baseUrl stringByAppendingString:searchString];
    NSString *fullUrl = [[[searchUrl stringByAppendingString:@"&page="] stringByAppendingString:pageNumber] stringByAppendingString:@"&include_adult=false"];
    
    NSURL *url = [NSURL URLWithString:fullUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // this runs when network call is finished
        if (error != nil) {
            //creating alert if networking error
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create try again action
            UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // handle tryAgain response here. Doing nothing will dismiss the view.
                [self searchMoviesWithString:searchString andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber] andCompletionHandler:nil];
            }];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
            // add the tryAgain action to the alertController
            [alert addAction:tryAgainAction];
            
            NSLog(@"%@", [error localizedDescription]);
        }
        else{
            NSLog(@"Network call returned results");
            // store the received data in a dictionary
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            // store the results section of the JSON data in the movies array
            NSArray *dictionaries = dataDictionary[@"results"];
            
            self.moviesArray = dictionaries;
            completionHandler(self.moviesArray);
        }
    }];
    [task resume];
}

// helper function that filters network call results with search query
-(void)searchAndFilterWithSearchString:(NSString *)searchText andPageNumber:(NSString *) pageNumber{
    if ([searchText isEqualToString:@""]){
        self.filteredData = nil;
        [self.searchTableView reloadData];
    }
    else if (searchText.length != 0) {
        // network call to get the search results with a completion handler
        [self searchMoviesWithString:searchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber] andCompletionHandler:^(NSArray *results){
            // set up predicate for searching movies
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *item, NSDictionary *bindings) {
                return [item[@"title"] containsString:searchText];
            }];
            
            self.filteredData = [results filteredArrayUsingPredicate:predicate];
            [self.searchTableView reloadData];
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
    [self searchAndFilterWithSearchString:self.currentSearchText andPageNumber:[NSString stringWithFormat:@"%d", currentPageNumber]];
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
