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

@interface PCFeedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation PCFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.posts = [NSArray new];
    
    [self getPostsArray];
}

- (void) getPostsArray{
    PFQuery *query = [Post query];
    [query includeKey:@"userImage"];
    [query includeKey:@"relations"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable posts, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            self.posts = posts;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"posts: %@", self.posts);
    //TODO: implement different cells
    FeedReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedReviewCell" forIndexPath:indexPath];
    //TODO: configure cell with user + movie
    NSString *userId = self.posts[indexPath.row][@"authorId"];

    [cell configureCell:userId withMovie:self.posts[indexPath.row][@"movieId"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //TODO: update with number of all cells
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
