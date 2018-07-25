//
//  PCShelfPickerViewController.m
//  Popcorn
//
//  Created by Rucha Patki on 7/18/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCShelfPickerViewController.h"
#import "APIManager.h"
#import "ShelfPickerCell.h"
#import "Parse/Parse.h"

@interface PCShelfPickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end



@implementation PCShelfPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self getLists];
}

- (void)getLists{
    //gets a dictionary of all of user's saved lists
    [[APIManager shared] getShelvesWithSessionId:PFUser.currentUser[@"sessionId"] andAccountId: PFUser.currentUser[@"accountId"] andCompletionBlock:^(NSDictionary *shelves, NSError *error){
        if(error == nil){
            self.shelves = shelves[@"results"];
            [self.tableView reloadData];
        }
        else{
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShelfPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShelfPickerCell" forIndexPath:indexPath];
    
    //set shelf text by checking corresponding name in shelves array
    NSDictionary *selectedShelf = self.shelves[indexPath.row];
    cell.shelfLabel.text = selectedShelf[@"name"];
    [self updateChecks:[selectedShelf[@"id"] stringValue] forCell:cell];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shelves.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //If shelf is selected/unselected, updates checks and adds/removes from shelf
    ShelfPickerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *selectedShelf = self.shelves[indexPath.row];
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        //remove from list
        [self removeFromList:selectedShelf[@"id"]];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //add to list
        [self addToList:selectedShelf[@"id"]];
    }
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)updateChecks: (NSString *) shelfId forCell: (ShelfPickerCell *) cell{
    //sets check marks on shelves which already have the movie in the shelf
    [[APIManager shared] getItemStatus:shelfId forMovie:[self.movie.movieID stringValue] ofType:self.movie.mediaType completion:^(bool inList, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            if(inList == YES){
                NSLog(@"Item is in list");
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else{
                NSLog(@"Item not found in the list");
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }];
}

- (void)addToList: (NSNumber *) shelfId {
    //add movie to the shelf with the given shelfId
    [[APIManager shared] addItem:[shelfId stringValue] forItem:self.movie withSessionId: PFUser.currentUser[@"sessionId"] completion:^(NSError *error) {
        if(error == nil){
            NSLog(@"succesfully added item to list");
        }
        else{
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}

- (void)removeFromList: (NSNumber *) shelfId{
    //remove movie from the shelf with the given shelfId
    [[APIManager shared] removeItem:[shelfId stringValue] forItem:self.movie withSessionId: PFUser.currentUser[@"sessionId"] completion:^(NSError *error) {
        if(error == nil){
            NSLog(@"succesfully removed item from list");
        }
        else{
            NSLog(@"error: %@", error.localizedDescription);
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
