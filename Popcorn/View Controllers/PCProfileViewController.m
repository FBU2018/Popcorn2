//
//  PCProfileViewController.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/23/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCProfileViewController.h"
#import "Parse.h"

@interface PCProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong,  nonatomic) PFUser *currentUser;
@end

@implementation PCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Show the current users username and followers and following count
    self.currentUser = [PFUser currentUser];
    self.usernameLabel.text = self.currentUser.username;
    
    // Call method to get users list given their account id
    
}
- (IBAction)didTapFollow:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Define a method that gets a given user's lists
-(void)getProfileLists{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    <#code#>
//}
//
//- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    <#code#>
//}
//


@end
