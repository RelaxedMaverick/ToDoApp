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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.toDoItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellId";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.toDoItem.text = [self.toDoItemsArray objectAtIndex:indexPath.row];
    cell.toDoItem.delegate = self;
    cell.showsReorderControl = YES;

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

# pragma mark UITextFieldDelegate method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.isAddingNewItem)
        return YES;
    else
        return FALSE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Editing");
}

#pragma mark - App Logic

- (void) onAddItemClicked
{
    self.isAddingNewItem = TRUE;
    NSString *newItem = @"Insert new Item ..";
    // Always inserting at 0 since the Array shifts it the index is occupied
    [self.toDoItemsArray insertObject:newItem atIndex:0];
    
    [self.tableView reloadData];
    
}

- (void) onEditItemClicked
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath == nil || indexPath.row >= self.toDoItemsArray.count)
        return;
    
    self.navigationItem.leftBarButtonItem = self.doneBarButtonItem;
}

- (void) onDoneItemClicked
{
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
}


@end
