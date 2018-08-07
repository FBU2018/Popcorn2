//
//  PCMovieDiscussionViewController.m
//  Popcorn
//
//  Created by Ernest Omondi on 7/31/18.
//  Copyright © 2018 Rucha Patki. All rights reserved.
//

#import "PCMovieDiscussionViewController.h"
#import "UIImageView+AFNetworking.h"
#import "Chat.h"
#import "ChatCell.h"

@interface PCMovieDiscussionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *discussionPosterImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *chatMessageTextField;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) NSArray *chatsArray;
@property (weak, nonatomic) IBOutlet UIImageView *backdropImageView;
@end

@implementation PCMovieDiscussionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    // Remove table view row outlines
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Set tableview delegate and datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Set Poster image at the top Screen
    [self.discussionPosterImageView setImageWithURL:self.movie.posterUrl placeholderImage:[UIImage imageNamed:@"poster-placeholder.png"]];
    // Set Movie Title
    self.movieTitleLabel.text = self.movie.title;
    // Set Backdrop Image
    [self.backdropImageView setImageWithURL:self.movie.backdropUrl];
    
    // refresh the chats every second
    //[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshChats) userInfo:nil repeats:true];
    [self refreshChats];
    [self.tableView reloadData];
}

-(void)dismissKeyboard {
    [self.chatMessageTextField resignFirstResponder];
}

-(void)refreshChats{
    // Get chats
    PFQuery *chatQuery = [PFQuery queryWithClassName:@"Chat"];
    
    // Sort by descending order
    [chatQuery orderByAscending:@"createdAt"];
    [chatQuery whereKey:@"movieID" equalTo:self.movie.movieID];
    
    // Fetch chats asynchronously
    [chatQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable chats, NSError * _Nullable error) {
        if(error == nil){
            // Add returned chat objects that are not in the local array
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.chatsArray];
            for(int i = 0; i < [chats count]; i++){
                if(i < [array count] && [array count] != 0){
                    Chat *chatElement = [chats objectAtIndex:i];
                    Chat *arrayElement = [array objectAtIndex:i];
                    if(![chatElement.message isEqualToString:arrayElement.message]){
                        [array addObject:chatElement];
                    }
                }
                else{
                    Chat *object = [chats objectAtIndex:i];
                    [array addObject:object];
                }
            }
            self.chatsArray = [NSArray arrayWithArray:array];
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Error querying chats: %@", error.localizedDescription);
        }
    }];
}

// User taps send to send a chat message
- (IBAction)didTapSend:(id)sender {
    // Create a chat object and store the message, the user's object id and the movie they are talking about
    Chat *chat = [Chat object];
    chat.message = self.chatMessageTextField.text;
    chat.userObjectId = PFUser.currentUser.objectId;
    chat.movieID = self.movie.movieID;
    
    // Store the time the chat was created
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"E MMM d HH:mm:ss Z y"];
    chat.createdAtString = [outputFormatter stringFromDate:now];
    
    // Save chat in Parse server
    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            NSLog(@"Chat successfully sent!");
        }
        else{
            NSLog(@"Problem sending chat : %@", error.localizedDescription);
        }
    }];
    // Clear text in the textfield
    self.chatMessageTextField.text = @"";
    
    // refresh table view and chats
    [self refreshChats];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    Chat *currentChat = self.chatsArray[indexPath.row];
    NSString *currentUsername = PFUser.currentUser.username;
    NSLog(@"Logged in User is : %@", currentUsername);
    [cell configureCell:currentChat withUserObjectId:currentChat.userObjectId andIndexPath: indexPath andCurrentUsername:currentUsername];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsArray.count;
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }];
    
    // self.editingIndexPath is the NSIndexPath of the last UITableViewCell in the Table View. Set it up after you know what it is.
    NSIndexPath *editingIndexPath = [NSIndexPath indexPathForRow:self.chatsArray.count inSection:0] ;
    [self.tableView scrollToRowAtIndexPath:editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
