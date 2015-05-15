//
//  ViewPhotoViewController.m
//  Quest
//
//  Created by Mircea Eftimescu on 04/05/15.
//  Copyright (c) 2015 Stefanini. All rights reserved.
//

#import "ViewPhotoViewController.h"


@interface ViewPhotoViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSUInteger yMove;
    BOOL moveView;
    BOOL runningAnimation;
    UIImagePickerControllerSourceType pickerType;

}

@property (strong, nonatomic) NSNotification *keyboardNotification;

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) UITapGestureRecognizer *gesture;
@property (weak, nonatomic) IBOutlet UILabel *radiusTextLabel;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (strong, nonatomic) UIImagePickerController* imagePickerController;
@property (weak, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation ViewPhotoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    yMove = 100;
    moveView = NO;
    runningAnimation = NO;
    
    self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    
}

- (void)tapGesture {
    [self.messageTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"text field ended editing: %@", textField.text);
    [self moveView:NO];
    self.viewPhotoMessage = textField.text;

}

- (void) moveView: (BOOL) up {
    UIView *view = self.parentViewController.parentViewController.view;
    CGFloat y = view.frameTop;
    y += ((int)(!up) * 2 - 1) * (int)yMove;
    if (y > 0)
        y = 0;
    if (!runningAnimation) {
        runningAnimation = YES;
        [UIView animateWithDuration:[[self.keyboardNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:[[self.keyboardNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                         animations:^{
            view.frameTop = y;
        } completion:^(BOOL finished) {
            if (!finished)
                return;
            runningAnimation = NO;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self.parentViewController.parentViewController.view addGestureRecognizer: self.gesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    runningAnimation = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [self.parentViewController.parentViewController.view removeGestureRecognizer: self.gesture];
    [self.messageTextField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    runningAnimation = YES;
}

-(void)setViewPhotoRadius:(NSUInteger)viewPhotoRadius
{
    self.radiusSlider.value = viewPhotoRadius;
    self.radiusTextLabel.text = [@(viewPhotoRadius) stringValue];
}

-(NSUInteger)viewPhotoRadius
{
    return self.radiusSlider.value;
}

-(void)setViewPhotoMessage:(NSString *)viewPhotoMessage
{
    self.messageTextField.text = viewPhotoMessage;
}

-(NSString *)viewPhotoMessage
{
    return self.messageTextField.text;
}

-(void)setViewPhotoImage:(NSData *)viewPhotoImage
{
    _viewPhotoImage = viewPhotoImage;
    [self.choosePhotoButton setSelected:YES];
}

#pragma mark - Keyboard Movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    yMove = [@([[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height) unsignedIntegerValue];
    
    self.keyboardNotification = notification;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (moveView) {
            [self moveView:YES];
            moveView = NO;
        }
    });

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    moveView = YES;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)radiusValueChanged:(UISlider*)sender {
    NSUInteger radius = sender.value;
    self.radiusTextLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)radius];
}

- (IBAction)choosePhotoTouched:(id)sender {
    [self.messageTextField resignFirstResponder];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Choose Photo" message:@"You could take a photo, or select a photo from your library" preferredStyle: UIAlertControllerStyleActionSheet];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            pickerType = UIImagePickerControllerSourceTypeCamera;
            [self performSegueWithIdentifier:@"kPickPhoto" sender:nil];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        pickerType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self performSegueWithIdentifier:@"kPickPhoto" sender:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
    self.viewPhotoImage = UIImagePNGRepresentation(info[UIImagePickerControllerOriginalImage]);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.imagePickerController = [segue.destinationViewController init];
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = pickerType;
}


@end
