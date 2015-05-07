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

}

@property (strong, nonatomic) NSNotification *keyboardNotification;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) UITapGestureRecognizer *gesture;
@property (weak, nonatomic) IBOutlet UILabel *radiusTextField;
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;

@property (strong, nonatomic) UIImagePickerController* imagePickerController;

@property (weak, nonatomic) IBOutlet UIButton *buttonChoosePhoto;

@end

@implementation ViewPhotoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    yMove = 100;
    moveView = NO;
    runningAnimation = NO;
    
    self.gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    
    self.viewPhotoImage = [UIImage new];
    self.viewPhotoMessage = @"";
    self.viewPhotoRadius = 0;
}

- (void)tapGesture {
    [self.textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"text field ended editing: %@", textField.text);
    [self moveView:NO];
    self.viewPhotoMessage = textField.text;

}

- (void) moveView: (BOOL) up {
    UIView *view = self.parentViewController.parentViewController.view;
    CGRect frame = view.frame;
    frame.origin.y += ((int)(!up) * 2 - 1) * (int)yMove;
    if (frame.origin.y > 0)
        frame.origin.y = 0;
//    NSLog(@"trying animation %d", up);
    if (!runningAnimation) {
//        NSLog(@"running animation %d", up);
        runningAnimation = YES;
        [UIView animateWithDuration:[[self.keyboardNotification userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                              delay:0
                            options:[[self.keyboardNotification userInfo][UIKeyboardAnimationCurveUserInfoKey] intValue] << 16
                         animations:^{
            view.frame = frame;
        } completion:^(BOOL finished) {
            if (!finished)
                return;
            runningAnimation = NO;
//            NSLog(@"done animation %d", up);
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
    [self.textField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    runningAnimation = YES;
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    yMove = [@([[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height) unsignedIntegerValue];
//    NSLog(@"keyboard size: %@", @(yMove));
    
    self.keyboardNotification = notification;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (moveView) {
            [self moveView:YES];
            moveView = NO;
        }
    });

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    NSLog(@"started");
    moveView = YES;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}
- (IBAction)radiusValueChanged:(UISlider*)sender {
    NSUInteger radius = sender.value;
    self.viewPhotoRadius = radius;
    self.radiusTextField.text = [NSString stringWithFormat:@"%lu", (unsigned long)radius];
}

- (void) photoFromCamera {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void) photoFromLibrary {
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)choosePhotoTouched:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Choose Photo" message:@"You could take a photo, or select a photo from your library" preferredStyle: UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self photoFromCamera];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self photoFromLibrary];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"image picked: %@", info);
    [self dismissViewControllerAnimated:YES completion:nil];
    self.viewPhotoImage = info[UIImagePickerControllerOriginalImage];
    [self.buttonChoosePhoto setSelected:YES];
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
