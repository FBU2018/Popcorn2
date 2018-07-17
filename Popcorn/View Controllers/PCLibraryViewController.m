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

@interface PCLibraryViewController () <UITableViewDelegate, UITableViewDataSource>

//array of shelf dictionaries
@property (strong, nonatomic) NSArray *shelves;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PCLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.shelves = [NSArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getLists];

}

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
    [[APIManager shared] getShelves:^(NSDictionary *shelves, NSError *error) {
        if(error == nil){
            self.shelves = shelves[@"results"];
            NSLog(@"Successfully got all of user's lists");
            [self.tableView reloadData];
            
            NSLog(@"Results: %@", self.shelves);
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
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
