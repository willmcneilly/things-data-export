//
//  AppDelegate.m
//  things-integration
//
//  Created by William McNeilly on 08/01/2014.
//  Copyright (c) 2014 William McNeilly. All rights reserved.
//

#import "AppDelegate.h"
#import "ThingsApp.h"


@implementation AppDelegate

{
    thingsAppApplication *_thingsApp;
    thingsAppList *_logbook;
    SBElementArray *loggedTodos;
    NSMutableArray *_todoList;
    NSString *_prettifiedThingsJSONData;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(thingsThread)
                                                   object:nil];
    [myThread start];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.google.com/"]];
    [self.analyticsView.mainFrame loadRequest:request];

}

- (void)thingsThread {
    [self thingsSetUp];
    [self getAllData];
}

- (void)thingsSetUp
{
    NSURL *thingsURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Applications/Things.app", NSOpenStepRootDirectory()]];
    _thingsApp = [SBApplication applicationWithURL:thingsURL];
}

- (void)getAllData
{
    _todoList = [NSMutableArray arrayWithCapacity:50];
    
    SBElementArray *allLists = _thingsApp.lists;
    
    
    for (thingsAppList *obj in allLists) {
        if([obj.name isEqualToString:@"Logbook"]) {
            _logbook = obj;
        }
        
    }
    
    
//    @property (copy) NSString *name;  // Name of the to do
//    @property (copy) NSDate *creationDate;  // Creation date of the to do
//    @property (copy) NSDate *modificationDate;  // Modification date of the to do
//    @property (copy) NSDate *dueDate;  // Due date of the to do
//    @property (copy, readonly) NSDate *activationDate;  // Activation date of the scheduled to do
//    @property (copy) NSDate *completionDate;  // Completion date of the to do
//    @property (copy) NSDate *cancellationDate;  // Cancellation date of the to do
//    @property thingsAppStatus status;  // Status of the to do
//    @property (copy) NSString *tagNames;  // Tag names separated by comma
//    @property (copy) NSString *notes;  // Notes of the to do
//    @property (copy) thingsAppProject *project;  // Project the to do belongs to
//    @property (copy) thingsAppArea *area;  // Area the to do belongs to
//    @property (copy) thingsAppContact *contact;  // Contact the to do is assigned to
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    if(_logbook) {
        loggedTodos = _logbook.toDos;
        for (thingsAppToDo *todo in loggedTodos) {
//            NSLog(@"%@, %@, %@, %@",todo.id, todo.name, todo.area.name, todo.project.name);
            NSString *areaName = [self checkIfNull:todo.area.name];

            NSString *todoID = [self checkIfNull:todo.id];
            NSString *name = [self checkIfNull:todo.name];
            NSString *creationDate = [self checkIfNull:[dateFormatter stringFromDate:todo.creationDate]];
            NSString *modificationDate = [self checkIfNull:[dateFormatter stringFromDate:todo.modificationDate]];
            NSString *dueDate = [self checkIfNull:[dateFormatter stringFromDate:todo.dueDate]];
            NSString *activationDate = [self checkIfNull:[dateFormatter stringFromDate:todo.activationDate]];
            NSString *completionDate = [self checkIfNull:[dateFormatter stringFromDate:todo.completionDate]];
            NSString *tagNames = [self checkIfNull:todo.tagNames];
            NSString *projectName = [self checkIfNull:todo.project.name];
            
//            NSLog(@"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@ \n\n",areaName, todoID, name, creationDate, modificationDate, dueDate, activationDate, completionDate, tagNames, projectName);
           
            
            
            NSDictionary *daTodo = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    areaName, @"areaName",
                                    todoID, @"id",
                                    name, @"name",
                                    creationDate, @"creationDate",
                                    modificationDate, @"modificationDate",
                                    dueDate, @"dueDate",
                                    activationDate, @"activationDate",
                                    completionDate, @"completionDate",
                                    // TODO: Status
                                    tagNames, @"tagNames",
                                    //todo.notes, @"notes",
                                    projectName, @"projectName",
                                    
                                    // TODO: Contact
                                    nil];
            
//            NSLog(@"%@", daTodo);
//            NSLog(@"-----------------------------------\n\n");
            [_todoList addObject:daTodo];
            
            
        }
        
        //NSLog(@"array: %@", _todoList);
        
        
        NSLog(@"Number in array %lu", (unsigned long)_todoList.count);
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_todoList options:NSJSONWritingPrettyPrinted error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            _prettifiedThingsJSONData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self createFileFromData:_prettifiedThingsJSONData];
            NSLog(@"%@", _prettifiedThingsJSONData);
        }
        
    }
    
}

- (id) checkIfNull:(NSString*)stringToCheck {
    if(stringToCheck.length == 0){
        return [NSNull null];
    }
    else {

        return stringToCheck;
    }
}

- (void) createFileFromData:(NSString *)dataString {
    NSError * error = NULL;
    NSString *pathToDesktop = [NSString stringWithFormat:@"/Users/%@/Desktop", NSUserName()];
    NSString *fileName = [NSString stringWithFormat:@"%@/test.json", pathToDesktop];
    BOOL success = [dataString writeToFile:fileName atomically:NO  encoding:NSUTF8StringEncoding error:&error];
    if(success == NO)
    {
        NSLog( @"error saving to %@ - %@", fileName, [error localizedDescription] );
    }

}



- (IBAction)doIt:(id)sender {
    NSLog(@"________________________");
    NSLog(@"%@", _prettifiedThingsJSONData);
    NSLog(@"________________________");
}
@end
