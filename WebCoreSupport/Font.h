#include <unicode/utf16.h>

namespace WebCore {
	class FontCascade {
		public:
			static bool isCJKIdeograph(UChar32);
			static bool isCJKIdeographOrSymbol(UChar32);
			enum CodePath { Auto, Simple, Complex, SimpleWithGlyphOverflow };
			//static CodePath characterRangeCodePath(const LChar*, unsigned) { return Simple; }
			static CodePath characterRangeCodePath(const UChar*, unsigned len);
		};
};