//
//  detailMic.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/12/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "detailMic.h"

@interface detailMic()
@property (nonatomic, strong) Microphone *myMic;
@property (nonatomic, strong) UIPopoverController *curPopover;
@property (nonatomic, strong) NSArray *types;
@end

@implementation detailMic
@synthesize nameField;
@synthesize phantomSwitch;
@synthesize typeField;
@synthesize titleButton;
@synthesize micImage;
@synthesize editButton;
@synthesize myMic;
@synthesize curPopover;
@synthesize types;
@synthesize delegate;

- (id)initWithMicrophone:(Microphone *)mic
{
    self = [super initWithNibName:@"detailMic" bundle:[NSBundle mainBundle]];
    if (self) {
        myMic = mic;
        types = [NSArray arrayWithObjects:@"Dynamic", @"Condensor", @"Ribbon", @"Passive DI", @"Active DI", @"Line in", nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nameField.text = self.myMic.name;
    self.titleButton.title = self.myMic.name;
    self.typeField.text = self.myMic.type;
    self.phantomSwitch.on = [self.myMic.needsPhantom boolValue];
    
    if (self.myMic.image != nil)
        self.micImage.image = self.myMic.image;
    else
        self.micImage.image = [UIImage imageNamed:@"largegmicplaceholder.png"];
    
}

- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setPhantomSwitch:nil];
    [self setTypeField:nil];
    [self setTitleButton:nil];
    [self setMicImage:nil];
    [self setEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)changeImage:(id)sender {
    UIButton *button = sender;
    UIActionSheet *imageChoice = [[UIActionSheet alloc] initWithTitle:@"Choose Picture From:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Take New Photo", @"Choose Existing Photo", nil];
    
    [imageChoice setCancelButtonIndex:-1];
    [imageChoice setDestructiveButtonIndex:-1];
    [imageChoice showFromRect:button.frame inView:self.view animated:YES];
}

#pragma mark overlayControl Delegate

- (void)clearPopover {
    if (self.curPopover != nil)
        [self.curPopover dismissPopoverAnimated:YES];
    self.curPopover = nil;
    
}

- (void)clearModalview {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIImagePickerController 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self clearPopover];
    }
    else
        [self dismissModalViewControllerAnimated:YES];
    
    UIImage *newImage = [info valueForKey:UIImagePickerControllerEditedImage];
    
    if (newImage == nil)
        newImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.micImage.image = newImage;
    self.myMic.image = newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    //self.editMicImage = NO;
    //self.editPlacementImage = NO;
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [picker setModalPresentationStyle:UIModalPresentationFullScreen];
            [self presentModalViewController:picker animated:YES];
        }
        else {
            // display an alert
        }
    }
    
    if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            
            UIPopoverController *newPopover = [[UIPopoverController alloc] initWithContentViewController:picker];
            newPopover.delegate = self;
            
            [newPopover presentPopoverFromRect:self.editButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
            self.curPopover = newPopover;
        }
        else {
            // display an alert
        }
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    //self.editMicImage = NO;
    //self.editPlacementImage = NO;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.typeField) {
        if (self.curPopover != nil)
            [self clearPopover];
        
        UITableViewController *typeTable = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        typeTable.tableView.delegate = self;
        typeTable.tableView.dataSource = self;
        
        UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:typeTable];
        typeTable.title = @"Choose Type";
        
        self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
        
        [self.curPopover setPopoverContentSize:CGSizeMake(320, 358)];
        
        [self.curPopover presentPopoverFromRect:self.typeField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.types count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSString *cur = [self.types objectAtIndex:[indexPath row]];
    
    if ([cur isEqualToString:self.myMic.type])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    cell.textLabel.text = cur;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.myMic.type = [self.types objectAtIndex:[indexPath row]];
    self.typeField.text = [self.types objectAtIndex:[indexPath row]];
    
    [self clearPopover];
}

@end
