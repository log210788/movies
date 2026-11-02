# 🍂 Master Blueprint & Instructions for Future AI Models and Student Folders

This document explains how to replicate the **Peaceful Interactive Transcript & Vocabulary Sanctuary** style (originally created for Marinela's Lesson 01) for any future Preply student folder.

---

## 🚀 Quick-Start: How to Use This for a New Student

### Option A: Copy the Starter Template Folder
1. Copy the [`template/`](./template/) folder contents (`GEMINI.md` and `index_template.html`) into your new student's folder (e.g., `D:\Documents\<StudentName>\`).
2. Place the raw lesson transcript inside `D:\Documents\<StudentName>\Transcript\lesson01.txt`.
3. Ask the AI model:
   > *"Read `GEMINI.md` and `Transcript/lesson01.txt`. Build `index.html` using `index_template.html` as the structural base, sorting out all note-taker spelling mistakes, flagging 45–60 vocabulary words inline with timestamps, and pushing to GitHub Pages."*

### Option B: Copy-Paste Prompt for Any Future AI Model
If starting an empty student folder with only `Transcript/lesson01.txt`, paste this prompt directly to the model:

```text
Please read the raw transcript in Transcript/lesson01.txt and build a single-file interactive GitHub Pages web app (index.html, plus .nojekyll and README.md) modeled after D:\Documents\Marinela B\index.html and D:\Documents\Marinela B\TEMPLATE_INSTRUCTIONS_FOR_AI.md.

Specifically, make sure you include:
1. FULL CLEANED TRANSCRIPT TAB (00:00 to end): Include every speaking turn organized into 5–6 chapters with exact timestamps, search bar, speaker filter, and per-turn audio button.
2. SORT OUT NOTE-TAKER / ASR SPELLING MISTAKES: Forensically fix all automated speech-to-text mishearings (proper nouns, place names, idioms, foreign words) and wrap each correction with the toggleable fixBadge("Actual Phrase", "Raw Note-Taker Error") pill.
3. INLINE VOCABULARY + STICKY SPOTLIGHT + TIPPY TOOLTIPS: Flag 45–60 B2–C2 vocabulary words, phrasal verbs, and idioms right where they appear in the transcript using v("key", "word"). Hovering shows a Tippy.js card; clicking updates a sticky right-hand Vocabulary Spotlight panel with IPA, CEFR level, timestamp, meaning, exact quote, the student's native-language equivalent, and UK/US speech synthesis.
4. VOCABULARY DICTIONARY TAB: Searchable/filterable grid of all flagged words where clicking the timestamp badge (🕒 MM:SS ↗) switches back to the Transcript tab, scrolls to that exact turn, and pulses the line with a golden glow.
5. NOTE-TAKER FIXES & GENTLE PHRASING TAB: Start by celebrating 6 natural expressions the student used well (to build confidence), followed by 6 gentle, encouraging grammar/phrasing polishes and a visual log of all note-taker spelling fixes.
6. CULTURAL PLACES / TOPICS TAB & PEACEFUL PRACTICE TAB: 4 editorial cards on the cultural/visual topics discussed, plus an interactive flashcard deck, a 6-question context quiz with confetti, and 3 reflection prompts for next lesson.
7. CALMING ATMOSPHERE: Include a soft 3-palette theme switcher, an adjustable HTML5 Canvas ambient particle animation (e.g., falling autumn leaves) with a toggle button, and a built-in Web Audio API ambient soundscape generator (breeze/rain/study) in the header.
```

---

## 🏛️ Core Architecture & Stylisation Standards (For AI Models)

When generating `index.html` for a student, follow these 7 design and engineering pillars strictly:

### 1. Tone & Student Psychology (Warm, Reassuring, Non-Intimidating)
- Many language learners feel shy or self-conscious seeing their spoken words in writing.
- **Never** use harsh red "Error / Mistake / Wrong" badges for the student's speech.
- Frame grammar upgrades as **"Gentle Phrasing Polishes"** (*"In the moment"* → *"Natural Polish"*), and always precede them with a **"Your Natural Strengths"** banner celebrating 6 idioms, phrasal verbs, or thoughtful ideas the student expressed well.
- Reserve "Mistake / Fix" labels strictly for the **AI Note-Taker's speech-to-text mishearings** (which students find funny and relieving!).

### 2. Forensic Transcript Cleaning & Note-Taker Fix Badges (`fixBadge`)
Automated note-takers frequently mishear place names, architects/authors, homophones, and non-English words (e.g. hearing *"Ibiza"* as *"a visa"*, *"Bath"* as *"a bar"*, *"bathes Bath"* as *"Babe's bath"*, *"Winchester"* as *"Leicester"*, *"Tadao Ando"* as *"Tano Ando"*, *"boon"* as *"boom"*, or *"like a never-ending"* as *"not a clever ending"*).
- **Rule 1**: Read the entire raw transcript in context before writing code so you spot every ASR hallucination.
- **Rule 2**: Smooth out fragmented backchannel splits (where a listener says *"Yeah"* mid-sentence) while keeping timestamps accurate.
- **Rule 3**: Use `fixBadge(actualSpokenText, rawNoteTakerText)` inline right next to the corrected phrase in the transcript AND list the top 10–15 fixes in Tab 3 (`ASR_FIXES` array).
- **Rule 4**: Provide a header toggle button (`toggleAsrBadges()`) that toggles `body.hide-asr-fixes` so the student can view or hide the fix pills anytime.

### 3. Inline Vocabulary Tagging (`v(key, displayWord)`) & Dual Inspection
Every flagged word (`45–60` items across `B2`, `C1`, `C2`, idioms, and phrasal verbs) lives in the central `VOCAB_DB` dictionary object:
```js
"vantage-point": {
  word: "vantage point",
  ipa: "/ˈvɑːn.tɪdʒ pɔɪnt/",
  pos: "noun",
  level: "C1",
  time: "06:54",
  turnId: "turn-20",
  cat: "architecture", // category key for filtering
  def: "A high or peaceful position that gives you a clear, wide view of everything below.",
  quote: "Louie (06:54): \"...you have a good vantage point where the city still belongs to you.\"",
  l1: "mirador privilegiado / perspectiva" // Student's native language connection
}
```
Inside `TRANSCRIPT_TURNS`, wrap occurrences with `${v("vantage-point", "vantage point")}`. This provides **three** connected ways to learn:
1. **Hovering** in the transcript opens a **Tippy.js** popover (`theme: 'autumn-sanctuary'`) with IPA, level, timestamp, definition, native-language equivalent, and a `🔊 Listen` button.
2. **Clicking** in the transcript updates the sticky right-hand **Vocabulary Spotlight** panel (`inspectVocab(key)`) with the full lesson quote and details.
3. **Clicking the timestamp (`🕒 06:54 ↗`) in Tab 2 (Vocabulary Dictionary)** calls `jumpToTranscriptTurn(turnId, vocabKey)`, which switches to Tab 1, scrolls smoothly to `#turn-20`, updates the Spotlight panel, and triggers a 2.8-second golden highlight pulse (`.turn-highlight-flash`).

### 4. Typography & Restful Colour System
- **Fonts**:
  - Headings & Literary Quotes: `'Cormorant Garamond'` (serif)
  - Transcript Body & UI Controls: `'Plus Jakarta Sans'` (clean, high-legibility sans-serif)
  - Timestamps, CEFR Badges & IPA Phonetics: `'JetBrains Mono'` (monospace)
- **CSS Variables with 3 Peaceful Moods (`data-theme`)**:
  - Default (`kensington` / Bath Stone): Warm parchment cream (`#f9f6f0`), soft sage (`#5b826f`), and autumn leaf amber (`#be6f38`).
  - Secondary (`winchester` / Mist): Soft dove-sage and Cotswold mist (`#f3f6f5`).
  - Evening (`twilight` / Warm Study): Cosy parchment-amber (`#f5efe6`) for low-eye-strain evening study.
- **Speaker Differentiation in Transcript**:
  - Student turns: Warm ivory card (`#fffdf9`) with a 4px left border in autumn amber (`border-l-autumn-500`).
  - Teacher (Louie) turns: Soft sage-tinted card (`#f8faf8`) with a 4px left border in sage green (`border-l-sage-600`).

### 5. Sensory & Calming Plugins (Zero Broken External Media)
- **Web Audio API Soundscape Generator**: Never rely on external `.mp3` URLs that might 404 or get blocked by CORS on GitHub Pages. Use the built-in procedural pink/brown noise + BiquadFilter + LFO wind-swell synthesizer (`toggleSoundscape()`) which creates soothing *Autumn Breeze*, *Soft Rain*, and *Warm Study Hearth* audio natively in any browser.
- **HTML5 Canvas Breeze / Particle Overlay**: Use `#autumn-breeze-canvas` (`pointer-events-none fixed inset-0 z-20`) with `cycleLeafBreeze()` in the top navbar so the student can switch between *Gentle*, *Breeze*, or *Still (Off)*.
- **Web Speech API Pronunciation**: Provide `0.85×` (slow) and `1.0×` (natural) speed buttons in the header, plus speaker buttons on every vocabulary item, phrase polish, flashcard, and transcript turn.

### 6. GitHub Pages Deployment Files
Always include at the repository root:
- `index.html` (self-contained single-file app using CDN links for Tailwind, Lucide, GSAP, Popper/Tippy.js, and Canvas-Confetti)
- `.nojekyll` (prevents GitHub Pages from ignoring files or running Jekyll build steps)
- `README.md` (clean summary of the lesson, tabs, and note-taker fixes)

---

## 🛡️ 7. Text Rendering & Format Integrity Safeguards (Preventing Blank Screens & Missing Text)

A recurring failure mode in AI-generated lesson portals is that **text is either not displayed at all (blank containers/tabs)** or **text formatting breaks into garbled mojibake or raw code**. This section documents the root causes and mandates strict engineering rules to guarantee 100% reliable text display in every future student folder.

### A. Root Causes of Text Rendering Failures
1. **Unquoted String Literals in DOM Lookups**:
   - *Example bug*: `document.getElementById(spk- + s.toLowerCase() + -btn)`
   - *Result*: JavaScript interprets `spk-` as an undefined identifier, immediately throwing an uncaught `ReferenceError: spk is not defined`. Script execution ceases, leaving `#transcript-turns-container` and `#vocab-cards-grid` completely empty.
2. **Nested Template Literal Collisions in Generator Scripts**:
   - When an AI writes a meta-script (in Node or PowerShell) that uses backtick template strings to generate HTML containing client-side backtick template strings:
   - *Result*: The outer script prematurely evaluates `${item.word}` as an empty string, or unescaped backticks terminate the string early, resulting in raw unquoted HTML inside `<script>`:
     `container.innerHTML = NATURAL_STRENGTHS.map(...) => <div class="sanctuary-subcard...>`
   - The browser encounters a fatal `SyntaxError: Unexpected token '<'`, crashing all tab interactions and rendering zero content.
3. **PowerShell 5.1 Codepage Mojibake (`ðŸ`, `â€¢`, `à¹„à¸—à¸¢`)**:
   - On Windows PowerShell 5.1, executing a `.ps1` script without a UTF-8 BOM causes PowerShell to parse string literals using the Windows-1252 (ANSI) codepage.
   - *Result*: UTF-8 multi-byte characters (emojis `🌿`, Thai text `วันปิยมหาราช`, smart quotes `“`, bullets `•`) get mangled into `ðŸŒ¿` and `â€¢`.
4. **Missing or Mismatched Keys in `VOCAB_DB`**:
   - If a turn calls `v("pyloric-sphincter")` but the key in `VOCAB_DB` is missing or spelled differently, calling `item.word` in Tippy or Spotlight throws `TypeError: Cannot read properties of undefined (reading 'word')`.
5. **DOM Initialization Halting on Unhandled Errors**:
   - If one component throws an error inside `DOMContentLoaded` before other components initialize, subsequent tabs (Flashcards, Quiz, Dictionary) never render.

---

### B. Mandatory Engineering Rules for All Future AI Models

#### Rule 1: Always Safely Quote String Concatenations
Every prefix, infix, and suffix in DOM lookups MUST be an explicit, quoted string literal:
```js
// ❌ WRONG (Crashes entire script with ReferenceError):
const btn = document.getElementById(spk- + s.toLowerCase() + -btn);
const btn = document.getElementById(cat- + c);
const btn = document.getElementById(lvl- + l);

// ✅ CORRECT:
const btn = document.getElementById('spk-' + s.toLowerCase() + '-btn');
const btn = document.getElementById('cat-' + c);
const btn = document.getElementById('lvl-' + l);
```

#### Rule 2: Defensive Vocabulary Lookup with Fallbacks
Never assume `VOCAB_DB[key]` exists without a safe fallback. Both `v()` and Tippy `content()` must handle missing keys gracefully:
```js
function v(key, displayWord) {
  const item = (typeof VOCAB_DB !== 'undefined' && VOCAB_DB[key]) ? VOCAB_DB[key] : null;
  const label = displayWord || (item ? item.word : key);
  return '<span class="vocab-mark" data-vkey="' + key + '" onclick="inspectVocab(\'' + key + '\')">' + label + '</span>';
}
```

#### Rule 3: Avoid Nested Template Literal Expansion in Build Scripts
When using PowerShell or Node to generate `index.html`, do NOT write meta-scripts with unescaped nested template literals. Either:
- Write the HTML file directly using clean string concatenation, or
- Read the template and data from clean UTF-8 source files, or
- Explicitly escape nested backticks (`\``) and variables (`\${...}`) so the generator does not strip or corrupt them.

#### Rule 4: Windows PowerShell 5.1 UTF-8 BOM Rule
When writing `.ps1` automation scripts on Windows:
- Always save the `.ps1` file with a **UTF-8 BOM** (`[System.Text.Encoding]::UTF8`) so PowerShell 5.1 parses non-ASCII characters (emojis, Thai, Arabic, IPA phonetics) correctly.
- Always write target web files (`index.html`, `README.md`) using UTF-8 without BOM: `[System.Text.UTF8Encoding]::new($false)`.
- Always place `<meta charset="UTF-8">` as the very first child of `<head>` in `index.html`.

#### Rule 5: Guard Third-Party Libraries Defensively
Never assume CDN libraries (`tippy`, `lucide`, `confetti`) loaded synchronously without checking:
```js
if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
if (typeof tippy === 'function') initTippyTooltips();
if (typeof confetti === 'function') confetti({ ... });
```

#### Rule 6: Wrap DOM Initialization in Try/Catch
Always wrap application startup in a `try...catch` block so a failure in one widget does not block the transcript or vocabulary tabs:
```js
window.addEventListener('DOMContentLoaded', () => {
  try {
    renderTranscript();
    renderVocabGrid();
    renderStrengths();
    renderPhrasing();
    renderAsrFixes();
    renderEditorialTopics();
    renderReflections();
    updateFlashcardUI();
    renderIdiomGym();
    renderQuiz();
    initLeafCanvas();
    inspectVocab(Object.keys(VOCAB_DB)[0]);
    if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
  } catch (err) {
    console.error('Initialization error caught safely:', err);
  }
});
```

#### Rule 7: Pre-Flight Automated Verification Script
Before concluding, the AI must run a validation script on the generated `index.html` to confirm:
1. No mojibake characters (`â€`, `ðŸ`).
2. No unquoted assignments (`=\s*<div`).
3. No unquoted ID prefixes (`[^'"`](?:spk-|cat-|lvl-)`).
4. 100% of `v("key")` calls in the transcript exist in `VOCAB_DB`.
5. All closing tags (`</html>`, `</body>`, `</script>`) are present and intact.

