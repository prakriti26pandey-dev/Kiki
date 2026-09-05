Production package — Episode 1 60s animatic (motion‑comic) — Ready‑to‑render

Files included in this package (committed to repo under drama/animatic/):
- voice_lines.ssml — SSML for TTS lines (already committed)
- voice_assignments.md — TTS voice mapping & lip‑sync instructions (already committed)
- 60s_subtitles_en.srt — English SRT (already committed)
- test_scene_slap_60s.md — final 60s animatic script and timing (already committed)
- preview_slap_15s.svg — 15s animated SVG preview (already committed in drama/assets/)
- rigs: drama/assets/*.svg — character SVG rigs (dhermesh_pandey.svg, ridhima_pandey.svg, mommy_pandey.svg, kritika_pandey.svg, anamika_pandey.svg, pandey_baby.svg) (already committed)
- mouth_shapes/ (new) — 3 SVG mouth shapes for quick lip‑sync mapping (mouth_A.svg = closed, mouth_B.svg = half, mouth_C.svg = open)
- render_command.sh (new) — FFmpeg command sequence and notes to assemble animatic from image sequences + audio
- README_PACKAGE.md (this file) — step‑by‑step render instructions, asset list, settings, and troubleshooting notes

How to render the 60s animatic locally (step‑by‑step)

Prereqs (suggested tools):
- A vector/raster editor that can export PNG sequences from layered SVGs (Inkscape, Adobe Illustrator, or a scriptable pipeline).
- Non‑linear editor (DaVinci Resolve, Premiere) OR a command‑line FFmpeg pipeline.
- TTS engine that supports SSML (e.g., Amazon Polly, Google Cloud Text‑to‑Speech, Microsoft Azure TTS). Use the SSML file voice_lines.ssml.
- FFmpeg (v4.2+)

1) Prepare character and background frames
- Use the SVG rigs in drama/assets/. For each scene shot (see test_scene_slap_60s.md timings), export a small sequence of PNG frames (24 fps).
- Recommended shot breakdown (from the shot list):
  • Shot 1 (00:00–00:05) exterior: 5s × 24fps = 120 frames
  • Shot 2 (00:06–00:12) two‑shot interior: 6s × 24fps = 144 frames
  • Shot 3 (00:13–00:20) Purnima close: 7s × 24fps = 168 frames
  • Shot 4 (00:21–00:30) Dhermesh close: 9s × 24fps = 216 frames
  • Shot 5 (00:31–00:38) reaction two‑shot: 7s × 24fps = 168 frames
  • Shot 6 (00:39–00:44) wind‑up / slap: 5s × 24fps = 120 frames (include slow‑motion keyframes near impact)
  • Shot 7 (00:45–00:47) impact freeze / flash: 2s × 24fps = 48 frames
  • Shot 8 (00:48–00:52) reaction montage: 4s × 24fps = 96 frames
  • Shot 9 (00:53–00:58) Dhermesh final close: 5s × 24fps = 120 frames
  • Shot 10 (00:59–01:00) Purnima final line / fade: 1s × 24fps = 24 frames
- Export naming convention: shot01_frame_0001.png ... shot09_frame_0120.png. Keep shots in separate folders.

2) Generate TTS audio files
- Use drama/animatic/voice_lines.ssml with your TTS engine. Output WAV or high‑quality MP3 files.
- Name them according to lines / timestamps, e.g.: purnima_line1.wav, dhermesh_line1.wav, dhermesh_shout.wav, mommy_line1.wav, purnima_final.wav
- Place TTS files in drama/animatic/audio/

3) Create lip‑sync asset mapping
- Use the mouth_shapes/ SVGs: mouth_A.svg (closed), mouth_B.svg (half open), mouth_C.svg (open).
- For each frame where the speaking character is visible, map mouth shapes by analyzing the TTS waveform: simple threshold mapping (silence -> A, low amplitude -> B, high amplitude -> C).
- For an animatic, 3‑shape mapping is sufficient. Export mouth overlays as PNGs and composite them onto character head positions in each frame.

4) Compose shots into a timeline
- Option A (NLE): import PNG sequences for each shot as separate clips, import audio tracks (TTS, SFX, music), align according to shot start times in test_scene_slap_60s.md. Use crossfades and simple easing for parallax movements.
- Option B (FFmpeg script): stitch PNG sequences into per‑shot MP4s, then concatenate. See render_command.sh for sample commands.

5) Add SFX and music
- Add room ambience (rain + quiet house hum). Add slap impact at 00:45 with a short reverb tail. After impact, reduce lowpass (heartbeat low‑pass) for 0.6s then restore.
- Music: choose a low strings pad (00:00–00:30), swell for 00:31–00:44, then silence/reverb at impact. I can provide a short royalty‑free cue if you want (send request).

6) Subtitles
- drama/animatic/60s_subtitles_en.srt is ready. Import into NLE or use FFmpeg to burn‑in or mux as external SRT.

7) Final render settings (recommended)
- MP4 master: H.264, 1920×1080, 24 fps, 8 Mbps, AAC 192 kbps, 48 kHz.
- WebM copy: VP9, 2‑4 Mbps, 48 kHz audio.
- GIF preview: 15s highlight at 720px width, 15 fps.

Troubleshooting
- If the mouth shapes look out of sync by 1–2 frames, nudge the audio or mouth keyframes by ±40ms.
- If freezing at impact looks abrupt, add a 0.15s white flash overlay and a 0.2s hold frame before continuing.

Credits & licensing
- All SVG assets in drama/assets/ are original stylized character portraits created for this project.
- Music / SFX must be licensed or royalty‑free. I will supply original royalty‑free cues on request.

Contact / follow‑ups
- When you finish a local render, upload the MP4 to a Drive folder and post the link here; I will review and provide one revision.

