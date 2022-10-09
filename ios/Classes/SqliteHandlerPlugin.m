#import "SqliteHandlerPlugin.h"
#if __has_include(<sqlite_handler/sqlite_handler-Swift.h>)
#import <sqlite_handler/sqlite_handler-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sqlite_handler-Swift.h"
#endif

@implementation SqliteHandlerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSqliteHandlerPlugin registerWithRegistrar:registrar];
}
@end
