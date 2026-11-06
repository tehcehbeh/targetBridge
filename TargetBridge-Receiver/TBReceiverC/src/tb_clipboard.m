#import <AppKit/AppKit.h>
#include <string.h>
#include "tb_clipboard.h"

long tb_clipboard_change_count(void) {
    @autoreleasepool {
        return (long)[[NSPasteboard generalPasteboard] changeCount];
    }
}

int tb_clipboard_get_text(char *dest, size_t size) {
    if (!dest || size == 0) return 0;
    dest[0] = '\0';
    @autoreleasepool {
        NSString *text = [[NSPasteboard generalPasteboard] stringForType:NSPasteboardTypeString];
        if (!text) return 1;
        const char *utf8 = [text UTF8String];
        if (!utf8) return 1;
        size_t n = strlen(utf8);
        if (n >= size) {
            n = size - 1;
            /* Do not cut a multi-byte UTF-8 sequence in half. */
            while (n > 0 && ((unsigned char)utf8[n] & 0xC0) == 0x80) n--;
        }
        memcpy(dest, utf8, n);
        dest[n] = '\0';
    }
    return 1;
}

void tb_clipboard_set_text(const char *text) {
    @autoreleasepool {
        NSPasteboard *pb = [NSPasteboard generalPasteboard];
        [pb clearContents];
        if (text && *text) {
            NSString *s = [NSString stringWithUTF8String:text];
            if (s) [pb setString:s forType:NSPasteboardTypeString];
        }
    }
}
