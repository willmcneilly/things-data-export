//
//  AppDelegate.h
//  things-integration
//
//  Created by William McNeilly on 08/01/2014.
//  Copyright (c) 2014 William McNeilly. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *sampleTextField;
@property (weak) IBOutlet NSButton *doTheShiz;
- (IBAction)doIt:(id)sender;
@property (weak) IBOutlet WebView *analyticsView;

@end
