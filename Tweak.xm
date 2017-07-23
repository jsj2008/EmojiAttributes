#define CHECK_TARGET
#define CHECK_EXCEPTIONS
#import <dlfcn.h>
#import "../PS.h"

%ctor {
    if (_isTarget(TargetTypeGUINoExtension, @[@"com.apple.mobilesms.compose", @"com.apple.MobileSMS.MessagesNotificationExtension", @"com.apple.WebKit.WebContent"]))
        dlopen("/Library/Application Support/EmojiAttributes/EmojiAttributes.dylib", RTLD_LAZY);
}
