//
//  detailInput.m
//  IO_Manager
//
//  Created by Matias Seibert on 12/5/11.
//  Copyright (c) 2011 Penn State. All rights reserved.
//

#import "detailInput.h"

@interface detailInput()
@property (nonatomic, strong) Input *myInput;
@property (nonatomic, strong) Microphone *myMic;
@property (nonatomic, strong) UIPopoverController *curPopover;
@property (nonatomic, strong) micPicker *mPicker;
@property (nonatomic) BOOL choseExistingMic;
@end

@implementation detailInput
@synthesize titleButton;
@synthesize nameField;
@synthesize micField;
@synthesize standField;
@synthesize accField;
@synthesize cableField;
@synthesize placementImage;
@synthesize micImage;
@synthesize isPhantom;
@synthesize connectButton;
@synthesize myInput, myMic;
@synthesize curPopover;
@synthesize delegate;
@synthesize mPicker;
@synthesize choseExistingMic;

- (id)initWithInput:(Input *)input
{
    self = [super initWithNibName:@"detailInput" bundle:[NSBundle mainBundle]];
    if (self) {
        myInput = input;
        if (myInput.micName != nil)
            myMic = [[DataManager sharedInstance] getMicrophoneForName:myInput.micName];
        else
            myMic = nil;
    }
    return self;
}

- (IBAction)micBeganTyping:(id)sender {
    self.mPicker = [[micPicker alloc] initWithStyle:UITableViewStylePlain];
    [self.mPicker setDelegate:self];
    self.mPicker.title = @"Choose Existing:";
    UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:self.mPicker];
    self.choseExistingMic = NO;
    self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
    self.curPopover.delegate = self;
    [self.curPopover setPopoverContentSize:CGSizeMake(320, 302)];
    [self.curPopover presentPopoverFromRect:self.micField.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)micEndedTyping:(id)sender {
    
    //[self setMicNamed:self.micField.text];
    
    if (![[DataManager sharedInstance] micExistsNamed:self.micField.text]) {
        createMicView *newMicModalVC = [[createMicView alloc] initWithNibName:@"createMicView" bundle:[NSBundle mainBundle]];
        [newMicModalVC setDelegate:self];
        newMicModalVC.nameToUse = self.micField.text;
        [newMicModalVC setReturnsToInputView:YES];
        [newMicModalVC setTitle:@"Create New"];

        if (self.curPopover != nil && self.mPicker != nil) {
            if (!self.choseExistingMic) {
                [self.mPicker.navigationController pushViewController:newMicModalVC animated:NO];
                [self.curPopover setPopoverContentSize:CGSizeMake(320, 302)];
            }
        }
    }
    else {
        [self clearPopover];
    }
    [sender resignFirstResponder];
}

- (IBAction)changePlacementImage:(id)sender {
    UIButton *button = sender;
    UIActionSheet *imageChoice = [[UIActionSheet alloc] initWithTitle:@"Choose Picture From:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Take New Photo", @"Choose Existing Photo", nil];
    
    [imageChoice setCancelButtonIndex:-1];
    [imageChoice setDestructiveButtonIndex:-1];
    [imageChoice showFromRect:button.frame inView:self.view animated:YES];
}

- (IBAction)showPlacementImage:(id)sender {
    fullImageView *newView = [[fullImageView alloc] initWithImage:self.myInput.image];
    [newView setDelegate:self];
    [newView setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:newView animated:YES];
}

- (IBAction)showMicImage:(id)sender {
    fullImageView *newView = [[fullImageView alloc] initWithImage:self.myMic.image];
    [newView setDelegate:self];
    [newView setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:newView animated:YES];
}

- (IBAction)micFieldChanged:(id)sender {
    
    if (self.mPicker != nil) {
        [self.mPicker updateSearchTerm:self.micField.text];
    }
    else {
        // ???
    }
}

- (IBAction)editingDidEnd:(id)sender {
    self.titleButton.title = [NSString stringWithFormat:@"%d. %@", [self.myInput.number intValue], self.myInput.name];
    
    DataManager *dataManager = [DataManager sharedInstance];
    [dataManager setName:self.nameField.text forInput:self.myInput];
    [dataManager setStandNotes:self.standField.text forInput:self.myInput];
    [dataManager setAccessories:self.accField.text forInput:self.myInput];
    [dataManager setCableNotes:self.cableField.text forInput:self.myInput];
    
    [delegate updateListing];
    [sender resignFirstResponder];
}

- (IBAction)editConnection:(id)sender {
    if (self.curPopover != nil) 
        [self clearPopover];
    
    //NSLog(@"Creating Popover");
    patchPointPopover *newPopover = [[patchPointPopover alloc] initWithShow:self.myInput.show];
    
    [newPopover setDelegate:self];
    
    UINavigationController *container = [[UINavigationController alloc] initWithRootViewController:newPopover];
    
    self.curPopover = [[UIPopoverController alloc] initWithContentViewController:container];
    
    //[self.curPopover setPopoverContentSize:CGSizeMake(320, 3)];
    //NSLog(@"Presenting Popover");
    [self.curPopover presentPopoverFromRect:self.connectButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
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
    self.nameField.text = self.myInput.name;
    self.standField.text = self.myInput.standNotes;
    self.accField.text = self.myInput.accessories;
    self.cableField.text = self.myInput.cableLength;
    NSString *title = [NSString stringWithFormat:@"%d. %@", [self.myInput.number intValue], self.myInput.name];
    self.titleButton.title = title;
    
    if (self.myMic != nil) {
        self.micField.text = self.myMic.name;
        
        if ([self.myMic.needsPhantom boolValue]) {
            self.isPhantom.hidden = NO;
        }
        
        if (self.myMic.image != nil)
            self.micImage.image = self.myMic.image;
        else
            self.micImage.image = [UIImage imageNamed:@"smallmicplaceholder.png"];
    }
    else {
        self.micImage.image = [UIImage imageNamed:@"smallmicplaceholder.png"];
    }
    
    if (self.myInput.image != nil)
        self.placementImage.image = self.myInput.image;
    else
        self.placementImage.image = [UIImage imageNamed:@"placeholder.png"];
    
    if (self.myInput.connection.output != nil) {
        NSString *title = [NSString stringWithFormat:@"%@: %d", self.myInput.connection.output.name, [self.myInput.connection.channelMale intValue]];
        [self.connectButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)viewDidUnload
{
    [self setTitleButton:nil];
    [self setNameField:nil];
    [self setMicField:nil];
    [self setStandField:nil];
    [self setAccField:nil];
    [self setCableField:nil];
    [self setPlacementImage:nil];
    [self setMicImage:nil];
    [self setIsPhantom:nil];
    [self setConnectButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return NO;
}

#pragma mark overlayControl Delegate

- (void)clearPopover {
    [self.curPopover dismissPopoverAnimated:YES];
    self.curPopover = nil;
    if (self.mPicker != nil) {
        self.mPicker = nil;
        [self.micField resignFirstResponder];
    }
    
    if (self.myInput.connection.output != nil) {
        NSString *title = [NSString stringWithFormat:@"%@: %d", self.myInput.connection.output.name, [self.myInput.connection.channelMale intValue]];
        [self.connectButton setTitle:title forState:UIControlStateNormal];
    }
    
    if (self.myInput.connection.consoleIn != nil) {
        NSString *title = [NSString stringWithFormat:@"%@: %d", self.myInput.connection.consoleIn.name, [self.myInput.connection.channelMale intValue]];
        [self.connectButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)clearModalview {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - inputUpdate Delegate

- (void)setMicNamed:(NSString *)name {
    
    self.myInput.micName = name;
    self.micField.text = name;
    
    if (name != nil) {
        self.myMic = [[DataManager sharedInstance] getMicrophoneForName:name];
        self.micField.text = self.myMic.name;
        if ([self.myMic.needsPhantom boolValue]) {
            self.isPhantom.hidden = NO;
        }
        else
            self.isPhantom.hidden = YES;
        
        if(self.myMic.image == nil) {
            self.micImage.image = [UIImage imageNamed:@"smallmicplaceholder.png"];
        }
        else
            self.micImage.image = myMic.image;
    }
    
    [delegate updateListing];
}

- (void)choseExisting {
    self.choseExistingMic = YES;
    [self.micField resignFirstResponder];
}

- (Input *)getInput {
    return self.myInput;
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

    self.myInput.image = newImage;
    self.placementImage.image = newImage;
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
            
            [newPopover presentPopoverFromRect:self.placementImage.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIPopOverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    
    if (self.mPicker != nil) {
        self.mPicker = nil;
    }
    self.curPopover = nil;
    [self.micField resignFirstResponder];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return NO;
}

@end
