#!/usr/bin/env bash
# render_and_upload.sh
# Usage: ./render_and_upload.sh /path/to/shot/folder audio_master.wav rclone_remote:drive_folder
# Example: ./render_and_upload.sh ./shots audio_master.wav gdrive:Kiki/Animatics

set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 SHOTS_ROOT_DIR AUDIO_MASTER WAV RCLONE_REMOTE:PATH"
  echo "Example: $0 ./shots audio_master.wav gdrive:Kiki/Animatics"
  exit 1
fi

SHOTS_ROOT="$1"      # folder that contains shotXX.mp4 files or shot folders
AUDIO_MASTER="$2"    # combined audio track timed to the assembled video (wav/mp3)
RCLONE_DEST="$3"     # rclone remote destination (configured remote + path)

WORKDIR="./animatic_work"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# If shots are provided as subfolders with PNG sequences, user should convert them first.
# This script expects shotXX.mp4 files already present in SHOTS_ROOT.

echo "Collecting shot files from: $SHOTS_ROOT"
# Create shots.txt for ffmpeg concat
rm -f shots.txt
for f in $(ls -1 "$PWD/../$SHOTS_ROOT"/shot*.mp4 2>/dev/null || true); do
  echo "file '$f'" >> shots.txt
done

if [ ! -s shots.txt ]; then
  echo "No shotXX.mp4 files found in $SHOTS_ROOT. Please create per-shot MP4s first." >&2
  exit 2
fi

echo "Concatenating shots into assembled_video.mp4"
ffmpeg -f concat -safe 0 -i shots.txt -c copy assembled_video.mp4

# Mix audio (if provided). If user wants to mix in NLE, skip this step and import assembled_video.mp4 there.
if [ -f "../$AUDIO_MASTER" ]; then
  echo "Merging audio track $AUDIO_MASTER into video"
  ffmpeg -i assembled_video.mp4 -i "../$AUDIO_MASTER" -c:v copy -c:a aac -b:a 192k -shortest final_animatic.mp4
else
  echo "Audio master not found at ../$AUDIO_MASTER; copying assembled_video.mp4 to final_animatic.mp4 without audio merge"
  cp assembled_video.mp4 final_animatic.mp4
fi

# Make WebM copy
echo "Creating WebM copy"
ffmpeg -i final_animatic.mp4 -c:v libvpx-vp9 -b:v 3M -c:a libopus -b:a 128k final_animatic.webm

# Create a 15s GIF preview (first 15s)
echo "Creating GIF preview (15s)"
ffmpeg -t 15 -i final_animatic.mp4 -vf "fps=15,scale=720:-1:flags=lanczos" preview15.gif

# Ensure rclone remote is configured before attempting upload
if command -v rclone >/dev/null 2>&1; then
  echo "Uploading final files to rclone destination: $RCLONE_DEST"
  rclone copy final_animatic.mp4 "$RCLONE_DEST" --progress
  rclone copy final_animatic.webm "$RCLONE_DEST" --progress
  rclone copy preview15.gif "$RCLONE_DEST" --progress
  # Also upload subtitles if present in parent animatic folder
  if [ -f "../drama/animatic/60s_subtitles_en.srt" ]; then
    rclone copy ../drama/animatic/60s_subtitles_en.srt "$RCLONE_DEST" --progress
  fi
  echo "Upload complete. Please check your remote folder."
else
  echo "rclone not found. Skipping upload. Install and configure rclone to enable upload." >&2
  echo "Files are in: $WORKDIR (final_animatic.mp4, final_animatic.webm, preview15.gif)"
fi

echo "Done."
