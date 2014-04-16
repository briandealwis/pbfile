/*
 * pbfile - copy file references on to the clipboard
 * Written and placed in the public domain by Brian de Alwis
 */

#import <Cocoa/Cocoa.h>
#ifndef MAXPATHLEN
#define MAXPATHLEN (8192)
#endif

int main(int argc, char *argv[])
{
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	char buf[MAXPATHLEN];
	
	if(argc < 2) {
		printf("use: %s filenames ...\n", argv[0]);
		printf("Copies references to filenames to clipboard for pasting\n");
                exit(1);
	}
	
	NSString *cwd = [NSString stringWithUTF8String: getcwd(buf, MAXPATHLEN)];
	NSMutableArray *fileNames = [[NSMutableArray alloc] init];
	for(--argc, ++argv; argc; --argc,++argv) {
		// what if the encoding is not UTF-8?
		//	NSString stringWithCString: *argv encoding: (NSStringEncoding)
		// but what NSStringEncoding?
		NSString *path = [NSString stringWithUTF8String: *argv];
		path = [path stringByStandardizingPath];
		if([path characterAtIndex:0] != '/') {
			path = [cwd stringByAppendingPathComponent:path];
		}
		NSLog(@"Adding %@", path);
		[fileNames addObject: path];
	}
	
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[pb clearContents];
	NSArray *types = [NSArray arrayWithObjects: NSFilenamesPboardType, nil];
	[pb declareTypes:types owner:nil];
	[pb setPropertyList:fileNames forType:NSFilenamesPboardType];

	// Small sleep seems required on 10.9!?  Allow time for the pasteboard to sync up?
	usleep(100);
	
	[pool drain];
	return 0;
}

