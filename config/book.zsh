# Download a YouTube video as audio and import it into Apple Books
#
# Usage: book <youtube-url>
#
# Prerequisites:
#   - yt-dlp:  brew install yt-dlp
#   - ffmpeg:  brew install ffmpeg
#

book() {
    local cmd URL WORKDIR DOWNLOADED FILENAME EXTENSION BASENAME M4B_PATH AAC_PATH

    # --- Check prerequisites ---
    for cmd in yt-dlp ffmpeg afconvert; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "Error: '$cmd' is not installed."
            if [[ "$cmd" == "afconvert" ]]; then
                echo "  afconvert is a built-in macOS tool — are you running this on a Mac?"
            else
                echo "  Install it with: brew install $cmd"
            fi
            return 1
        fi
    done

    # --- Validate input ---
    if [[ $# -lt 1 ]]; then
        echo "Usage: book <youtube-url>"
        return 1
    fi

    URL="$1"
    WORKDIR=$(mktemp -d)
    # Expand the path now: zsh runs a function's EXIT trap in the caller's
    # environment, where the local WORKDIR is already out of scope.
    trap "rm -rf ${(q)WORKDIR}" EXIT
    
    echo "==> Downloading audio from YouTube..."
    
    # Download best audio, prefer m4a (AAC) to avoid unnecessary transcoding.
    # Falls back to best available format if m4a isn't available.
    yt-dlp \
        -f "bestaudio[ext=m4a]/bestaudio" \
        -o "$WORKDIR/%(title)s.%(ext)s" \
        --no-playlist \
        "$URL"

    # Find the downloaded file (there should be exactly one)
    DOWNLOADED=$(find "$WORKDIR" -type f | head -1)

    if [[ -z "$DOWNLOADED" ]]; then
        echo "Error: Download failed — no file found."
        return 1
    fi
    
    FILENAME=$(basename "$DOWNLOADED")
    EXTENSION="${FILENAME##*.}"
    BASENAME="${FILENAME%.*}"
    
    echo "==> Downloaded: $FILENAME"
    
    # --- Convert to m4b (audiobook format for Apple Books) ---
    M4B_PATH="$WORKDIR/${BASENAME}.m4b"

    if [[ "$EXTENSION" == "m4a" ]]; then
        # m4a and m4b are identical formats, just rename
        echo "==> File is already AAC (m4a). Renaming to m4b..."
        mv "$DOWNLOADED" "$M4B_PATH"
    elif [[ "$EXTENSION" == "mp3" || "$EXTENSION" == "opus" || "$EXTENSION" == "webm" || "$EXTENSION" == "ogg" ]]; then
        # Use afconvert (built into macOS) to convert to AAC, then rename to m4b
        echo "==> Converting $EXTENSION to m4b using afconvert..."
        AAC_PATH="$WORKDIR/${BASENAME}.m4a"
        afconvert "$DOWNLOADED" "$AAC_PATH" -d aac -f m4af
        mv "$AAC_PATH" "$M4B_PATH"
    else
        # Try afconvert anyway — it supports many input formats
        echo "==> Attempting to convert $EXTENSION to m4b..."
        AAC_PATH="$WORKDIR/${BASENAME}.m4a"
        afconvert "$DOWNLOADED" "$AAC_PATH" -d aac -f m4af
        mv "$AAC_PATH" "$M4B_PATH"
    fi

    if [[ ! -f "$M4B_PATH" ]]; then
        echo "Error: Conversion failed."
        return 1
    fi
    
    echo "==> Importing into Apple Books..."
    open -a "Books" "$M4B_PATH"
    
    # Give Books a moment to import the file before the temp directory is cleaned up
    echo "==> Waiting for Books to import..."
    sleep 5
    
    echo ""
    echo "Done! Check Apple Books — your audiobook should appear under Library > Audiobooks."
    echo ""
    echo "To get it onto your iPhone, connect via cable (or Wi-Fi sync) and use"
    echo "Finder > [Your iPhone] > Audiobooks > Sync."
}
