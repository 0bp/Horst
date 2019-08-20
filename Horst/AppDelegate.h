//
//  AppDelegate.h
//  Horst
//
//  Created by Boris Penck on 19.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>
#import <Quartz/Quartz.h>
#import "Helper.h"
#import "HorstTextFieldCell.h"
#import "HorstDataSource.h"
#import "HorstNavigationView.h"
#import "HorstSplitView.h"
#import "HorstRegistrationPanel.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>
{
  HorstDataSource * HorstDS;
}

@property (assign) IBOutlet HorstRegistrationPanel *registration;
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSString* helperID;
@property (weak) IBOutlet NSTableView * GroupsTable;
@property (assign) long selectedRow;
@property (nonatomic, retain) NSString * editorContent;
@property (unsafe_unretained) IBOutlet NSTextView *setContent;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet HorstNavigationView *navigationView;
@property (weak) IBOutlet HorstSplitView *splitView;
@property (weak) IBOutlet NSButton *SaveButton;
@property (nonatomic, retain) NSConnection* connection;


- (IBAction)clickRegistration:(id)sender;
- (Helper*)helper;
- (OSStatus)setupAuthorization:(AuthorizationRef*)authRef;
- (NSError*)installHelperApplication;
- (BOOL)authorizeHelper;
- (BOOL)helperIsInstalled;
- (IBAction)addSet:(id)sender;
- (IBAction)removeSet:(id)sender;
- (void)hideTextView:(BOOL)hide;
- (IBAction)saveButtonClick:(id)sender;
- (IBAction)clickNextSet:(id)sender;
- (IBAction)clickPreviousSet:(id)sender;
- (IBAction)clickEditSet:(id)sender;
- (IBAction)clickToggleSet:(id)sender;
- (IBAction)clickDisableSet:(id)sender;
- (IBAction)clickEnableSet:(id)sender;
- (IBAction)clickHelp:(id)sender;
- (IBAction)clickPreferences:(id)sender;

@end

