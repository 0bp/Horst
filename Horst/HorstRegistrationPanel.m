//
//  HorstRegistrationPanel.m
//  Horst
//
//  Created by Boris Penck on 05.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HorstRegistrationPanel.h"

@implementation HorstRegistrationPanel

@synthesize user = _user;
@synthesize key = _key;
@synthesize code = _code;
@synthesize label = _label;
@synthesize originalLabel = _originalLabel;
@synthesize buyButton = _buyButton;

- (IBAction)clickBuy:(id)sender
{
  NSURL * someUrl = [NSURL URLWithString:@"http://penck.de/horst/"];
  [[NSWorkspace sharedWorkspace] openURL:someUrl];
}

- (void)applicationDidFinishLaunching
{
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary * reg = [defaults objectForKey:@"registration"];
  
  if(reg)
  {
    NSString * user = [reg objectForKey:@"user"];
    NSString * key = [reg objectForKey:@"key"];
    NSString * code = [reg objectForKey:@"code"];
    
    if(user)
    {
      _user.stringValue = user;
    }
    if(key)
    {
      _key.stringValue = key;
    }
    if(code)
    {
      _code.stringValue = code;
    }
  }
  
	[[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(textDidChange:)  
                                               name:NSControlTextDidChangeNotification 
                                             object:_user];

  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(textDidChange:)  
                                               name:NSControlTextDidChangeNotification 
                                             object:_key];

  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(textDidChange:)  
                                               name:NSControlTextDidChangeNotification 
                                             object:_code];

  
  _originalLabel = _label.stringValue;
  
  [self checkLicense];
}

- (void)checkLicense
{
  [[BPLicenseManager sharedManager]  setUser:(NSString *)[_user stringValue] 
                                         key:(NSString *)[_key stringValue]
                                        code:(NSString *)[_code stringValue]];
  
  if([[BPLicenseManager sharedManager] isValid])
  {
    _label.stringValue = @"Thanks, you rock!";
    [_buyButton setHidden:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRegistrationSuccessful" object:self];
  } 
  else
  {
    _label.stringValue = _originalLabel;
    [_buyButton setHidden:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userRegistrationFailed" object:self];
  }
}

#pragma mark Delegate Methods

-(void)textDidChange:(NSNotification *)notification
{
  NSMutableDictionary * reg = [NSMutableDictionary dictionary];
  [reg setObject:(NSString *)[_user stringValue] forKey:@"user"];
  [reg setObject:(NSString *)[_key stringValue] forKey:@"key"];
  [reg setObject:(NSString *)[_code stringValue] forKey:@"code"];
  
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:reg forKey:@"registration"];
  [defaults synchronize];
  
  [self checkLicense];
}

@end
