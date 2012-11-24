//
//  ViewController.m
//  KeychainValue
//
//  Created by Akinori Takatsu on 12/11/24.
//  Copyright (c) 2012年 Akinori Takatsu. All rights reserved.
//

#import "ViewController.h"
#import "KeychainAccessManager.h"

NSString const *PasswordKey = @"passcode";


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

- (IBAction)registPassword:(id)sender;
- (IBAction)getPassword:(id)sender;
- (IBAction)deletePassword:(id)sender;

@property (nonatomic, strong, readwrite) KeychainAccessManager *manager;

@end


@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		self.manager = [[KeychainAccessManager alloc] initWithServiceName:@"alza"];
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registPassword:(id)sender
{
#pragma unused(sender)
	
	NSData *passdata = [self.passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding];
	
	BOOL result = [self.manager saveGenericPassword:passdata key:(NSString *)PasswordKey];
	if (result) {
		NSLog(@"save completed.");
	} else {
		NSLog(@"save failed.");
	}
}

- (IBAction)getPassword:(id)sender
{
#pragma unused(sender)
	
	NSData *passdata = [self.manager getGenericPasswordForKey:(NSString *)PasswordKey];
	
	if (passdata) {
		self.passwordLabel.text = [[NSString alloc] initWithData:passdata encoding:NSUTF8StringEncoding];
	} else {
		self.passwordLabel.text = @"password can't get";
	}
}

- (IBAction)deletePassword:(id)sender
{
#pragma unused(sender)
	
	BOOL result = [self.manager deleteGenericPassword:(NSString *)PasswordKey];
	if (result) {
		NSLog(@"delete completed.");
	} else {
		NSLog(@"delete failed.");
	}
}

@end
