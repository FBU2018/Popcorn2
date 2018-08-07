//
//  PCFeedViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/27/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCFeedViewController.h"
#import "FeedReviewCell.h"
#import "Post.h"
#import "APIManager.h"
#import "PFUser+ExtendedUser.h"
#import "ShelfUpdateCell.h"
#import "PCMovieDetailViewController.h"
#import "Movie.h"
#import "PCSingleReviewViewController.h"

@interface PCFeedViewController () <UITableViewDelegate, UITableViewDataSource, ShelfUpdateCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PCFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.posts = [NSMutableArray new];
    
    [self getPostsArray];
    
    //refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPostsArray) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)shelfUpdateCell:(ShelfUpdateCell *)cell didTapAddTo:(Movie *)movie{
    [self getShelvesWithSession:cell.authorSessionId andAccountId:cell.authorId ofCell:cell fromAddButton:YES];
}

- (void) getPostsArray{
    PFQuery *query = [Post query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            self.posts = [posts mutableCopy];
            NSLog(@"%@", posts);
            [PFUser.currentUser retrieveRelationsWithObjectID:PFUser.currentUser.relations.objectId andCompletion:^(Relations *userRelations) {
                NSArray *following = userRelations.myfollowings;
                
                //iterates in reverse for easy deletion
                for(Post* post in [self.posts reverseObjectEnumerator]){
                    if(post.authorUsername != nil && [following containsObject:post.authorUsername] == NO){
                        //filtering out to only posts from users that that the user followers
                        if([post.authorUsername isEqualToString:PFUser.currentUser.username] == NO){
                            [self.posts removeObject:post];
                        }
                    }
                }
                
                if(self.posts.count == 0){
                    //alert saying you aren't following anyone
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Posts"
                                                                                   message:@"Follow users to see their updates!"
                                                                            preferredStyle:(UIAlertControllerStyleAlert)];
                    // create an ok action, add to alert
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:^{
                    }];
                }
                
                [self.refreshControl endRefreshing];
                [self.tableView reloadData];
            }];


        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *postType = self.posts[indexPath.row][@"postType"];
    Post *post = self.posts[indexPath.row];
    NSDate *postDate = post.createdAt;

    if([postType isEqualToString:@"shelfUpdate"]){
        ShelfUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShelfUpdateCell" forIndexPath:indexPath];
        cell.delegate = self;
        NSString *userId = self.posts[indexPath.row][@"authorId"];
        NSString *userSessionId = self.posts[indexPath.row][@"authorSessionId"];
        NSString *movieId = self.posts[indexPath.row][@"movieId"];
        NSMutableArray *shelves = self.posts[indexPath.row][@"shelves"];
        
        [cell configureCell:userId withSession:userSessionId withMovie:movieId withShelves:shelves withDate:postDate];
        return cell;
    }
    else{ // if([postType isEqualToString:@"review"])
        FeedReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedReviewCell" forIndexPath:indexPath];
        NSString *userId = self.posts[indexPath.row][@"authorId"];
        NSString *movieId = self.posts[indexPath.row][@"movieId"];
        
        [cell configureCell:userId withMovie:movieId withDate: postDate];
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableView *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[ShelfUpdateCell class]]){
        NSLog(@"shelfUpdateCell");
        ShelfUpdateCell *tappedCell = (ShelfUpdateCell*)cell;
        //get shelves of user
        [self getShelvesWithSession:tappedCell.authorSessionId andAccountId:tappedCell.authorId ofCell:tappedCell fromAddButton:NO];
        //get movie inside get shelves
        //segue is called inside getMovie
    }
    else if([cell isKindOfClass:[FeedReviewCell class]]){
        NSLog(@"FeedReviewCell");
        FeedReviewCell *tappedCell = (FeedReviewCell*)cell;
        [self performSegueWithIdentifier:@"feedToSingleReview" sender:tappedCell];
    }
}

- (void)getShelvesWithSession: (NSString*) sessionId andAccountId: (NSString*) accountId ofCell: (ShelfUpdateCell*) cell fromAddButton: (BOOL) add{
    [[APIManager shared] getShelvesWithSessionId:sessionId andAccountId:accountId andCompletionBlock:^(NSArray *results, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            cell.userShelves = results;
            [self getMovie:cell.movieId ofCell:cell fromAddButton:add];
        }
    }];
}

- (void)getMovie: (NSString*) movieId ofCell: (ShelfUpdateCell*) cell fromAddButton: (BOOL) add{
    [[APIManager shared] getMovieDetails:movieId completion:^(NSDictionary *dataDictionary, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            cell.movie = [[Movie alloc] initWithDetails:dataDictionary];
            NSNumber *rating = dataDictionary[@"vote_average"];
            cell.voteAverage = [rating stringValue];
            //segue to details if comes from touch gesture recognizer
            if(add == NO){
                [self performSegueWithIdentifier:@"shelfUpdateToDetail" sender:cell];
            }
            else{
                //go to details
                [self performSegueWithIdentifier:@"feedToShelfPicker" sender:cell];
            }
        }
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"shelfUpdateToDetail"]){
        ShelfUpdateCell *tappedCell = sender;
        PCMovieDetailViewController *receiver = [segue destinationViewController];
        receiver.shelves = tappedCell.userShelves;
        receiver.movie = tappedCell.movie;
        receiver.voteAverage = tappedCell.voteAverage;
    }
    else if([segue.identifier isEqualToString:@"feedToSingleReview"]){
        FeedReviewCell *tappedCell = sender;
        PCSingleReviewViewController *receiver = [segue destinationViewController];
        receiver.movieName = tappedCell.titleLabel.text;
        receiver.ratingString = tappedCell.ratingString;
        receiver.movieImageURL = tappedCell.movieImageURL;
        receiver.username = tappedCell.usernameLabel.text;
        receiver.userImage = tappedCell.userImageFile;
        receiver.review = tappedCell.reviewTextLabel.text;
    }
    else if([segue.identifier isEqualToString:@"feedToShelfPicker"]){
        ShelfUpdateCell *tappedCell = sender;
        PCMovieDetailViewController *receiver = [segue destinationViewController];
        receiver.movie = tappedCell.movie;
        receiver.shelves = tappedCell.userShelves;
    }
}



@end
