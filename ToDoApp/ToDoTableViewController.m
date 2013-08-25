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

static NSString * const kTodoList = @"kTodoList";

@interface ToDoTableViewController ()

@property (nonatomic, strong) NSMutableArray *toDoItemsArray;
@property (nonatomic, strong) UIBarButtonItem *editBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *doneBarButtonItem;
@property (nonatomic, assign) BOOL inEditingCellMode;

@end

@implementation ToDoTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"To Do List";
//        self.toDoItemsArray = [NSMutableArray arrayWithCapacity:10];
        self.toDoItemsArray = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:kTodoList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib *nibCustom = [UINib nibWithNibName:@"CustomCell" bundle:nil];
    [self.tableView registerNib:nibCustom forCellReuseIdentifier:@"CustomCellId"];

    // Looks like delegate is automatically set. Still no harm in setting the same ?
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(onAddItemClicked)];
    
    self.editBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action: @selector(onEditItemClicked)];
    
    self.doneBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action: @selector(onDoneItemClicked)];
    
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    cell.toDoItem.tag = indexPath.row; // Tagging the textField with row Id

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
        
        // Reloading tableView since am relying on the tag stored with each cell's TextField
        [self.tableView reloadData];
        [self persistList];
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
    
    // Reloading tableView since am relying on the tag stored with each cell's TextField
    [self.tableView reloadData];
    [self persistList];
}

#pragma mark - Table view delegate

// Updating UI buttons since tableView enters/exits Editing mode via Swipe
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    self.navigationItem.leftBarButtonItem = self.doneBarButtonItem;   
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
}

// Playing with a trivial method
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Del";
}

# pragma mark UITextFieldDelegate method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // Preventing Editing of Cell content when table view is in Edit mode
    if (self.tableView.editing)
        return NO;
    
    self.inEditingCellMode = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Updating the data source with new data
    NSInteger rowIndex = textField.tag;
    NSString *newItem = textField.text;
    NSIndexPath *pathOfUpdatedRow = [NSIndexPath indexPathForRow:rowIndex inSection:0];
    [self.toDoItemsArray replaceObjectAtIndex:rowIndex withObject:newItem];
    
    // Calling tableView update on the specific table row
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:pathOfUpdatedRow] withRowAnimation:UITableViewRowAnimationFade];
    
    self.inEditingCellMode = NO;
    [self persistList];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Getting rid of the keypad
    [self.view endEditing:YES];
    self.inEditingCellMode = NO;
    return YES;
}

#pragma mark - App Logic

- (void)onAddItemClicked
{
    // Preventing new item addition while cell/tableview editing is in progress.
    if (self.inEditingCellMode || self.tableView.editing)
        return;
    
    NSString *newItem = @"";
    // Always inserting at 0 since the Array shifts if the index is occupied
    [self.toDoItemsArray insertObject:newItem atIndex:0];
    
    [self.tableView reloadData];
    [self persistList];
}

- (void)onEditItemClicked
{
    [self.view endEditing:YES];
    self.navigationItem.leftBarButtonItem = self.doneBarButtonItem;
    self.tableView.editing = YES;
}

- (void)onDoneItemClicked
{
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
    self.tableView.editing = NO;
}

- (void)persistList
{
    [[NSUserDefaults standardUserDefaults] setObject:self.toDoItemsArray forKey:kTodoList];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
