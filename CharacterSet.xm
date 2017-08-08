#import "CharacterSet.h"

CFCharacterSetRef (*CreateCharacterSetForFont)(CFStringRef const);
%hookf(CFCharacterSetRef, CreateCharacterSetForFont, CFStringRef const fontName) {
    if (CFEqual(fontName, CFSTR("AppleColorEmoji")) || CFEqual(fontName, CFSTR(".AppleColorEmojiUI"))) {
#ifdef COMPRESSED
        if (ourSet)
            return ourSet;
        CFDataRef compressedData = (CFDataRef)dataFromHexString(compressedSet);
        CFDataRef uncompressedData = XTCopyUncompressedBitmapRepresentation(CFDataGetBytePtr(compressedData), CFDataGetLength(compressedData));
        CFRelease(compressedData);
        if (uncompressedData) {
            ourSet = CFCharacterSetCreateWithBitmapRepresentation(kCFAllocatorDefault, uncompressedData);
            CFRelease(uncompressedData);
            return ourSet;
        }
#else
        if (ourLegacySet)
            return ourLegacySet;
        return ourLegacySet = (CFCharacterSetRef)[fixUpCharacterSet([NSCharacterSet characterSetWithContentsOfFile:[[NSBundle bundleWithIdentifier:isiOS10Up ? @"com.apple.CoreEmoji" : @"com.apple.TextInput"] pathForResource:isiOS10Up ? @"emoji2" : @"TIUserDictionaryEmojiCharacterSet" ofType:@"bitmap"]]) retain];
#endif
    }
    return %orig;
}

%ctor {
    MSImageRef ref = MSGetImageByName(realPath2(@"/System/Library/Frameworks/CoreText.framework/CoreText"));
    if (isiOS10Up)
        dlopen(realPath2(@"/System/Library/PrivateFrameworks/CoreEmoji.framework/CoreEmoji"), RTLD_LAZY);
    CreateCharacterSetForFont = (CFCharacterSetRef (*)(CFStringRef const))MSFindSymbol(ref, "__Z25CreateCharacterSetForFontPK10__CFString");
#ifdef COMPRESSED
    XTCopyUncompressedBitmapRepresentation = (CFDataRef (*)(const UInt8 *, CFIndex))MSFindSymbol(ref, "__Z38XTCopyUncompressedBitmapRepresentationPKhm");
    if (XTCopyUncompressedBitmapRepresentation == NULL || CreateCharacterSetForFont == NULL) {
#else
    if (CreateCharacterSetForFont == NULL) {
#endif
        HBLogError(@"Fatal: couldn't find necessarry symbol(s)");
        return;
    }
    %init;
}
