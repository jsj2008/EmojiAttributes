#import "../PS.h"

#ifdef COMPRESSED

static NSData *dataFromHexString(NSString *string) {
    string = [string lowercaseString];
    NSMutableData *data = [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {
        '\0', '\0', '\0'
    };
    NSUInteger i = 0;
    NSUInteger length = string.length;
    while (i < length - 1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

CFDataRef (*XTCopyUncompressedBitmapRepresentation)(const UInt8 *, CFIndex);
static NSString *compressedSet = @"02000000 01400000 04800000 00000904 ff030600 01800042 f5010580 00200000 00000010 00020900 06800800 00000000 00000400 00020500 0280f003 00061600 0280000c 00010b00 028000fe 0f070c00 01800400 0d002280 000c4000 01000000 00000078 1f403221 4dc40007 05ff0f00 69010088 0000fc1a 030c0360 30c11a00 0006bf27 24bf5420 02011800 9050b800 18000000 0000e000 02000180 17000180 30001c00 0680e000 00180000 00000000 21004d00 01800120 25000180 8002d60a 0180feff 04400180 ff070a00 0180feff 04400180 ff070a00 0180feff 04400180 0f000a00 0580feff ffffffff ffffff3f 0b000580 feffffff ffffffff ff1f0b00 0580fefb ffffffff ff000000 8b010180 00801f00 01800100 ff0e0180 00100c00 01808000 09000f80 0003c000 40fe0700 00000000 000000c0 ffffff06 00000400 80fc0700 00030a00 038000ff fffffff3 06400280 ffcfceff 04400180 ffb91040 1180bfff ffffffff ffff3f00 7effffff 80f90780 3c610030 0106101c 000e700a 8108fcff 04400b80 ff000000 000000ff ffffffff ffffff3f f807003f 1a792100 0c8000ff 7fff00f9 77bf0fff 7f000000 00ffff03 00000000 00016300 00";
static CFCharacterSetRef ourSet = NULL;

#else

static NSCharacterSet *fixUpCharacterSet(NSCharacterSet *set) {
    NSMutableCharacterSet *mutableSet = [set mutableCopy];
    [mutableSet addCharactersInString:@"0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣#️⃣*️⃣"];
    return [mutableSet autorelease];
}

static CFCharacterSetRef ourLegacySet = NULL;

#endif