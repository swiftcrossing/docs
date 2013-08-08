SmartDebug is a tool for adding tags, as well as other useful debugging
information to XCode's logging functionality.

Usage:
1. Add the SmartDebug directory to your XCode project.
2. In the "Build Settings" tab of your project file, add "-DSMART_DEBUG" to
   the "Debug" section of "Other C Flags".
3. In the "Build Phases" tab of your project file, add a Run Script.
4. Add the following line to the Run Script.

    /usr/bin/perl "${SRCROOT}/PATH/TO/SmartDebug/SmartDebug.pl"
	"${SRCROOT}/PATH/TO//SmartDebug/SmartDebug.plist"

5. Drag the Run script to execute before the "Compile Sources" Build Phase.
6. Build the project once to generate the SmartDebug.plist settings file.
7. Add the SmartDebug.plist to your project under the SmartDebug directory.
8. If using git, add SmartDebug.plist to .gitignore file.

Once the SmartDebug.plist settings file has be imported to you project, you can
edit the values to turn on and off the display of certain tags.

###############################################################################

SmartCrash is a tool for reporting app crashing from a production environment
by saving a crash log to the device, then sending it to a desired location on
the next startup. The sending of crash log data is left up to the user to
implement.

Usage:
1. Import SmartCrash.h into your AppDelegate.
2. In the

          - (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions

method in your AppDelegate, add the following two lines of code.

    SmartCrash *smartCrash = [[SmartCrash alloc] init];
	[smartCrash sendCrashLog];

3. Implement the - (void)sendCrashLog method in order to have the recorded
crash log be sent to a location of your choice on start up.
