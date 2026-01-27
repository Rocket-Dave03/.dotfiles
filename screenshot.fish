#!/usr/bin/env fish
argparse 'o/ocr' 'c/copy' -- $argv
or return

function grab_clip
	if test "$XDG_SESSION_TYPE" = "x11"
		echo "shot clipboard"
		shotgun -g (slop) - | xclip -selection clipboard -t image/png
	else if test "$XDG_SESSION_TYPE" = "wayland"
		echo "grim clip"
		grim -g (slurp) /tmp/capture.png && wl-copy < /tmp/capture.png
	else
		echo "Unsupported XDG_SESSION_TYPE: '$XDG_SESSION_TYPE'"
	end
end


function grab_ocr
	if test "$XDG_SESSION_TYPE" = "x11"
		echo "shotgun ocr"
		shotgun -g (slop) /tmp/capture.png && tesseract /tmp/capture.png - 2>/dev/null | xclip -i -selection clipboard
	else if test "$XDG_SESSION_TYPE" = "wayland"
		echo "grim ocr"
		wl-copy (grim -g (slurp) /tmp/capture.png && sleep 0.1 && tesseract /tmp/capture.png - 2>/dev/null)
	else
		echo "Unsupported XDG_SESSION_TYPE: '$XDG_SESSION_TYPE'"
	end
end

if  set -ql _flag_ocr and set -ql flat_copy
	echo "Only one of -o/--ocr and -c/--copy can be used"
	return 1
else if set -ql _flag_ocr
	grab_ocr
	return 0 
else if set -ql _flag_copy
	grab_clip
	return 0 
else
	echo "One of -o/--ocr and -c/--copy must be used"
	return 1
end
