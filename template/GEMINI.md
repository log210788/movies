---
trigger: always_on
description: Automatic rules and design system for building Peaceful Interactive Transcript & Vocabulary Sanctuary web apps for Preply students.
---

# Preply Student Lesson Sanctuary — AI Agent Build Rules

Whenever asked to process a student's lesson transcript (usually in `Transcript/*.txt`) and build their GitHub Pages site (`index.html`), always follow this exact architecture and stylisation standard:

## 1. Forensic Transcript Cleaning & Note-Taker Fixes
1. Read the entire raw transcript file from start to finish before generating `index.html`.
2. **Include the complete transcript (`00:00` to end)** in Tab 1—never truncate, summarize, or skip speaking turns. Divide the conversation into 4–6 logical thematic chapters (`chapterId`, `chapterTitle`).
3. **Fix all automated note-taker (ASR) spelling and hearing mistakes** in context (proper nouns, cities, architects/authors, idioms, homophones, and foreign words).
4. Mark every corrected note-taker mistake inline using `fixBadge("Actual Phrase Said", "Raw Note-Taker Error")` AND populate the `ASR_FIXES` array in Tab 3 so the student can see what the note-taker misheard vs. what was actually said.
5. Include the header toggle (`toggleAsrBadges()`) so the student can show or hide note-taker fix pills at any time.

## 2. Inline Timestamped Vocabulary & Dual Inspection (45–60 Items)
1. Identify 45–60 high-value words, phrasal verbs, collocations, and idioms (`B2`, `C1`, `C2`) across the transcript with their exact timestamps (`MM:SS`) and turn IDs (`turn-N`).
2. Store each item in `VOCAB_DB` with: `word`, `ipa`, `pos`, `level`, `time`, `turnId`, `cat`, `def`, `quote`, and `l1` (equivalent in the student's native language, e.g., Spanish, French, Turkish, Arabic, German, Japanese, etc.).
3. Wrap every flagged word inside `TRANSCRIPT_TURNS` using `${v("vocab-key", "spoken form")}` so that:
   - **Hovering** triggers an interactive **Tippy.js** tooltip (`theme: 'autumn-sanctuary'`) with IPA, CEFR badge, timestamp, meaning, L1 translation, and UK/US audio button.
   - **Clicking** updates the sticky right-hand **Vocabulary Spotlight** card (`inspectVocab(key)`).
   - **Clicking the timestamp (`🕒 MM:SS ↗`) in Tab 2 (Vocabulary Dictionary)** calls `jumpToTranscriptTurn(turnId, key)`, switching to Tab 1, scrolling smoothly to that speaking turn, and flashing a warm golden glow (`.turn-highlight-flash`).

## 3. Five-Tab Sanctuary Structure
Build `index.html` with these 5 tabs:
- **Tab 1: 📜 Lesson Transcript & Inline Vocab**: Search input, speaker filter (*Both / Student Only / Louie Only*), chapter quick-jump pills, *Vocab Highlights On/Off* toggle, *Note-Taker Fixes Visible/Hidden* toggle, per-turn TTS audio button, and the sticky **Vocabulary Spotlight** sidebar.
- **Tab 2: 📚 Vocabulary Dictionary**: Searchable and filterable by category and CEFR level (`B2`–`C2`), with timestamp jump links back to Tab 1.
- **Tab 3: ✨ Note-Taker Fixes & Gentle Notes**:
  - *Section A*: 6 cards celebrating expressions the student used naturally and accurately (always build confidence first!).
  - *Section B*: 6 supportive, non-intimidating **Gentle Phrasing Polishes** (*"In the moment"* vs *"Natural Polish"*) with audio and clear explanation.
  - *Section C*: Visual log of the automated note-taker's spelling/hearing mistakes (`ASR_FIXES`).
- **Tab 4: 🏛️ Cultural Places & Topics**: 4 rich editorial cards exploring the places, artworks, concepts, or prompts discussed during the lesson.
- **Tab 5: ☕ Peaceful Practice Sanctuary**: Interactive 12-card flip deck (`FLASHCARD_KEYS`), a 6-question no-pressure context quiz (`QUIZ_QUESTIONS`) with `canvas-confetti`, and 3 thoughtful conversation prompts for the next lesson.

## 4. Peaceful Atmosphere & Sensory Plugins
- Include the **HTML5 Canvas Falling Autumn Leaves / Ambient Breeze** overlay (`#autumn-breeze-canvas`) with a header toggle (*Gentle*, *Breeze*, *Still*).
- Include the **Web Audio API Ambient Soundscape Synthesizer** in the header (*Breeze*, *Soft Rain*, *Warm Study Hearth* + volume slider) using procedural pink/brown noise and biquad filters so audio never breaks on GitHub Pages.
- Include the **3-Mood Theme Switcher** (*Bath Stone*, *Winchester Mist*, *Warm Study*) and **Web Speech API Pronunciation** (`0.85×` and `1.0×`).
- Always create `.nojekyll` and `README.md` alongside `index.html` for GitHub Pages deployment.
