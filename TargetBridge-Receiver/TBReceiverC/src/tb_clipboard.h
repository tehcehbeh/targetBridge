/* tb_clipboard.h — native pasteboard access for the receiver.
 *
 * The receiver used to run `popen("pbpaste")` from its main loop every 100 ms
 * while the sender is controlled from this Mac. Spawning a process takes
 * hundreds of milliseconds on older Macs and froze video, input forwarding and
 * the cursor for that long. NSPasteboard's changeCount is a cheap integer
 * compare; the text is only read when the clipboard actually changed. */

#ifndef TB_CLIPBOARD_H
#define TB_CLIPBOARD_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

/* Increments whenever the general pasteboard content changes. */
long tb_clipboard_change_count(void);

/* Copies the pasteboard's plain text (UTF-8, NUL-terminated) into dest.
 * Returns 1 on success (dest may be empty), 0 on failure. */
int tb_clipboard_get_text(char *dest, size_t size);

/* Replaces the pasteboard content with the given UTF-8 text. */
void tb_clipboard_set_text(const char *text);

#ifdef __cplusplus
}
#endif

#endif
