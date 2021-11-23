#import "PluginNotiPlugin.h"
#if __has_include(<plugin_noti/plugin_noti-Swift.h>)
#import <plugin_noti/plugin_noti-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin_noti-Swift.h"
#endif

@implementation PluginNotiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPluginNotiPlugin registerWithRegistrar:registrar];
}
@end
