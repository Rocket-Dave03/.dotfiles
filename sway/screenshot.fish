#!/usr/bin/env fish
argparse 'o/ocr' 'c/copy' -- $argv
or return

if  set -ql _flag_ocr and set -ql flat_copy
	echo "Only one of -o/--ocr and -c/--copy can be used"
	return 1
else if set -ql _flag_ocr
	wl-copy (grim -g (slurp) /tmp/capture.png && sleep 0.1 && tesseract /tmp/capture.png - 2>/dev/null)
	return 0 
else if set -ql _flag_copy
	grim -g (slurp) /tmp/capture.png && wl-copy < /tmp/capture.png
	return 0 
else
	echo "One of -o/--ocr and -c/--copy must be used"
	return 1
end
