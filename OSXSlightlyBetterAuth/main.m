//
//  main.m
//  OSXSlightlyBetterAuth
//
//  Created by Maojie Tang on 14-3-19.
//
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        
        // Create authorization reference
        OSStatus status;
        AuthorizationRef authorizationRef;
        
        // AuthorizationCreate and pass NULL as the initial
        // AuthorizationRights set so that the AuthorizationRef gets created
        // successfully, and then later call AuthorizationCopyRights to
        // determine or extend the allowable rights.
        // http://developer.apple.com/qa/qa2001/qa1172.html
        status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authorizationRef);
        if (status != errAuthorizationSuccess) {
            NSLog(@"Error Creating Initial Authorization: %d", status);
        }
    
        // kAuthorizationRightExecute = "system.privilege.admin"
        AuthorizationItem right = { kAuthorizationRightExecute, 0, NULL, 0 };
        AuthorizationRights rights = { 1, &right };
        AuthorizationFlags flags = kAuthorizationFlagDefaults |
                                   kAuthorizationFlagInteractionAllowed |
                                   kAuthorizationFlagPreAuthorize |
                                   kAuthorizationFlagExtendRights;
        
        // Call AuthorizationCopyRights to determine or exted the allowable rights.
        status = AuthorizationCopyRights(authorizationRef, &rights, NULL, flags, NULL);
        if (status != errAuthorizationSuccess) {
            NSLog(@"Copy Rights Unsuccessful: %d", status);
        }
        
        NSLog(@"\n\n ** %@ **\n\n", @"This command should work.");
        char *tool = "/Users/maojie/Documents/XcodeProjects/ShowEUID/DerivedData/ShowEUID/Build/Products/Debug/ShowEUID.app/Contents/MacOS/ShowEUID";
        char *args[] = { NULL };
        FILE *pipe = NULL;
        
        status = AuthorizationExecuteWithPrivileges(authorizationRef, tool, kAuthorizationFlagDefaults, args, &pipe);
        if (status != errAuthorizationSuccess) {
            NSLog(@"Error: %d", status);
        }
        
        status = AuthorizationFree(authorizationRef, kAuthorizationFlagDestroyRights);
    }
    return 0;
}

