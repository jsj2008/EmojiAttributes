EmojiAttributes
=============

Fixing emoji display bugs for all capable iOS versions

Description
=============

In order to display emoji text correctly, iOS has to know their corresponding character set (a set of all emoji unicodes) so that it can apply
the proper attributes (specific configuration of individual font) to emoji text. The problem is when you try to add some new emoji to earlier
versions of iOS. Since the corresponding character set is fixed, depended on iOS itself, any new emoji will be displayed incorrectly
(as "?" icon instead of actual emoji). We need to modify the character set to include all emoji we needed, and EmojiAttributes does that job.

Technical Information
=============

This tweak may be categorized into three major parts:
* [Active] Character set addition (Main)
* [Active] CF-based emoji display (CoreFoundationHack)
* [Active] Web-based emoji display (WebCoreHack)
* [Active] TextInput character set addition (TextInputHack)
* [Awaiting] ICU-based emoji display (ICUHack)

Some parts no words for now:
* [Awaiting] MIME

The first part is already described above. For CoreFoundation hack, the algorithm mimics emoji support from open-source of latest CoreFoundation framework
found on the internet. For WebCore hack, the algorithm aims to fix emoji
display on websites (which is different from display of iOS system itself) by implementing the whole modern code from open-source WebKit (WebCore here) framework.
Character set addition also takes place in `TextInput.framework`, as presented in TextInputHack. Using the up-to-date bitmap is always good when a tweak developer checks whether a string contains emoji via `-[NSString(TIExtras) _containsEmoji]`.
ICUHack is similar to WebCoreHack, but it mainly focuses on ICU-related stuff. New emojis data is spotted there but apparently not used at this time. Anyway, it's
always better to keep until it comes into play.

All Bugs So Far
=============

* [iOS 6] Grouped emojis may not be rendered correctly at the line break
* [All] Profession emojis deletion issue
