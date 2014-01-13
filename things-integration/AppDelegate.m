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
    BOOL frontMost = _thingsApp.frontmost;
    NSString *myVal;
    NSString *version = _thingsApp.name;
    if(frontMost) {
        myVal = @"is frontmost";
    }
    else {
        myVal = @"is not frontmost";
    }
    
    
    SBElementArray *allLists = _thingsApp.lists;
    
    thingsAppList *firstObject = [allLists objectAtIndex:0];
    
    
    
    for (thingsAppList *obj in allLists) {
        // Generic things that you do to objects of *any* class go here.
        // NSLog(@"this is the variable value: %@",obj.name);
        if([obj.name isEqualToString:@"Logbook"]) {
            _logbook = obj;
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    if(_logbook) {
        loggedTodos = _logbook.toDos;
        for (thingsAppToDo *todo in loggedTodos) {
            //NSLog(@"%@ %@",todo.id, todo.name);
            
            NSDictionary *daTodo = [NSDictionary
                                    dictionaryWithObjectsAndKeys:
                                    todo.id, @"id",
                                    todo.name, @"name",
                                    [dateFormatter stringFromDate:todo.creationDate], @"creationDate",
                                    [dateFormatter stringFromDate:todo.completionDate], @"completionDate",
                                    nil];
            [_todoList addObject:daTodo];
            
        }
        
        
        NSLog(@"Number in array %lu", (unsigned long)_todoList.count);
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_todoList options:NSJSONWritingPrettyPrinted error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
        } else {
            _prettifiedThingsJSONData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", _prettifiedThingsJSONData);
        }
        
    }
    
    [self.sampleTextField setStringValue:[NSString stringWithFormat:@"%@ %@", version, firstObject.name]];
    
}



- (IBAction)doIt:(id)sender {
    NSLog(@"________________________");
    NSLog(@"%@", _prettifiedThingsJSONData);
    NSLog(@"________________________");
}
@end
