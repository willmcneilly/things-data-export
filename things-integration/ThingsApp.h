
/*
 * thingsApp.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class thingsAppWindow, thingsAppApplication, thingsAppList, thingsAppArea, thingsAppContact, thingsAppTag, thingsAppToDo, thingsAppProject, thingsAppSelectedToDo;

enum thingsAppPrintingErrorHandling {
	thingsAppPrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	thingsAppPrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum thingsAppPrintingErrorHandling thingsAppPrintingErrorHandling;

enum thingsAppStatus {
	thingsAppStatusOpen = 'tdio' /* To do is open. */,
	thingsAppStatusCompleted = 'tdcm' /* To do has been completed. */,
	thingsAppStatusCanceled = 'tdcl' /* To do has been canceled. */
};
typedef enum thingsAppStatus thingsAppStatus;



/*
 * Standard Suite
 */

// A window.
@interface thingsAppWindow : SBObject

@property (copy, readonly) NSString *name;  // The full title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Whether the window has a close box.
@property (readonly) BOOL minimizable;  // Whether the window can be minimized.
@property BOOL minimized;  // Whether the window is currently minimized.
@property (readonly) BOOL resizable;  // Whether the window can be resized.
@property BOOL visible;  // Whether the window is currently visible.
@property (readonly) BOOL zoomable;  // Whether the window can be zoomed.
@property BOOL zoomed;  // Whether the window is currently zoomed.

- (void) close;  // Close a window.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy object(s) and put the copies at a new location.
- (void) show;  // Show Things item in the UI
- (void) moveTo:(thingsAppList *)to;  // Move a to do to a different list.
- (void) scheduleFor:(NSDate *)for_;  // Schedules a Things to do

@end



/*
 * Things Suite
 */

// The application's top-level scripting object.
@interface thingsAppApplication : SBApplication

- (SBElementArray *) windows;
- (SBElementArray *) lists;
- (SBElementArray *) toDos;
- (SBElementArray *) projects;
- (SBElementArray *) areas;
- (SBElementArray *) contacts;
- (SBElementArray *) tags;
- (SBElementArray *) selectedToDos;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the frontmost (active) application?
@property (copy, readonly) NSString *version;  // The version of the application.

- (void) print:(id)x withProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) quit;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify if an object exists.
- (void) showQuickEntryPanelWithAutofill:(BOOL)withAutofill withProperties:(NSDictionary *)withProperties;  // Show Things Quick Entry panel
- (void) logCompletedNow;  // Log completed items now
- (void) emptyTrash;  // Empty Things trash
- (thingsAppContact *) addContactNamed:(NSString *)x;  // Add a contact to Things from your Address Book
- (thingsAppToDo *) parseQuicksilverInput:(NSString *)x;  // Add new Things to do from input in Quicksilver syntax

@end

// Represents a Things list.
@interface thingsAppList : SBObject

- (SBElementArray *) toDos;

- (NSString *) id;  // The unique identifier of the list.
@property (copy) NSString *name;  // Name of the list

- (void) close;  // Close a window.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy object(s) and put the copies at a new location.
- (void) show;  // Show Things item in the UI
- (void) moveTo:(thingsAppList *)to;  // Move a to do to a different list.
- (void) scheduleFor:(NSDate *)for_;  // Schedules a Things to do

@end

// Represents a Things area of responsibility.
@interface thingsAppArea : thingsAppList

- (SBElementArray *) toDos;
- (SBElementArray *) tags;

@property (copy) NSString *tagNames;  // Tag names separated by comma
@property BOOL suspended;  // Status of the area


@end

// Represents a Things contact.
@interface thingsAppContact : thingsAppList

- (SBElementArray *) toDos;


@end

// Represents a Things tag.
@interface thingsAppTag : SBObject

- (SBElementArray *) tags;
- (SBElementArray *) toDos;

- (NSString *) id;  // The unique identifier of the tag.
@property (copy) NSString *name;  // Name of the tag
@property (copy) NSString *keyboardShortcut;  // Keyboard shortcut for the tag
@property (copy) thingsAppTag *parentTag;  // Parent tag

- (void) close;  // Close a window.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy object(s) and put the copies at a new location.
- (void) show;  // Show Things item in the UI
- (void) moveTo:(thingsAppList *)to;  // Move a to do to a different list.
- (void) scheduleFor:(NSDate *)for_;  // Schedules a Things to do

@end

// Represents a Things to do.
@interface thingsAppToDo : SBObject

- (SBElementArray *) tags;

- (NSString *) id;  // The unique identifier of the to do.
@property (copy) NSString *name;  // Name of the to do
@property (copy) NSDate *creationDate;  // Creation date of the to do
@property (copy) NSDate *modificationDate;  // Modification date of the to do
@property (copy) NSDate *dueDate;  // Due date of the to do
@property (copy, readonly) NSDate *activationDate;  // Activation date of the scheduled to do
@property (copy) NSDate *completionDate;  // Completion date of the to do
@property (copy) NSDate *cancellationDate;  // Cancellation date of the to do
@property thingsAppStatus status;  // Status of the to do
@property (copy) NSString *tagNames;  // Tag names separated by comma
@property (copy) NSString *notes;  // Notes of the to do
@property (copy) thingsAppProject *project;  // Project the to do belongs to
@property (copy) thingsAppArea *area;  // Area the to do belongs to
@property (copy) thingsAppContact *contact;  // Contact the to do is assigned to

- (void) close;  // Close a window.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (SBObject *) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy object(s) and put the copies at a new location.
- (void) show;  // Show Things item in the UI
- (void) edit;  // Edit Things to do
- (void) moveTo:(thingsAppList *)to;  // Move a to do to a different list.
- (void) scheduleFor:(NSDate *)for_;  // Schedules a Things to do

@end

// Represents a Things project.
@interface thingsAppProject : thingsAppToDo

- (SBElementArray *) toDos;


@end

// Represents a to do selected in Things UI.
@interface thingsAppSelectedToDo : thingsAppToDo


@end

