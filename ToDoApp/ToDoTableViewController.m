//
//  ToDoTableViewController.m
//  ToDoApp
//
//  Created by Rohit Dialani on 11/08/13.
//  Copyright (c) 2013 Rohit Dialani. All rights reserved.
//

#import "ToDoTableViewController.h"
#import "CustomCell.h"
#import <QuartzCore/QuartzCore.h>

@interface ToDoTableViewController ()

@property (nonatomic, strong) NSMutableArray *toDoItemsArray;
@property (nonatomic, strong) UIBarButtonItem *editBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, assign) BOOL isAddingNewItem;

@end

@implementation ToDoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"To Do List";
        self.toDoItemsArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nibCustom = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:nibCustom forCellReuseIdentifier:@"CustomCellId"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(onAddItemClicked)];
    
    self.editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action: @selector(onEditItemClicked)];
    
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action: @selector(onDoneItemClicked)];
    
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // hardcoded 1 section table view
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDoItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellId";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.toDoItem.text = [self.toDoItemsArray objectAtIndex:indexPath.row];
    cell.toDoItem.delegate = self;

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.toDoItemsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Backup the item moved and remove/insert it again in our data source
    NSString *itemString = [self.toDoItemsArray objectAtIndex:fromIndexPath.row];
    [self.toDoItemsArray removeObjectAtIndex:fromIndexPath.row];
    [self.toDoItemsArray insertObject:itemString atIndex:toIndexPath.row];
}

#pragma mark - Table view delegate

// Updating UI buttons since tableView enters/exits Editing mode via Swipe
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.leftBarButtonItem = self.doneBarButtonItem;   
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
}

// Playing with a trivial method
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"delete";
}

# pragma mark UITextFieldDelegate method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.isAddingNewItem)
        return YES;
    else
        return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Editing");
}

#pragma mark - App Logic

- (void) onAddItemClicked
{
    self.isAddingNewItem = YES;
    static int i = 0;
    NSString *newItem = [NSString stringWithFormat:@"Insert new Item %d..", i];
    i++;
    // Always inserting at 0 since the Array shifts it the index is occupied
    [self.toDoItemsArray insertObject:newItem atIndex:0];
    
    [self.tableView reloadData];
    
}

- (void) onEditItemClicked
{
    self.navigationItem.leftBarButtonItem = self.doneBarButtonItem;
    self.tableView.editing = YES;
}

- (void) onDoneItemClicked
{
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
    self.tableView.editing = NO;
}

@end
