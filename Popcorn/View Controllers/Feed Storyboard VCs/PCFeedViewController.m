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

@interface PCFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation PCFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.posts = [NSArray new];
    
    [self getPostsArray];
    
    //refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(getPostsArray) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) getPostsArray{
    PFQuery *query = [Post query];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            self.posts = posts;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *postType = self.posts[indexPath.row][@"postType"];
    if([postType isEqualToString:@"shelfUpdate"]){
        ShelfUpdateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShelfUpdateCell" forIndexPath:indexPath];
        NSString *userId = self.posts[indexPath.row][@"authorId"];
        NSString *movieId = self.posts[indexPath.row][@"movieId"];
        NSMutableArray *shelves = self.posts[indexPath.row][@"shelves"];
        
        [cell configureCell:userId withMovie:movieId withShelves:shelves];
        return cell;
    }
    else{ // if([postType isEqualToString:@"review"])
        FeedReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedReviewCell" forIndexPath:indexPath];
        NSString *userId = self.posts[indexPath.row][@"authorId"];
        NSString *movieId = self.posts[indexPath.row][@"movieId"];
        
        [cell configureCell:userId withMovie:movieId];
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.posts.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
