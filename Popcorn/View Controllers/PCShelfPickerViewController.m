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

@interface PCShelfPickerViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end



@implementation PCShelfPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShelfPickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ShelfPickerCell" forIndexPath:indexPath];
    
    NSDictionary *selectedShelf = self.shelves[indexPath.row];
    cell.shelfLabel.text = selectedShelf[@"name"];
    [self updateChecks:[selectedShelf[@"id"] stringValue] forCell:cell];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shelves.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    [[APIManager shared] getItemStatus:shelfId forMovie:[self.movie.movieID stringValue] ofType:self.movie.mediaType completion:^(NSString *status, NSError *error) {
        if(error != nil){
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else{
            if([status isEqualToString:@"1"]){
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
    [[APIManager shared] addItem:[shelfId stringValue] forItem:self.movie completion:^(NSError *error) {
        if(error == nil){
            NSLog(@"succesfully added item to list");
        }
        else{
            NSLog(@"error: %@", error.localizedDescription);
        }
    }];
}

- (void)removeFromList: (NSNumber *) shelfId{
    [[APIManager shared] removeItem:[shelfId stringValue] forItem:self.movie completion:^(NSError *error) {
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
