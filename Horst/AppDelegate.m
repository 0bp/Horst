//
//  AppDelegate.m
//  Horst
//
//  Created by Boris Penck on 19.12.11.
//  Copyright (c) 2011 Boris Penck. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize contentView;
@synthesize navigationView;
@synthesize splitView;
@synthesize SaveButton;
@synthesize setContent, editorContent;
@synthesize GroupsTable;

@synthesize registration = _registration;
@synthesize window = _window;
@synthesize connection, helperID, selectedRow;

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
  return YES;
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification
{
  HorstDS = [[HorstDataSource alloc] init];
  
  NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary * reg = [defaults objectForKey:@"registration"];
  
  NSString * user = @"";
  NSString * key = @"";
  NSString * code = @"";
  
  if(reg) {
    if([reg objectForKey:@"user"])
    {
      user = [reg objectForKey:@"user"];
    }
    if([reg objectForKey:@"key"])
    {
      key = [reg objectForKey:@"key"];
    }
    if([reg objectForKey:@"code"])
    {
      code = [reg objectForKey:@"code"];
    }
  }
  
  [[BPLicenseManager sharedManager] initWithApplicationSeed:@"REDACTED"];
  [[BPLicenseManager sharedManager] setUser:user 
                                        key:key 
                                       code:code];
  [self hideTextView:YES];
  [SaveButton setHidden:YES];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  [_registration applicationDidFinishLaunching];
  
  if(![[BPLicenseManager sharedManager] isValid])
  {
    [_window setTitle:[NSString stringWithFormat:@"UNREGISTERED: %@", [_window title]]];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(selectionDidChange:) 
                                               name:@"selectionDidChange" 
                                             object:HorstDS];
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(contentDidChange:) 
                                               name:@"contentDidChange" 
                                             object:HorstDS];

  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(saveConfiguration:) 
                                               name:@"saveConfiguration" 
                                             object:HorstDS];
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(registrationDidChange:) 
                                               name:@"userRegistrationSuccessful" 
                                             object:_registration];

  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(registrationDidChange:) 
                                               name:@"userRegistrationSuccessful" 
                                             object:_registration];
  
  
  GroupsTable.dataSource = HorstDS;
  GroupsTable.delegate = HorstDS;
  [GroupsTable setDoubleAction:@selector(editRow:)];
  GroupsTable.target = self;

  setContent.delegate = HorstDS;
  setContent.font = [NSFont fontWithName:@"Monaco" size:12];
  [[setContent textStorage] setDelegate:HorstDS];
  
  splitView.delegate = splitView;

  [[setContent textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
  [[setContent textContainer] setWidthTracksTextView:NO];
  [setContent setHorizontallyResizable:YES];
  
  self.editorContent = @"";
    
  [self authorizeHelper];
}

- (void)editRow:(id)sender
{
  if([GroupsTable clickedColumn] == 1) { 
    [GroupsTable editColumn:1 
                        row:[GroupsTable clickedRow] 
                  withEvent:nil 
                     select:YES];  
  }
}

- (void)registrationDidChange:(NSNotification *)notification
{
  if(![[BPLicenseManager sharedManager] isValid])
  {
    [_window setTitle:[NSString stringWithFormat:@"UNREGISTERED: %@", [_window title]]];
  } else {
    [_window setTitle:@"Horst"];
  }
}

- (void)saveConfiguration:(NSNotification *)notification
{
  [SaveButton setHidden:YES];
  [[self helper] hosts:[HorstDS config] hash:nil];
}

- (void)selectionDidChange:(NSNotification *)notification
{
  if([GroupsTable selectedRow] < 0) {
    self.editorContent = @"";
    [self hideTextView:YES];
    return;
  }

  [self hideTextView:NO];

  self.editorContent = [HorstDS dataForSetAtIndex:[GroupsTable selectedRow]];
  [GroupsTable reloadData];
  
  [_window makeFirstResponder:setContent];
  
  NSRange range = { [[setContent string] length], 0 };
  [setContent setSelectedRange: range];
}

- (void)hideTextView:(BOOL)hide
{
  if(hide) {
    [setContent setHidden:YES];
    [setContent setSelectable:NO];
  } else {
    [setContent setHidden:NO];
    [setContent setSelectable:YES];
  }
}

- (IBAction)saveButtonClick:(id)sender 
{
  [self saveConfiguration:nil];
}

- (IBAction)clickNextSet:(id)sender
{
  NSInteger index = [GroupsTable selectedRow];
  [GroupsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index+1] byExtendingSelection:NO];
}

- (IBAction)clickPreviousSet:(id)sender {
  NSInteger index = [GroupsTable selectedRow];
  [GroupsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index-1] byExtendingSelection:NO];
}

- (IBAction)clickEditSet:(id)sender
{
  [GroupsTable editColumn:1 
                      row:[GroupsTable selectedRow] 
                withEvent:nil 
                   select:YES];  
}

- (IBAction)clickToggleSet:(id)sender
{
  [HorstDS toggleIndex:[GroupsTable selectedRow]];
  [GroupsTable reloadData];
  [self saveConfiguration:nil];
}

- (IBAction)clickDisableSet:(id)sender
{
  if([GroupsTable selectedRow] > -1) {
    [HorstDS disableIndex:[GroupsTable selectedRow]];
    [GroupsTable reloadData];
    [self saveConfiguration:nil];
  }
}

- (IBAction)clickEnableSet:(id)sender
{
  if(![[BPLicenseManager sharedManager] isValid])
  {
    if([GroupsTable selectedRow] > 1) {
      NSBeep();
      return;
    }
  }
  
  if([GroupsTable selectedRow] > -1) {
    [HorstDS enableIndex:[GroupsTable selectedRow]];
    [GroupsTable reloadData];
    [self saveConfiguration:nil];
  }
}

- (IBAction)clickHelp:(id)sender
{
  NSURL * someUrl = [NSURL URLWithString:@"http://penck.de/horst/"];
  [[NSWorkspace sharedWorkspace] openURL:someUrl];
}

- (IBAction)clickPreferences:(id)sender
{
  NSRect newPosition = CGRectMake(splitView.frame.origin.x, splitView.frame.origin.y-100, splitView.frame.size.width, splitView.frame.size.height);
  
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:0.3f];
  [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];  
  
  [[splitView animator] setFrame:newPosition];
  
  [NSAnimationContext endGrouping];
}

- (BOOL)authorizeHelper 
{
  NSError * error;
  
  if(![self helperIsInstalled]) {
    error = [self installHelperApplication];
  }
  
  if (!error) {
    Helper * helper = [self helper];
    if (helper) {
      return YES;
    }
  }
  return NO;
}

- (void)contentDidChange:(NSNotification *)notification
{
  if([GroupsTable selectedRow] < 0) {
    self.editorContent = @"";
    [self hideTextView:YES];
    return;
  }
  
  if([HorstDS isEnabled:[GroupsTable selectedRow]]) 
  {
    [SaveButton setHidden:NO];
  }
  
  [HorstDS setContent:self.editorContent forSet:[GroupsTable selectedRow]];
  [GroupsTable reloadData];
}

- (IBAction)addSet:(id)sender
{
  [HorstDS addSet:@"New Set"];
  [GroupsTable reloadData];

  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[HorstDS rows]-1];
  [GroupsTable selectRowIndexes:indexSet byExtendingSelection:NO];
  
  [self saveConfiguration:nil];
}

- (IBAction)removeSet:(id)sender
{
  if([GroupsTable selectedRow] >= 0) 
  {
    [HorstDS removeSet:[GroupsTable selectedRow]];
    [GroupsTable reloadData];
  }
  [self saveConfiguration:nil];
  [self selectionDidChange:nil];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
  self.connection = nil;
}

#pragma mark - Installation

- (OSStatus)setupAuthorization:(AuthorizationRef*)authRef
{
	AuthorizationItem authItem		= { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
	AuthorizationRights authRights	= { 1, &authItem };
	AuthorizationFlags flags		=	kAuthorizationFlagDefaults				| 
  kAuthorizationFlagInteractionAllowed	|
  kAuthorizationFlagPreAuthorize			|
  kAuthorizationFlagExtendRights;
	
	// Obtain the right to install privileged helper tools (kSMRightBlessPrivilegedHelper).
	OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, authRef);
	if (status != errAuthorizationSuccess) 
  {
    *authRef = nil;
	}
  
  return status;
}

- (NSError*)installHelperApplication
{
  NSDictionary* helpers = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"SMPrivilegedExecutables"];
  self.helperID = [[helpers allKeys] objectAtIndex:0];
  
  NSError* error = nil;
  CFErrorRef * cferror = nil;
	AuthorizationRef authRef;
  OSStatus status = [self setupAuthorization:&authRef];

	if (status == errAuthorizationSuccess) 
  {
		SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef) self.helperID, authRef, cferror);
  }
  else
  {
    error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:[NSDictionary dictionaryWithObject:@"failed to get authorisation" forKey:NSLocalizedFailureReasonErrorKey]];
	} 
	
	return error;
}

- (BOOL) helperIsInstalled 
{
  NSDictionary* helpers = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"SMPrivilegedExecutables"];
  self.helperID = [[helpers allKeys] objectAtIndex:0];
  
  NSDictionary * installedHelperJobData = (__bridge NSDictionary *)
    SMJobCopyDictionary(kSMDomainSystemLaunchd, (__bridge CFStringRef)self.helperID);
  
  if(!installedHelperJobData) {
    return NO;
  }
  
  /* Helper Version */
  
  NSString * installedPath = [[installedHelperJobData objectForKey:@"ProgramArguments"] objectAtIndex:0];
  NSURL * installedPathURL = [NSURL fileURLWithPath:installedPath];
  
  NSDictionary * installedInfoPlist = (__bridge NSDictionary*)
    CFBundleCopyInfoDictionaryForURL( (__bridge CFURLRef)installedPathURL );
  
  NSString * installedBundleVersion = [installedInfoPlist objectForKey:@"CFBundleVersion"];

  /* Host Version */
  
  NSBundle * appBundle = [NSBundle mainBundle];
  NSURL * appBundleURL = [appBundle bundleURL];
  NSString * bundlePath = [NSString stringWithFormat: @"Contents/Library/LaunchServices/%@", self.helperID];
  
  
  NSURL * currentHelperToolURL = [appBundleURL URLByAppendingPathComponent:bundlePath];
  NSDictionary*  currentInfoPlist        = (__bridge NSDictionary*)CFBundleCopyInfoDictionaryForURL( (__bridge CFURLRef)currentHelperToolURL );
  NSString*      currentBundleVersion    = [currentInfoPlist objectForKey:@"CFBundleVersion"];
  
  NSLog(@"%@:%@", currentBundleVersion, installedBundleVersion);
  /* return version match */
  return [currentBundleVersion isEqualToString:installedBundleVersion];
}

#pragma mark - Helper

- (IBAction)clickRegistration:(id)sender
{
  [_registration makeKeyAndOrderFront:self];
}

- (Helper *)helper
{
  Helper * helper = nil;
  
  if (!self.connection)
  {
    NSString * name = @"com.borispenck.horst.helper";
    self.connection = [NSConnection connectionWithRegisteredName:name host:nil];
    
    if (!self.connection)
    {
      NSLog(@"could not find server.\n");
      return nil;
    }
    
    [self.connection setRequestTimeout:10.0];
    [self.connection setReplyTimeout:10.0];
  } 

  if (self.connection)
  {
    NSDistantObject * proxy = [self.connection rootProxy];
    if (!proxy) 
    {
      NSLog(@"could not get proxy");
      return nil;
    }
    helper = (Helper *)proxy;
  }

  return helper;
}

@end
