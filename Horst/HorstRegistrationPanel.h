//
//  HorstRegistrationPanel.h
//  Horst
//
//  Created by Boris Penck on 05.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "LicenseManager.h"

@interface HorstRegistrationPanel : NSPanel <NSTextFieldDelegate>

@property (weak) IBOutlet NSTextField * user;
@property (weak) IBOutlet NSTextField * key;
@property (weak) IBOutlet NSTextField * code;
@property (weak) IBOutlet NSTextField * label;
@property (retain) NSString * originalLabel;
@property (weak) IBOutlet NSButton *buyButton;

- (IBAction)clickBuy:(id)sender;
- (void)checkLicense;
- (void)applicationDidFinishLaunching;

@end
