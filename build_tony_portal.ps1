# build_tony_portal.ps1
# Compiles index.html for Tony B (Lesson 3 November 2026)
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Compiling Louie's English Sanctuary for Tony B..."

$dataPath = "d:\Documents\Tony b\lesson_data.js"
if (-not (Test-Path $dataPath)) {
    throw "Data file not found at $dataPath"
}
$dataContent = [System.IO.File]::ReadAllText($dataPath, [System.Text.Encoding]::UTF8)

# 1. HTML Header and Shell
$htmlHead = @'
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Louie's English Sanctuary | Tony B • 3 November 2026</title>

  <!-- Google Fonts: Cormorant Garamond, Plus Jakarta Sans, JetBrains Mono -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,400;1,600&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- Tailwind CSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            serif: ['"Cormorant Garamond"', 'Georgia', 'serif'],
            sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'],
            mono: ['"JetBrains Mono"', 'monospace'],
          },
          colors: {
            parchment: {
              50: '#fbf9f5',
              100: '#f6f1e7',
              200: '#ede3d1',
              300: '#dfd0b5',
              400: '#cbb38e',
              500: '#b6966b',
            },
            autumn: {
              50: '#fcf6f0',
              100: '#f7e9db',
              200: '#eed0b5',
              300: '#e2b086',
              400: '#d38c57',
              500: '#be6f38',
              600: '#a3582b',
              700: '#854524',
              800: '#6c3921',
            },
            sage: {
              50: '#f4f7f5',
              100: '#e4ece7',
              200: '#cadad1',
              300: '#a5bfb1',
              400: '#7b9f8d',
              500: '#5b826f',
              600: '#476858',
              700: '#3a5448',
              800: '#30443b',
            },
            slatewarm: {
              700: '#3d4441',
              800: '#2b312e',
              900: '#1e2321',
            }
          }
        }
      }
    }
  </script>

  <!-- Lucide Icons -->
  <script src="https://unpkg.com/lucide@latest"></script>

  <!-- GSAP -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>

  <!-- Popper & Tippy.js -->
  <script src="https://unpkg.com/@popperjs/core@2"></script>
  <script src="https://unpkg.com/tippy.js@6"></script>
  <link rel="stylesheet" href="https://unpkg.com/tippy.js@6/animations/shift-away.css" />

  <!-- Canvas Confetti -->
  <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js"></script>

  <style>
    :root {
      --bg-base: #f9f6f0;
      --bg-card: rgba(255, 253, 249, 0.94);
      --bg-subcard: rgba(255, 255, 255, 0.96);
      --border-soft: #e6decb;
      --border-accent: #d9c8b0;
      --text-main: #2b312e;
      --text-muted: #5c6660;
      --grad-1: rgba(238, 208, 181, 0.40);
      --grad-2: rgba(202, 218, 209, 0.45);
      --grad-3: rgba(246, 241, 231, 0.65);
    }

    body[data-theme="winchester"] {
      --bg-base: #f3f6f5;
      --bg-card: rgba(252, 254, 253, 0.94);
      --bg-subcard: rgba(255, 255, 255, 0.96);
      --border-soft: #d7e2dc;
      --border-accent: #b8ccc2;
      --text-main: #26312d;
      --text-muted: #52635c;
      --grad-1: rgba(202, 218, 209, 0.48);
      --grad-2: rgba(219, 228, 238, 0.45);
      --grad-3: rgba(244, 240, 230, 0.52);
    }

    body[data-theme="twilight"] {
      --bg-base: #f5efe6;
      --bg-card: rgba(253, 249, 242, 0.94);
      --bg-subcard: rgba(255, 255, 255, 0.97);
      --border-soft: #e2d7c5;
      --border-accent: #cbb38e;
      --text-main: #2b2520;
      --text-muted: #64564c;
      --grad-1: rgba(226, 176, 134, 0.38);
      --grad-2: rgba(203, 179, 142, 0.40);
      --grad-3: rgba(245, 239, 230, 0.68);
    }

    body {
      background-color: var(--bg-base);
      color: var(--text-main);
      transition: background-color 0.4s ease, color 0.4s ease;
    }

    .sanctuary-card {
      background: var(--bg-card);
      backdrop-filter: blur(12px);
      border: 1px solid var(--border-soft);
      box-shadow: 0 4px 20px -2px rgba(43, 49, 46, 0.05);
    }

    .sanctuary-subcard {
      background: var(--bg-subcard);
      border: 1px solid var(--border-soft);
      transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
    }
    .sanctuary-subcard:hover {
      border-color: var(--border-accent);
      box-shadow: 0 6px 16px -2px rgba(43, 49, 46, 0.06);
    }

    /* Custom Scrollbar */
    ::-webkit-scrollbar { width: 7px; height: 7px; }
    ::-webkit-scrollbar-track { background: var(--bg-base); }
    ::-webkit-scrollbar-thumb { background: #d3c7b3; border-radius: 999px; }
    ::-webkit-scrollbar-thumb:hover { background: #be6f38; }

    /* Interactive Vocabulary Chips */
    .vocab-mark {
      background-color: #eed0b5;
      color: #6c3921;
      padding: 1px 5px;
      border-radius: 6px;
      font-weight: 600;
      cursor: pointer;
      border-bottom: 2px solid #be6f38;
      transition: all 0.2s ease;
      display: inline-block;
      margin: 0 1px;
    }
    .vocab-mark:hover {
      background-color: #be6f38;
      color: #ffffff;
      transform: translateY(-1px);
      box-shadow: 0 2px 8px rgba(190, 111, 56, 0.3);
    }
    body.hide-vocab-highlights .vocab-mark {
      background-color: transparent !important;
      color: inherit !important;
      border-bottom: none !important;
      font-weight: inherit !important;
      padding: 0 !important;
    }

    /* ASR Fix Badge */
    .asr-fix-pill {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      font-size: 0.72rem;
      font-family: 'Plus Jakarta Sans', sans-serif;
      padding: 2px 7px;
      border-radius: 999px;
      background: #fdf2e9;
      color: #854524;
      border: 1px solid #eed0b5;
      margin-left: 4px;
      vertical-align: middle;
      font-weight: 500;
      transition: all 0.2s ease;
    }
    .asr-fix-pill:hover {
      background: #eed0b5;
      color: #6c3921;
    }
    body.hide-asr-fixes .asr-fix-pill {
      display: none !important;
    }

    /* Turn Highlight Flash */
    .turn-highlight-flash {
      animation: highlightPulse 2.8s ease-out forwards;
    }
    @keyframes highlightPulse {
      0% {
        box-shadow: 0 0 0 4px rgba(190, 111, 56, 0.65), 0 8px 24px rgba(190, 111, 56, 0.25);
        border-color: #be6f38;
      }
      100% {
        box-shadow: none;
        border-color: var(--border-soft);
      }
    }

    /* Custom Tippy Tooltip */
    .tippy-box[data-theme~='autumn-sanctuary'] {
      background-color: #ffffff;
      color: #2b312e;
      border: 1px solid #dfd0b5;
      border-radius: 1rem;
      box-shadow: 0 10px 25px -5px rgba(43, 49, 46, 0.12), 0 8px 10px -6px rgba(43, 49, 46, 0.08);
      padding: 0.35rem;
    }
    .tippy-box[data-theme~='autumn-sanctuary'] .tippy-arrow {
      color: #ffffff;
    }

    @media print {
      .no-print { display: none !important; }
      body { background: white !important; color: black !important; }
    }
  </style>
</head>
<body data-theme="kensington" class="min-h-screen flex flex-col font-sans selection:bg-autumn-200 selection:text-autumn-900 relative">

  <!-- Ambient Autumn Breeze Particle Canvas Overlay -->
  <canvas id="autumn-breeze-canvas" class="pointer-events-none fixed inset-0 z-20"></canvas>

  <!-- TOP SENSORY & MOOD NAVIGATION BAR -->
  <header class="sticky top-0 z-40 sanctuary-card border-b border-[#e6decb]/80 backdrop-blur-md px-4 sm:px-6 py-2.5 transition">
    <div class="max-w-7xl mx-auto flex flex-wrap items-center justify-between gap-3">
      
      <!-- Logo & Student Profile -->
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-autumn-500 to-sage-600 flex items-center justify-center text-white shadow-md shadow-autumn-600/20 font-serif font-bold text-lg">
          L
        </div>
        <div>
          <div class="flex items-center gap-2">
            <h1 class="font-serif font-bold text-base sm:text-lg tracking-tight text-slatewarm-900">
              Louie's English Sanctuary
            </h1>
            <span class="px-2 py-0.5 rounded-full bg-sage-100 text-sage-800 text-[10px] font-mono font-semibold">
              Valencia • Preply Studio
            </span>
          </div>
          <p class="text-xs text-stone-500">
            Student: <strong class="text-stone-800">Tony B</strong> • 3 November 2026 • 55-Min Deep Fluency &amp; Cinema Session
          </p>
        </div>
      </div>

      <!-- Controls: Themes, Ambient Sound, Voice Speed, Badges -->
      <div class="flex flex-wrap items-center gap-2 sm:gap-2.5 text-xs">
        
        <!-- Theme Mood Switcher -->
        <div class="flex items-center bg-white/80 rounded-xl p-1 border border-stone-200 shadow-sm">
          <button onclick="setThemeMood('kensington')" title="Kensington Stone (Bath Cream & Amber)" class="px-2.5 py-1 rounded-lg text-stone-700 hover:bg-parchment-100 font-medium transition">🍂 Kensington</button>
          <button onclick="setThemeMood('winchester')" title="Winchester Mist (Cotswold Dove Sage)" class="px-2.5 py-1 rounded-lg text-stone-700 hover:bg-sage-100 font-medium transition">🌿 Winchester</button>
          <button onclick="setThemeMood('twilight')" title="Twilight Study (Warm Evening Parchment)" class="px-2.5 py-1 rounded-lg text-stone-700 hover:bg-autumn-100 font-medium transition">🕯️ Twilight</button>
        </div>

        <!-- Ambient Soundscape Switcher -->
        <div class="flex items-center gap-1.5 bg-white/80 px-2.5 py-1 rounded-xl border border-stone-200 shadow-sm">
          <button onclick="toggleSoundscape()" id="btn-soundscape" class="flex items-center gap-1.5 text-stone-700 hover:text-autumn-700 transition" title="Toggle Calming Background Soundscape">
            <i data-lucide="headphones" class="w-3.5 h-3.5 text-autumn-600"></i>
            <span id="soundscape-label" class="font-mono text-[11px]">Breeze: Off</span>
          </button>
          <select id="soundscape-preset" onchange="changeSoundscapePreset(this.value)" class="bg-transparent text-[11px] font-medium text-stone-600 border-none outline-none cursor-pointer">
            <option value="breeze">Autumn Wind</option>
            <option value="rain">Soft Rain</option>
            <option value="study">Study Hearth</option>
          </select>
          <input type="range" id="soundscape-volume" min="0" max="0.5" step="0.02" value="0.22" oninput="updateSoundscapeVolume(this.value)" class="w-14 h-1 bg-parchment-200 accent-autumn-600 rounded-lg cursor-pointer" title="Soundscape Volume">
        </div>

        <!-- Canvas Leaves Breeze Control -->
        <button onclick="cycleLeafBreeze()" id="btn-leaf-cycle" class="flex items-center gap-1.5 px-2.5 py-1 rounded-xl bg-white/80 border border-stone-200 shadow-sm hover:bg-parchment-100 text-stone-700 transition">
          <i data-lucide="wind" class="w-3.5 h-3.5 text-sage-600"></i>
          <span id="leaves-label" class="text-[11px]">Leaves: Gentle</span>
        </button>

        <!-- Speech Synthesis Rate Toggle -->
        <div class="hidden md:flex items-center bg-white/80 rounded-xl p-1 border border-stone-200 shadow-sm">
          <button onclick="setVoiceRate(0.85)" id="rate-slow" class="px-2 py-0.5 rounded-lg text-[11px] text-stone-600 hover:bg-parchment-100 font-mono transition">0.85×</button>
          <button onclick="setVoiceRate(1.0)" id="rate-normal" class="px-2 py-0.5 rounded-lg text-[11px] bg-sage-100 text-sage-800 font-mono font-semibold transition">1.0× UK</button>
        </div>

        <!-- Note-Taker Fixes Toggle -->
        <button onclick="toggleAsrBadges()" id="btn-toggle-asr" class="px-2.5 py-1 rounded-xl bg-white/80 border border-stone-200 shadow-sm hover:bg-parchment-100 text-stone-700 transition flex items-center gap-1.5" title="Toggle AI Note-Taker Fix Pills">
          <i data-lucide="spell-check" class="w-3.5 h-3.5 text-autumn-600"></i>
          <span class="text-[11px]">Fixes: Visible</span>
        </button>

      </div>
    </div>
  </header>

  <!-- MAIN APP CONTAINER -->
  <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 flex-1 w-full space-y-6">

    <!-- HERO EDITORIAL BANNER -->
    <section class="sanctuary-card rounded-3xl p-6 sm:p-8 relative overflow-hidden">
      <div class="absolute -right-16 -bottom-16 w-64 h-64 bg-gradient-to-br from-autumn-200/40 via-parchment-200/30 to-sage-200/40 rounded-full blur-3xl pointer-events-none"></div>

      <div class="relative z-10 space-y-4 max-w-3xl">
        <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-parchment-100 border border-parchment-300 text-autumn-800 text-xs font-mono">
          <i data-lucide="sparkles" class="w-3.5 h-3.5 text-autumn-600"></i>
          <span>Valencia • Automotive Sector • Spoken Coherence &amp; Fluency</span>
        </div>

        <h2 class="font-serif text-3xl sm:text-4xl lg:text-5xl font-bold tracking-tight text-slatewarm-900 leading-tight">
          Cinema as a Digital Sanctuary &amp; Opening the Mental Translation Bottleneck
        </h2>

        <p class="text-sm sm:text-base text-stone-600 leading-relaxed font-sans">
          Welcome to your interactive study sanctuary, Tony! In this session, we explored how intermediate language learners experience a cognitive <strong class="text-slatewarm-900">bottleneck</strong> when translating from Spanish to English in their minds before speaking. We ran rapid-fire verbal drills (Heads Up: Culinary Descriptors, Emotional Nuance, and Abstract Concepts), uncovered why Spanish <em>"orgullo"</em> differs from English <em>"taking pride in your work"</em>, recalled poetic collective animal nouns (<em>"a murder of crows"</em>), celebrated modern cinema as an unplugged refuge from smartphone distractions, and made a pact to analyze the haunting sound design and cinematic restraint of Jonathan Glazer's <em>The Zone of Interest</em> for next Thursday.
        </p>

        <!-- Quick Lesson Stats Bar -->
        <div class="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-2">
          <div class="p-3 rounded-2xl bg-white/70 border border-stone-200/80 shadow-xs">
            <span class="block text-[11px] font-mono uppercase tracking-wider text-stone-500">Vocabulary Bank</span>
            <span class="font-serif text-xl sm:text-2xl font-bold text-slatewarm-900">52 Items</span>
            <span class="text-[10px] text-sage-700 block">CEFR B2–C2 + Spanish</span>
          </div>
          <div class="p-3 rounded-2xl bg-white/70 border border-stone-200/80 shadow-xs">
            <span class="block text-[11px] font-mono uppercase tracking-wider text-stone-500">Note-Taker Fixes</span>
            <span class="font-serif text-xl sm:text-2xl font-bold text-autumn-700">17 ASR Fixes</span>
            <span class="text-[10px] text-stone-500 block">Speech-to-text corrections</span>
          </div>
          <div class="p-3 rounded-2xl bg-white/70 border border-stone-200/80 shadow-xs">
            <span class="block text-[11px] font-mono uppercase tracking-wider text-stone-500">Natural Strengths</span>
            <span class="font-serif text-xl sm:text-2xl font-bold text-sage-800">6 Celebrated</span>
            <span class="text-[10px] text-stone-500 block">+ 6 Phrasing polishes</span>
          </div>
          <div class="p-3 rounded-2xl bg-white/70 border border-stone-200/80 shadow-xs">
            <span class="block text-[11px] font-mono uppercase tracking-wider text-stone-500">Practice Sanctuary</span>
            <span class="font-serif text-xl sm:text-2xl font-bold text-slatewarm-900">12 Cards • 6 Quiz</span>
            <span class="text-[10px] text-autumn-700 block">+ 5 Idiom Gym Matchers</span>
          </div>
        </div>

      </div>
    </section>

    <!-- TAB NAVIGATION BAR -->
    <nav class="flex flex-wrap items-center gap-1.5 p-1.5 sanctuary-card rounded-2xl shadow-xs no-print">
      <button onclick="switchTab('transcript')" id="tab-btn-transcript" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm">
        <i data-lucide="message-square-quote" class="w-4 h-4"></i>
        <span>1. Cleaned Transcript</span>
      </button>
      <button onclick="switchTab('vocab')" id="tab-btn-vocab" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
        <i data-lucide="book-open" class="w-4 h-4 text-autumn-600"></i>
        <span>2. Vocabulary Lexicon</span>
      </button>
      <button onclick="switchTab('fixes')" id="tab-btn-fixes" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
        <i data-lucide="sparkle" class="w-4 h-4 text-sage-600"></i>
        <span>3. Strengths &amp; Phrasing</span>
      </button>
      <button onclick="switchTab('places')" id="tab-btn-places" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
        <i data-lucide="clapperboard" class="w-4 h-4 text-autumn-600"></i>
        <span>4. Cinema &amp; Culture</span>
      </button>
      <button onclick="switchTab('practice')" id="tab-btn-practice" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
        <i data-lucide="target" class="w-4 h-4 text-sage-600"></i>
        <span>5. Practice Sanctuary</span>
      </button>
    </nav>
'@

# 2. Main HTML Content Body with Tabs
$htmlBody = @'
    <!-- =================================================================== -->
    <!-- TAB 1: FULL CLEANED TRANSCRIPT WITH STICKY SPOTLIGHT               -->
    <!-- =================================================================== -->
    <section id="tab-panel-transcript" class="tab-panel space-y-6">
      
      <!-- Top Transcript Controls: Search & Speaker Filter -->
      <div class="sanctuary-card rounded-2xl p-4 flex flex-wrap items-center justify-between gap-3 shadow-xs">
        <div class="relative flex-1 min-w-[240px]">
          <i data-lucide="search" class="w-4 h-4 text-stone-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
          <input type="text" id="transcript-search" oninput="renderTranscript()" placeholder="Search conversation turns, words, or timestamps (e.g., 'bottleneck', 'cinema', 'pride')..." class="w-full pl-10 pr-4 py-2 rounded-xl bg-white/90 border border-stone-200 text-xs sm:text-sm text-stone-800 placeholder-stone-400 focus:outline-none focus:border-autumn-500 transition">
        </div>

        <div class="flex items-center gap-2">
          <label for="speaker-filter" class="text-xs text-stone-500 font-mono">Speaker:</label>
          <select id="speaker-filter" onchange="renderTranscript()" class="px-3 py-2 rounded-xl bg-white/90 border border-stone-200 text-xs font-semibold text-stone-700 focus:outline-none focus:border-autumn-500 cursor-pointer">
            <option value="all">All Speakers (Louie &amp; Tony)</option>
            <option value="Tony">Tony Only (Student)</option>
            <option value="Louie">Louie Only (Tutor)</option>
          </select>

          <button onclick="toggleVocabHighlights()" id="btn-toggle-highlights" class="px-3 py-2 rounded-xl bg-parchment-100 border border-parchment-300 hover:bg-parchment-200 text-xs font-medium text-autumn-800 transition flex items-center gap-1.5">
            <i data-lucide="highlighter" class="w-3.5 h-3.5"></i>
            <span>Highlights: On</span>
          </button>
        </div>
      </div>

      <!-- Transcript & Sticky Spotlight Layout Grid -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        
        <!-- Left: Transcript Stream Container (Chapters 1 to 6) -->
        <div class="lg:col-span-8 space-y-4" id="transcript-stream-container">
          <!-- Populated dynamically via renderTranscript() -->
        </div>

        <!-- Right: Sticky Vocabulary Spotlight Panel -->
        <aside class="lg:col-span-4 sticky top-20 sanctuary-card rounded-3xl p-6 space-y-5 border-2 border-[#dfd0b5] shadow-md shadow-parchment-500/10 transition no-print">
          <div class="flex items-center justify-between border-b border-parchment-200 pb-3">
            <div class="flex items-center gap-2">
              <i data-lucide="sparkles" class="w-4 h-4 text-autumn-600"></i>
              <span class="text-xs font-mono uppercase tracking-wider font-semibold text-stone-600">Vocabulary Spotlight</span>
            </div>
            <span id="spotlight-level-badge" class="px-2.5 py-0.5 rounded-full text-[11px] font-mono font-bold bg-autumn-100 text-autumn-800">
              B2 Fluent
            </span>
          </div>

          <div class="space-y-1.5">
            <div class="flex items-baseline justify-between gap-2">
              <h3 id="spotlight-word" class="font-serif text-3xl font-bold text-slatewarm-900 tracking-tight">
                bottleneck
              </h3>
              <button onclick="speakSpotlightWord()" title="Listen to pronunciation (UK English)" class="p-2 rounded-xl bg-sage-100 text-sage-800 hover:bg-sage-200 transition">
                <i data-lucide="volume-2" class="w-4 h-4"></i>
              </button>
            </div>
            <p class="text-xs font-mono text-stone-500 flex items-center gap-2">
              <span id="spotlight-ipa">/ˈbɒt.əl.nek/</span> • <span id="spotlight-pos">noun</span>
            </p>
          </div>

          <div class="space-y-2 pt-1">
            <span class="text-[11px] font-mono uppercase tracking-wider text-autumn-700 font-semibold block">Definition</span>
            <p id="spotlight-def" class="text-xs sm:text-sm text-stone-700 leading-relaxed font-sans bg-parchment-50 p-3 rounded-2xl border border-parchment-200">
              A point of congestion or blockage that slows down an entire process or conversation flow.
            </p>
          </div>

          <div class="space-y-2 pt-1">
            <span class="text-[11px] font-mono uppercase tracking-wider text-sage-800 font-semibold block">Spoken Lesson Context</span>
            <blockquote id="spotlight-quote" class="text-xs sm:text-[13px] italic text-stone-700 leading-relaxed border-l-2 border-sage-500 pl-3">
              "Tony (14:30): 'I feel a lack of coherence... translating in my head creates a bottleneck.' Louie (01:06:22): 'We want to open that bottleneck and fill it with natural vocabulary.'"
            </blockquote>
          </div>

          <div class="pt-2 border-t border-parchment-200 flex items-center justify-between">
            <span class="text-xs font-mono text-stone-500">🇪🇸 Spanish connection:</span>
            <span id="spotlight-es" class="text-xs font-semibold text-autumn-800 bg-autumn-50 px-2.5 py-1 rounded-lg border border-autumn-200">
              el cuello de botella / atasco mental
            </span>
          </div>

          <div class="pt-1">
            <button id="spotlight-jump-btn" onclick="jumpToCurrentSpotlightTurn()" class="w-full py-2.5 rounded-xl bg-stone-900 hover:bg-stone-800 text-white text-xs font-semibold flex items-center justify-center gap-1.5 transition shadow-xs">
              <i data-lucide="corner-down-right" class="w-3.5 h-3.5"></i>
              <span>View Spoken Turn in Transcript</span>
            </button>
          </div>

          <div class="text-[11px] text-stone-400 text-center font-mono">
            Click any highlighted phrase in the transcript or dictionary to inspect.
          </div>
        </aside>

      </div>
    </section>

    <!-- =================================================================== -->
    <!-- TAB 2: VOCABULARY DICTIONARY                                       -->
    <!-- =================================================================== -->
    <section id="tab-panel-vocab" class="tab-panel hidden space-y-6">
      
      <!-- Search & Category Filters -->
      <div class="sanctuary-card rounded-2xl p-5 space-y-4">
        <div class="flex flex-wrap items-center justify-between gap-3">
          <div>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">Vocabulary &amp; Idiom Lexicon</h3>
            <p class="text-xs text-stone-500 mt-0.5">52 curated CEFR B2–C2 words, idioms, and natural expressions with Spanish translations and audio synthesis.</p>
          </div>
          <div class="relative w-full sm:w-72">
            <i data-lucide="search" class="w-4 h-4 text-stone-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
            <input type="text" id="vocab-search" oninput="renderVocabGrid()" placeholder="Filter dictionary..." class="w-full pl-10 pr-4 py-2 rounded-xl bg-white border border-stone-200 text-xs text-stone-800 focus:outline-none focus:border-autumn-500 transition">
          </div>
        </div>

        <!-- Filter Pills: Categories & CEFR Levels -->
        <div class="flex flex-wrap items-center gap-2 pt-1 border-t border-parchment-200">
          <span class="text-xs font-mono text-stone-400 mr-1">Category:</span>
          <button id="cat-all" onclick="filterVocabCategory('all')" class="cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-stone-800 text-white transition">All Topics (52)</button>
          <button id="cat-cinema-culture" onclick="filterVocabCategory('cinema-culture')" class="cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Cinema &amp; Culture</button>
          <button id="cat-psychology-emotions" onclick="filterVocabCategory('psychology-emotions')" class="cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Psychology &amp; Emotions</button>
          <button id="cat-language-fluency" onclick="filterVocabCategory('language-fluency')" class="cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Fluency &amp; Bottleneck</button>
          <button id="cat-abstract-philosophy" onclick="filterVocabCategory('abstract-philosophy')" class="cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Abstract Thought &amp; Pride</button>
          <button id="cat-culinary-lifestyle" onclick="filterVocabCategory('culinary-lifestyle')" class="cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Culinary &amp; Lifestyle</button>
          <button id="cat-idioms-expressions" onclick="filterVocabCategory('idioms-expressions')" class="cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Idioms &amp; Collective Nouns</button>

          <span class="text-xs font-mono text-stone-400 ml-auto mr-1">Level:</span>
          <button id="lvl-all" onclick="filterVocabLevel('all')" class="lvl-pill px-2.5 py-1 rounded-lg text-xs font-mono font-semibold bg-stone-200 text-stone-800">All</button>
          <button id="lvl-B2" onclick="filterVocabLevel('B2')" class="lvl-pill px-2.5 py-1 rounded-lg text-xs font-mono font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100">B2</button>
          <button id="lvl-C1" onclick="filterVocabLevel('C1')" class="lvl-pill px-2.5 py-1 rounded-lg text-xs font-mono font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100">C1</button>
          <button id="lvl-C2" onclick="filterVocabLevel('C2')" class="lvl-pill px-2.5 py-1 rounded-lg text-xs font-mono font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100">C2</button>
        </div>
      </div>

      <!-- Vocab Grid Container -->
      <div id="vocab-cards-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        <!-- Populated dynamically via renderVocabGrid() -->
      </div>
    </section>

    <!-- =================================================================== -->
    <!-- TAB 3: NOTE-TAKER FIXES & GENTLE PHRASING                          -->
    <!-- =================================================================== -->
    <section id="tab-panel-fixes" class="tab-panel hidden space-y-6">
      
      <!-- 1. Celebrating Natural Strengths (Confidence Builder) -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5 border-l-8 border-l-sage-600">
        <div class="flex items-center gap-2.5">
          <span class="p-2 rounded-xl bg-sage-100 text-sage-800">
            <i data-lucide="trophy" class="w-5 h-5"></i>
          </span>
          <div>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">Your Natural Strengths in Spoken English</h3>
            <p class="text-xs text-stone-500">6 high-level idioms, abstract insights, and precise explanations you used naturally during the session.</p>
          </div>
        </div>

        <div id="strengths-container" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 pt-2">
          <!-- Populated dynamically via renderStrengths() -->
        </div>
      </div>

      <!-- 2. Gentle Phrasing Polishes -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5 border-l-8 border-l-autumn-500">
        <div class="flex items-center gap-2.5">
          <span class="p-2 rounded-xl bg-autumn-100 text-autumn-800">
            <i data-lucide="feather" class="w-5 h-5"></i>
          </span>
          <div>
            <h3 class="font-serif text-2xl font-bold text-slatewarm-900">Gentle Phrasing Polishes</h3>
            <p class="text-xs text-stone-500">Encouraging upgrades to replace awkward literal translations with natural British cadence.</p>
          </div>
        </div>

        <div id="phrasing-container" class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
          <!-- Populated dynamically via renderPhrasing() -->
        </div>
      </div>

      <!-- 3. Automated Note-Taker Fixes Log -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="flex items-center justify-between border-b border-parchment-200 pb-3">
          <div class="flex items-center gap-2.5">
            <span class="p-2 rounded-xl bg-parchment-200 text-stone-800">
              <i data-lucide="mic-off" class="w-5 h-5 text-autumn-600"></i>
            </span>
            <div>
              <h3 class="font-serif text-2xl font-bold text-slatewarm-900">Speech-to-Text Mishearing Log</h3>
              <p class="text-xs text-stone-500">17 forensic speech-to-text corrections where automated software misheard proper nouns, film titles, and idioms.</p>
            </div>
          </div>
          <span class="text-xs font-mono font-bold text-autumn-700 bg-autumn-50 px-3 py-1 rounded-full border border-autumn-200">
            17 Fixes Cleaned
          </span>
        </div>

        <div id="asr-fixes-container" class="space-y-3 pt-2">
          <!-- Populated dynamically via renderAsrFixes() -->
        </div>
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 4: CULTURAL PLACES & TOPICS                                     -->
    <!-- =================================================================== -->
    <section id="tab-panel-places" class="tab-panel hidden space-y-6">
      
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-4">
        <div class="flex items-center gap-2.5">
          <span class="p-2 rounded-xl bg-autumn-100 text-autumn-800">
            <i data-lucide="film" class="w-5 h-5"></i>
          </span>
          <div>
            <h3 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900">Cultural &amp; Cinematic Perspectives</h3>
            <p class="text-xs sm:text-sm text-stone-500">Deep editorial explorations of the topics, linguistic concepts, and cinematic themes discussed in our lesson.</p>
          </div>
        </div>

        <div id="editorial-cards-container" class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-4">
          <!-- Populated dynamically via renderEditorialTopics() -->
        </div>
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 5: PEACEFUL PRACTICE SANCTUARY                                  -->
    <!-- =================================================================== -->
    <section id="tab-panel-practice" class="tab-panel hidden space-y-6">
      
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        
        <!-- Left Column: Interactive Active Recall Flashcards -->
        <div class="lg:col-span-6 sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
          <div class="flex items-center justify-between border-b border-parchment-200 pb-3">
            <div>
              <span class="text-xs font-mono uppercase tracking-widest text-sage-700 font-semibold">Active Recall</span>
              <h3 class="font-serif text-2xl font-bold text-slatewarm-900 mt-0.5">Vocabulary Flashcard Deck</h3>
            </div>
            <span id="fc-counter" class="text-xs font-mono font-bold text-stone-500 bg-parchment-100 px-3 py-1 rounded-full border border-parchment-300">Card 1 of 12</span>
          </div>

          <p class="text-xs text-stone-600">Click anywhere on the card to flip between the word and its definition, spoken quote, and Spanish translation.</p>

          <!-- The Flippable Card -->
          <div onclick="flipFlashcard()" class="cursor-pointer sanctuary-subcard rounded-3xl p-8 min-h-[260px] flex flex-col items-center justify-center text-center space-y-4 border-2 border-[#dfd0b5] hover:border-autumn-400 transition select-none shadow-sm group">
            <span id="fc-badge" class="px-3 py-1 rounded-full bg-autumn-100 text-autumn-800 text-xs font-mono font-semibold">
              B2 Fluent
            </span>
            <h4 id="fc-front-title" class="font-serif text-3xl sm:text-4xl font-bold text-slatewarm-900 group-hover:text-autumn-700 transition">
              bottleneck
            </h4>
            <p id="fc-ipa" class="text-xs font-mono text-stone-500">/ˈbɒt.əl.nek/</p>

            <div id="fc-back-details" class="hidden space-y-3 pt-3 border-t border-parchment-200 w-full animate-fadeIn">
              <p id="fc-def" class="text-xs sm:text-sm text-stone-700 leading-relaxed font-sans"></p>
              <p id="fc-quote" class="text-xs italic text-sage-800 bg-sage-50/70 p-2.5 rounded-xl border border-sage-200"></p>
              <p id="fc-es" class="text-xs font-semibold text-autumn-800"></p>
            </div>

            <p id="fc-prompt" class="text-[11px] text-stone-400 font-mono pt-1">Click to flip card ↺</p>
          </div>

          <!-- Flashcard Navigation Controls -->
          <div class="flex items-center justify-between gap-2 pt-1">
            <button onclick="prevFlashcard()" class="px-4 py-2.5 rounded-xl bg-parchment-100 hover:bg-parchment-200 text-xs font-semibold text-stone-700 flex items-center gap-1.5 transition">
              <i data-lucide="arrow-left" class="w-4 h-4"></i> Previous
            </button>
            <button onclick="speakCurrentFlashcard()" class="px-4 py-2.5 rounded-xl bg-sage-100 hover:bg-sage-200 text-xs font-semibold text-sage-800 flex items-center gap-1.5 transition">
              <i data-lucide="volume-2" class="w-4 h-4"></i> Listen UK
            </button>
            <button onclick="nextFlashcard()" class="px-4 py-2.5 rounded-xl bg-sage-700 hover:bg-sage-800 text-xs font-semibold text-white flex items-center gap-1.5 transition shadow-sm">
              Next <i data-lucide="arrow-right" class="w-4 h-4"></i>
            </button>
          </div>
        </div>

        <!-- Right Column: The Idiom Gym (Scenario Matcher) -->
        <div class="lg:col-span-6 sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
          <div class="flex items-center justify-between border-b border-parchment-200 pb-3">
            <div>
              <span class="text-xs font-mono uppercase tracking-widest text-autumn-700 font-semibold">Communicative Mastery</span>
              <h3 class="font-serif text-2xl font-bold text-slatewarm-900 mt-0.5">The Idiom Gym: Scenario Matcher</h3>
            </div>
            <span class="px-3 py-1 rounded-full bg-autumn-100 text-autumn-800 font-mono font-bold text-xs">5 Scenarios</span>
          </div>

          <p class="text-xs text-stone-600">Select the idiomatic phrase or strategy that best matches each conversational scenario:</p>

          <div id="idiom-gym-container" class="space-y-4 max-h-[500px] overflow-y-auto pr-1">
            <!-- Populated dynamically via renderIdiomGym() -->
          </div>
        </div>

      </div>

      <!-- The 6-Question Context Quiz -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="flex items-center justify-between border-b border-parchment-200 pb-3">
          <div>
            <span class="text-xs font-mono uppercase tracking-widest text-sage-700 font-semibold">Self-Assessment</span>
            <h3 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900 mt-0.5">Context &amp; Vocabulary Practice Quiz</h3>
          </div>
          <span id="quiz-score-badge" class="px-3.5 py-1 rounded-full bg-sage-100 text-sage-900 font-mono font-bold text-xs sm:text-sm border border-sage-300">
            Score: 0 / 6 Completed
          </span>
        </div>

        <p class="text-xs sm:text-sm text-stone-600">Test your retention of today's key linguistic concepts, cultural insights, and cinema discussions. Instant feedback and explanations are provided on every question!</p>

        <div id="quiz-container" class="space-y-4 pt-2">
          <!-- Populated dynamically via renderQuiz() -->
        </div>
      </div>

      <!-- Reflections for Thursday Session -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5 border-l-8 border-l-autumn-600">
        <div class="flex items-center gap-2.5">
          <span class="p-2 rounded-xl bg-autumn-100 text-autumn-800">
            <i data-lucide="compass" class="w-5 h-5"></i>
          </span>
          <div>
            <h3 class="font-serif text-2xl sm:text-3xl font-bold text-slatewarm-900">Reflections for Thursday's Session</h3>
            <p class="text-xs text-stone-500">Thoughtful prompts to prepare ahead of our upcoming class, focusing on 'The Zone of Interest' and direct English reflex.</p>
          </div>
        </div>

        <div id="reflections-container" class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
          <!-- Populated dynamically via renderReflections() -->
        </div>
      </div>

      <!-- Preply Summary Clipboard Exporter -->
      <div class="sanctuary-card rounded-3xl p-6 text-center space-y-3 bg-gradient-to-r from-parchment-100 via-white to-autumn-50 border border-parchment-300">
        <span class="px-3 py-1 rounded-full bg-sage-100 text-sage-800 text-[11px] font-mono font-semibold uppercase tracking-wider">
          Tutor &amp; Student Notes Sync
        </span>
        <h4 class="font-serif text-2xl font-bold text-slatewarm-900">Copy Preply Messenger Lesson Summary</h4>
        <p class="text-xs text-stone-600 max-w-xl mx-auto">
          Need a quick recap to paste into Preply chat or your personal study notes? Click the button below to copy a warm, structured summary of today's progress!
        </p>
        <div class="pt-1">
          <button onclick="copyPreplySummary()" id="btn-copy-preply" class="px-6 py-2.5 rounded-2xl bg-stone-900 hover:bg-stone-800 text-white text-xs font-semibold inline-flex items-center gap-2 transition shadow-sm">
            <i data-lucide="clipboard-copy" class="w-4 h-4"></i>
            <span>Copy Preply Lesson Summary to Clipboard</span>
          </button>
        </div>
      </div>

    </section>

  </main>

  <!-- FOOTER -->
  <footer class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 text-center text-xs text-stone-500 border-t border-[#e6decb]/80 mt-8 no-print space-y-2">
    <p class="font-serif italic text-base text-slatewarm-800">"Speak freely, reflect quietly, and let the language become second nature."</p>
    <p class="font-mono text-[11px] text-stone-400">Louie's English Sanctuary • Crafted for Tony B (Valencia, Spain) • 3 November 2026</p>
  </footer>
'@

# 3. Client-Side JavaScript Logic
$htmlScripts = @'
  <script>
    // =========================================================================
    // CLIENT-SIDE APPLICATION ENGINE (Safe Rendering, Isolated Boundaries)
    // =========================================================================

    // Rule 2: Defensive Vocabulary Lookup with Safe Fallbacks
    function v(key, displayWord) {
      const item = (typeof VOCAB_DB !== 'undefined' && VOCAB_DB[key]) ? VOCAB_DB[key] : null;
      const label = displayWord || (item ? item.word : key);
      return `<span class="vocab-mark" data-vkey="${key}" onclick="inspectVocab('${key}')">${label}</span>`;
    }

    function fixBadge(right, wrong) {
      return `<span class="asr-fix-pill" title="AI Note-taker misheard '${right}' as '${wrong}'">✨ Fixed: "${right}" <span class="text-stone-400 line-through">(${wrong})</span></span>`;
    }

    // 1. RENDER TRANSCRIPT (Tab 1)
    function renderTranscript() {
      const container = document.getElementById('transcript-stream-container');
      if (!container) return;

      const searchVal = (document.getElementById('transcript-search')?.value || '').toLowerCase().trim();
      const speakerFilter = document.getElementById('speaker-filter')?.value || 'all';

      let html = '';
      TRANSCRIPT_TURNS.forEach(turn => {
        if (turn.chapterTitle && speakerFilter === 'all' && !searchVal) {
          html += `
            <div id="${turn.chapterId}" class="pt-4 pb-1">
              <div class="px-4 py-2.5 rounded-2xl bg-gradient-to-r from-sage-100/90 via-parchment-100 to-autumn-50 border border-sage-200 flex items-center gap-2 text-xs sm:text-sm font-serif font-bold text-sage-900 shadow-xs">
                <i data-lucide="bookmark" class="w-4 h-4 text-autumn-600 shrink-0"></i>
                <span>${turn.chapterTitle}</span>
              </div>
            </div>
          `;
        }

        if (speakerFilter !== 'all' && turn.speaker !== speakerFilter) return;

        const plainText = turn.html.replace(/<[^>]+>/g, '').toLowerCase();
        if (searchVal && !plainText.includes(searchVal) && !turn.time.includes(searchVal)) return;

        const isTony = turn.speaker === 'Tony';
        const cardStyle = isTony
          ? 'bg-[#fffdf9] border-l-4 border-l-autumn-500 border border-[#e6decb]'
          : 'bg-[#f8faf8] border-l-4 border-l-sage-600 border border-[#d8e4dc]';
        const badgeStyle = isTony
          ? 'bg-autumn-100 text-autumn-800 border-autumn-200'
          : 'bg-sage-100 text-sage-800 border-sage-200';

        html += `
          <article id="${turn.id}" class="rounded-2xl p-4 sm:p-5 ${cardStyle} shadow-xs transition-all duration-300 space-y-2">
            <div class="flex items-center justify-between gap-2">
              <div class="flex items-center gap-2">
                <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold border ${badgeStyle}">
                  ${isTony ? '🎬 Tony (Student)' : '🍂 Louie (Tutor)'}
                </span>
                <span class="font-mono text-xs text-stone-500 flex items-center gap-1">
                  <i data-lucide="clock" class="w-3 h-3"></i>
                  ${turn.time}
                </span>
              </div>
              <button onclick="speakPlainTurn('${turn.id}')" class="text-stone-400 hover:text-sage-700 transition p-1 rounded-lg" title="Listen in British English">
                <i data-lucide="volume-2" class="w-3.5 h-3.5"></i>
              </button>
            </div>
            <div class="text-sm sm:text-[15px] text-slatewarm-800 leading-relaxed font-sans">
              ${turn.html}
            </div>
          </article>
        `;
      });

      if (!html) {
        html = `
          <div class="p-8 text-center text-stone-500 bg-white/60 rounded-2xl border border-stone-200">
            <i data-lucide="search-x" class="w-8 h-8 mx-auto text-stone-400 mb-2"></i>
            <p class="text-sm font-medium">No matching conversation turns found for "${searchVal}".</p>
          </div>
        `;
      }

      container.innerHTML = html;
      initTippyTooltips();
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
    }

    // 2. VOCABULARY SPOTLIGHT (Sticky Panel)
    let currentSpotlightKey = 'bottleneck';

    function inspectVocab(key) {
      const item = VOCAB_DB[key];
      if (!item) return;

      currentSpotlightKey = key;
      document.getElementById('spotlight-word').textContent = item.word;
      document.getElementById('spotlight-ipa').textContent = item.ipa;
      document.getElementById('spotlight-pos').textContent = item.pos;
      document.getElementById('spotlight-level-badge').textContent = `${item.level} Level`;
      document.getElementById('spotlight-def').textContent = item.def;
      document.getElementById('spotlight-quote').textContent = `"${item.quote}"`;
      document.getElementById('spotlight-es').textContent = item.es;

      const badge = document.getElementById('spotlight-level-badge');
      if (item.level === 'C2') badge.className = 'px-2.5 py-0.5 rounded-full text-[11px] font-mono font-bold bg-autumn-100 text-autumn-800';
      else if (item.level === 'C1') badge.className = 'px-2.5 py-0.5 rounded-full text-[11px] font-mono font-bold bg-sage-100 text-sage-800';
      else badge.className = 'px-2.5 py-0.5 rounded-full text-[11px] font-mono font-bold bg-parchment-200 text-stone-700';

      const jumpBtn = document.getElementById('spotlight-jump-btn');
      jumpBtn.onclick = () => jumpToTranscriptTurn(item.turnId, key);

      gsap.fromTo('#spotlight-word', { opacity: 0.4, y: -4 }, { opacity: 1, y: 0, duration: 0.25 });
    }

    function speakSpotlightWord() {
      const item = VOCAB_DB[currentSpotlightKey];
      if (item) speakWord(item.word);
    }

    function jumpToCurrentSpotlightTurn() {
      const item = VOCAB_DB[currentSpotlightKey];
      if (item) jumpToTranscriptTurn(item.turnId, currentSpotlightKey);
    }

    function jumpToTranscriptTurn(turnId, vocabKey) {
      switchTab('transcript');

      // Clear search to make sure turn is visible
      const sInput = document.getElementById('transcript-search');
      if (sInput && sInput.value) {
        sInput.value = '';
        renderTranscript();
      }

      setTimeout(() => {
        const el = document.getElementById(turnId);
        if (el) {
          el.scrollIntoView({ behavior: 'smooth', block: 'center' });
          el.classList.remove('turn-highlight-flash');
          void el.offsetWidth; // trigger reflow
          el.classList.add('turn-highlight-flash');
        }
        if (vocabKey) inspectVocab(vocabKey);
      }, 150);
    }

    // 3. VOCABULARY DICTIONARY (Tab 2)
    let activeVocabCat = 'all';
    let activeVocabLvl = 'all';

    function filterVocabCategory(cat) {
      activeVocabCat = cat;
      const cats = ['all', 'cinema-culture', 'psychology-emotions', 'language-fluency', 'abstract-philosophy', 'culinary-lifestyle', 'idioms-expressions'];
      cats.forEach(c => {
        const btn = document.getElementById('cat-' + c);
        if (!btn) return;
        if (c === cat) {
          btn.className = 'cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-stone-800 text-white transition';
        } else {
          btn.className = 'cat-pill px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition';
        }
      });
      renderVocabGrid();
    }

    function filterVocabLevel(lvl) {
      activeVocabLvl = lvl;
      ['all', 'B2', 'C1', 'C2'].forEach(l => {
        const btn = document.getElementById('lvl-' + l);
        if (!btn) return;
        if (l === lvl) {
          btn.className = 'lvl-pill px-2.5 py-1 rounded-lg text-xs font-mono font-semibold bg-stone-800 text-white';
        } else {
          btn.className = 'lvl-pill px-2.5 py-1 rounded-lg text-xs font-mono font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100';
        }
      });
      renderVocabGrid();
    }

    function renderVocabGrid() {
      const container = document.getElementById('vocab-cards-grid');
      if (!container) return;

      const search = (document.getElementById('vocab-search')?.value || '').toLowerCase().trim();

      const filtered = Object.keys(VOCAB_DB).filter(k => {
        const item = VOCAB_DB[k];
        if (activeVocabCat !== 'all' && item.cat !== activeVocabCat) return false;
        if (activeVocabLvl !== 'all' && item.level !== activeVocabLvl) return false;
        if (search) {
          const hay = `${item.word} ${item.def} ${item.es} ${item.quote}`.toLowerCase();
          if (!hay.includes(search)) return false;
        }
        return true;
      });

      container.innerHTML = filtered.map(k => {
        const item = VOCAB_DB[k];
        const lvlBadge = item.level === 'C2'
          ? 'bg-autumn-100 text-autumn-800 border-autumn-200'
          : item.level === 'C1'
            ? 'bg-sage-100 text-sage-800 border-sage-200'
            : 'bg-parchment-200 text-stone-700 border-parchment-300';

        return `
          <div class="sanctuary-subcard rounded-2xl p-4 sm:p-5 flex flex-col justify-between space-y-3 shadow-xs">
            <div class="space-y-2">
              <div class="flex items-center justify-between gap-2">
                <span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold border ${lvlBadge}">
                  ${item.level} • ${item.pos}
                </span>
                <button onclick="jumpToTranscriptTurn('${item.turnId}', '${k}')" class="text-xs font-mono text-autumn-700 hover:underline flex items-center gap-1 font-semibold" title="Jump to spoken turn in transcript">
                  <span>🕒 ${item.time}</span>
                  <i data-lucide="external-link" class="w-3 h-3"></i>
                </button>
              </div>

              <div class="flex items-baseline justify-between gap-2">
                <h4 class="font-serif text-xl font-bold text-slatewarm-900">${item.word}</h4>
                <button onclick="speakWord('${item.word}')" class="text-stone-400 hover:text-sage-700 transition p-1" title="Pronounce">
                  <i data-lucide="volume-2" class="w-3.5 h-3.5"></i>
                </button>
              </div>

              <p class="text-[11px] font-mono text-stone-400">${item.ipa}</p>
              <p class="text-xs text-stone-700 leading-relaxed font-sans">${item.def}</p>
            </div>

            <div class="pt-2 border-t border-parchment-200 space-y-1.5">
              <div class="flex items-center justify-between text-xs">
                <span class="text-stone-400 font-mono text-[10px]">🇪🇸 Español:</span>
                <span class="font-semibold text-autumn-800 text-[11px] bg-autumn-50 px-2 py-0.5 rounded-md border border-autumn-200/60">${item.es}</span>
              </div>
              <button onclick="inspectVocab('${k}')" class="w-full mt-1 py-1.5 rounded-xl bg-parchment-100 hover:bg-parchment-200 text-[11px] font-semibold text-stone-700 transition flex items-center justify-center gap-1">
                <span>View Full Spotlight</span>
              </button>
            </div>
          </div>
        `;
      }).join('');

      if (filtered.length === 0) {
        container.innerHTML = `
          <div class="col-span-full p-8 text-center text-stone-500 bg-white/60 rounded-2xl border border-stone-200">
            <p class="text-sm font-medium">No vocabulary items matched your selected filters.</p>
          </div>
        `;
      }

      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
    }

    // 4. NATURAL STRENGTHS, PHRASING & ASR FIXES (Tab 3)
    function renderStrengths() {
      const container = document.getElementById('strengths-container');
      if (!container) return;
      container.innerHTML = NATURAL_STRENGTHS.map(s => `
        <div class="sanctuary-subcard rounded-2xl p-4 sm:p-5 space-y-2.5">
          <div class="flex items-center justify-between text-xs">
            <span class="font-bold text-sage-900">${s.title}</span>
            <span class="font-mono text-stone-400">🕒 ${s.time}</span>
          </div>
          <p class="text-xs italic text-stone-700 bg-sage-50/70 p-2.5 rounded-xl border border-sage-200">
            "${s.quote}"
          </p>
          <p class="text-xs text-stone-600 leading-relaxed font-sans">
            ${s.analysis}
          </p>
        </div>
      `).join('');
    }

    function renderPhrasing() {
      const container = document.getElementById('phrasing-container');
      if (!container) return;
      container.innerHTML = PHRASING_POLISHES.map(p => `
        <div class="sanctuary-subcard rounded-2xl p-5 space-y-3 border-l-4 border-l-autumn-500">
          <div class="space-y-1">
            <span class="text-[10px] font-mono uppercase tracking-wider text-stone-400 font-semibold block">Spoken in the moment (🕒 ${p.time})</span>
            <p class="text-xs sm:text-sm text-stone-600 italic bg-parchment-50 p-2.5 rounded-xl border border-parchment-200">
              "${p.original}"
            </p>
          </div>
          <div class="space-y-1">
            <span class="text-[10px] font-mono uppercase tracking-wider text-autumn-700 font-semibold flex items-center gap-1">
              <i data-lucide="sparkles" class="w-3 h-3 text-autumn-600"></i>
              <span>Natural Native Polish</span>
            </span>
            <p class="text-xs sm:text-sm font-semibold text-slatewarm-900 bg-autumn-50/80 p-2.5 rounded-xl border border-autumn-200">
              "${p.polished}"
            </p>
          </div>
          <p class="text-xs text-stone-500 leading-relaxed pt-0.5">
            <strong>Why this works:</strong> ${p.analysis}
          </p>
        </div>
      `).join('');
    }

    function renderAsrFixes() {
      const container = document.getElementById('asr-fixes-container');
      if (!container) return;
      container.innerHTML = ASR_FIXES.map(f => `
        <div class="sanctuary-subcard rounded-2xl p-3.5 sm:p-4 flex flex-wrap items-center justify-between gap-3">
          <div class="space-y-1 flex-1 min-w-[240px]">
            <div class="flex items-center gap-2 text-xs">
              <span class="font-mono text-stone-400">🕒 ${f.time}</span>
              <span class="px-2 py-0.5 rounded-md bg-parchment-200 text-stone-700 font-medium text-[10px]">${f.speaker}</span>
            </div>
            <div class="text-xs sm:text-sm font-sans">
              <span class="text-stone-400 line-through mr-1">"${f.wrong}"</span>
              <span class="text-stone-400 font-mono">→</span>
              <span class="font-bold text-autumn-800 ml-1">"${f.right}"</span>
            </div>
            <p class="text-[11px] text-stone-500">${f.note}</p>
          </div>
          <button onclick="speakWord('${f.right}')" class="p-2 rounded-xl bg-parchment-100 hover:bg-parchment-200 text-stone-600 transition" title="Listen to corrected phrase">
            <i data-lucide="volume-2" class="w-4 h-4"></i>
          </button>
        </div>
      `).join('');
    }

    // 5. EDITORIAL TOPICS (Tab 4)
    function renderEditorialTopics() {
      const container = document.getElementById('editorial-cards-container');
      if (!container) return;
      container.innerHTML = EDITORIAL_TOPICS.map(t => `
        <article class="sanctuary-subcard rounded-3xl p-6 sm:p-7 space-y-4 flex flex-col justify-between shadow-xs">
          <div class="space-y-2.5">
            <div class="flex items-center justify-between text-xs font-mono">
              <span class="px-2.5 py-0.5 rounded-full bg-sage-100 text-sage-800 font-semibold">${t.badge}</span>
              <span class="text-stone-400">${t.time}</span>
            </div>
            <h4 class="font-serif text-2xl font-bold text-slatewarm-900 leading-snug">${t.title}</h4>
            <span class="text-xs font-mono text-autumn-700 font-medium block">${t.tag}</span>
            <p class="text-xs sm:text-sm text-stone-600 leading-relaxed font-sans">${t.desc}</p>
          </div>
          <div class="pt-3 border-t border-parchment-200 flex flex-wrap gap-1.5">
            ${t.keywords.map(kw => `
              <span class="px-2 py-0.5 rounded-md bg-parchment-100 text-stone-600 text-[11px] font-mono">#${kw}</span>
            `).join('')}
          </div>
        </article>
      `).join('');
    }

    // 6. FLASHCARDS (Tab 5)
    let currentCardIndex = 0;
    let isCardFlipped = false;

    function updateFlashcardUI() {
      const card = FLASHCARDS[currentCardIndex];
      if (!card) return;

      document.getElementById('fc-counter').textContent = `Card ${currentCardIndex + 1} of ${FLASHCARDS.length}`;
      document.getElementById('fc-badge').textContent = `${card.level} Level`;
      document.getElementById('fc-front-title').textContent = card.front;
      document.getElementById('fc-ipa').textContent = card.ipa;

      document.getElementById('fc-def').textContent = card.backDef;
      document.getElementById('fc-quote').textContent = `"${card.exampleQuote}"`;
      document.getElementById('fc-es').textContent = `🇪🇸 ${card.es}`;

      const backDetails = document.getElementById('fc-back-details');
      const prompt = document.getElementById('fc-prompt');

      if (isCardFlipped) {
        backDetails.classList.remove('hidden');
        prompt.textContent = 'Click to show front ↺';
      } else {
        backDetails.classList.add('hidden');
        prompt.textContent = 'Click to flip card ↺';
      }
    }

    function flipFlashcard() {
      isCardFlipped = !isCardFlipped;
      updateFlashcardUI();
    }

    function nextFlashcard() {
      currentCardIndex = (currentCardIndex + 1) % FLASHCARDS.length;
      isCardFlipped = false;
      updateFlashcardUI();
    }

    function prevFlashcard() {
      currentCardIndex = (currentCardIndex - 1 + FLASHCARDS.length) % FLASHCARDS.length;
      isCardFlipped = false;
      updateFlashcardUI();
    }

    function speakCurrentFlashcard() {
      const card = FLASHCARDS[currentCardIndex];
      if (card) speakWord(card.front);
    }

    // 7. THE IDIOM GYM (Tab 5)
    let idiomAnswered = new Set();

    function renderIdiomGym() {
      const container = document.getElementById('idiom-gym-container');
      if (!container) return;

      container.innerHTML = IDIOM_CHALLENGES.map((item, idx) => `
        <div class="sanctuary-subcard rounded-2xl p-4 sm:p-5 space-y-3">
          <div class="flex items-center justify-between text-xs font-mono">
            <span class="font-bold text-autumn-800">Challenge ${idx + 1}: ${item.title}</span>
            <span class="text-stone-500 bg-parchment-200/80 px-2 py-0.5 rounded-md">🇪🇸 ${item.es}</span>
          </div>
          <p class="text-xs sm:text-sm text-stone-700 leading-relaxed font-sans">${item.scenario}</p>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1">
            ${item.options.map((opt, oIdx) => `
              <button id="ibtn-${idx}-${oIdx}" onclick="answerIdiom(${idx}, ${oIdx})" class="px-3.5 py-2.5 rounded-xl border border-[#dfd0b5] bg-parchment-50/80 hover:bg-autumn-100/70 text-xs font-medium text-stone-700 text-left transition flex items-center gap-2">
                <span class="w-5 h-5 rounded-full bg-white border border-stone-300 flex items-center justify-center text-[10px] font-mono text-stone-500 shrink-0">${String.fromCharCode(65 + oIdx)}</span>
                <span>${opt}</span>
              </button>
            `).join('')}
          </div>
          <p id="iexp-${idx}" class="hidden text-xs text-sage-900 bg-sage-50 p-3 rounded-xl border border-sage-200 leading-relaxed"></p>
        </div>
      `).join('');
    }

    function answerIdiom(idx, oIdx) {
      const item = IDIOM_CHALLENGES[idx];
      const expEl = document.getElementById(`iexp-${idx}`);
      if (!expEl) return;

      item.options.forEach((_, optIdx) => {
        const btn = document.getElementById(`ibtn-${idx}-${optIdx}`);
        if (!btn) return;
        btn.disabled = true;
        if (optIdx === item.correctIndex) {
          btn.className = 'px-3.5 py-2.5 rounded-xl border-2 border-sage-500 bg-sage-100 text-sage-900 font-semibold text-xs text-left flex items-center gap-2';
        } else if (optIdx === oIdx) {
          btn.className = 'px-3.5 py-2.5 rounded-xl border-2 border-autumn-400 bg-autumn-50 text-autumn-900 text-xs text-left opacity-90 flex items-center gap-2';
        } else {
          btn.className = 'px-3.5 py-2.5 rounded-xl border border-stone-200 bg-stone-50/50 text-stone-400 text-xs text-left opacity-50 flex items-center gap-2';
        }
      });

      expEl.innerHTML = `<strong>${oIdx === item.correctIndex ? '✨ Spot on!' : '💡 Linguistic Context:'}</strong> ${item.explanation}`;
      expEl.classList.remove('hidden');

      if (oIdx === item.correctIndex && !idiomAnswered.has(idx)) {
        idiomAnswered.add(idx);
        if (idiomAnswered.size === IDIOM_CHALLENGES.length && typeof confetti === 'function') {
          confetti({ particleCount: 60, spread: 65, origin: { y: 0.7 }, colors: ['#be6f38', '#5b826f', '#e2b086'] });
        }
      }
    }

    // 8. THE 6-QUESTION CONTEXT QUIZ (Tab 5)
    let quizAnswered = new Set();

    function renderQuiz() {
      const container = document.getElementById('quiz-container');
      if (!container) return;

      container.innerHTML = QUIZ_QUESTIONS.map((q, qIdx) => `
        <div class="sanctuary-subcard rounded-2xl p-4 sm:p-5 space-y-3">
          <div class="flex items-start justify-between gap-2">
            <p class="text-xs sm:text-sm font-semibold text-slatewarm-900 leading-relaxed">${qIdx + 1}. ${q.question}</p>
            <span class="text-[10px] font-mono px-2 py-0.5 rounded-full bg-parchment-200 text-stone-700 shrink-0">🇪🇸 ${q.esHint}</span>
          </div>
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-2">
            ${q.options.map((opt, oIdx) => `
              <button id="qbtn-${qIdx}-${oIdx}" onclick="answerQuiz(${qIdx}, ${oIdx})" class="px-3.5 py-2.5 rounded-xl border border-[#dfd0b5] bg-parchment-50/80 hover:bg-autumn-100/70 text-xs font-medium text-stone-700 text-left transition flex items-center gap-2">
                <span class="w-5 h-5 rounded-full bg-white border border-stone-300 flex items-center justify-center text-[10px] font-mono text-stone-500 shrink-0">${String.fromCharCode(65 + oIdx)}</span>
                <span>${opt}</span>
              </button>
            `).join('')}
          </div>
          <p id="qexp-${qIdx}" class="hidden text-xs text-sage-900 bg-sage-50 p-3 rounded-xl border border-sage-200 leading-relaxed"></p>
        </div>
      `).join('');
    }

    function answerQuiz(qIdx, oIdx) {
      const q = QUIZ_QUESTIONS[qIdx];
      const expEl = document.getElementById(`qexp-${qIdx}`);
      if (!expEl) return;

      q.options.forEach((_, idx) => {
        const btn = document.getElementById(`qbtn-${qIdx}-${idx}`);
        if (!btn) return;
        btn.disabled = true;
        if (idx === q.correctIndex) {
          btn.className = 'px-3.5 py-2.5 rounded-xl border-2 border-sage-500 bg-sage-100 text-sage-900 font-semibold text-xs text-left flex items-center gap-2';
        } else if (idx === oIdx) {
          btn.className = 'px-3.5 py-2.5 rounded-xl border-2 border-autumn-400 bg-autumn-50 text-autumn-900 text-xs text-left opacity-90 flex items-center gap-2';
        } else {
          btn.className = 'px-3.5 py-2.5 rounded-xl border border-stone-200 bg-stone-50/50 text-stone-400 text-xs text-left opacity-50 flex items-center gap-2';
        }
      });

      expEl.innerHTML = `<strong>${oIdx === q.correctIndex ? '✨ Spot on!' : '💡 Take note:'}</strong> ${q.explanation}`;
      expEl.classList.remove('hidden');

      if (oIdx === q.correctIndex && !quizAnswered.has(qIdx)) {
        quizAnswered.add(qIdx);
        document.getElementById('quiz-score-badge').textContent = `Score: ${quizAnswered.size} / ${QUIZ_QUESTIONS.length} Completed`;
        if (quizAnswered.size === QUIZ_QUESTIONS.length && typeof confetti === 'function') {
          confetti({ particleCount: 70, spread: 70, origin: { y: 0.6 }, colors: ['#be6f38', '#5b826f', '#e2b086'] });
        }
      }
    }

    // 9. REFLECTIONS (Tab 5)
    function renderReflections() {
      const container = document.getElementById('reflections-container');
      if (!container) return;
      container.innerHTML = REFLECTION_PROMPTS.map(r => `
        <div class="sanctuary-subcard rounded-2xl p-5 space-y-3 flex flex-col justify-between">
          <div class="space-y-2">
            <span class="text-[10px] font-mono text-autumn-700 uppercase tracking-wider font-semibold block">${r.category}</span>
            <h4 class="font-serif text-lg font-bold text-slatewarm-900 leading-snug">${r.title}</h4>
            <p class="text-xs text-stone-600 leading-relaxed font-sans">${r.prompt}</p>
          </div>
          <div class="pt-2 border-t border-parchment-200">
            <p class="text-[11px] text-sage-800 bg-sage-50 p-2 rounded-xl border border-sage-200">
              <strong>Prep Advice:</strong> ${r.prepAdvice}
            </p>
          </div>
        </div>
      `).join('');
    }

    // 10. TAB SWITCHING
    function switchTab(tabName) {
      ['transcript', 'vocab', 'fixes', 'places', 'practice'].forEach(t => {
        const panel = document.getElementById(`tab-panel-${t}`);
        const btn = document.getElementById(`tab-btn-${t}`);
        if (!panel || !btn) return;
        if (t === tabName) {
          panel.classList.remove('hidden');
          btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm';
          gsap.fromTo(panel, { opacity: 0, y: 8 }, { opacity: 1, y: 0, duration: 0.25, ease: 'power2.out' });
        } else {
          panel.classList.add('hidden');
          btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100';
        }
      });
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // 11. TIPPY.JS INITIALIZATION
    function initTippyTooltips() {
      if (typeof tippy !== 'function') return;
      tippy('.vocab-mark', {
        theme: 'autumn-sanctuary',
        animation: 'shift-away',
        interactive: true,
        allowHTML: true,
        placement: 'top',
        content(reference) {
          const key = reference.getAttribute('data-vkey');
          const item = VOCAB_DB[key];
          if (!item) return `<div class="p-2 text-xs">${reference.textContent}</div>`;
          return `
            <div class="p-2 max-w-xs space-y-1.5 font-sans">
              <div class="flex items-center justify-between gap-2 border-b border-stone-200 pb-1">
                <span class="font-serif font-bold text-base text-slatewarm-900">${item.word}</span>
                <span class="text-[10px] font-mono px-1.5 py-0.5 rounded bg-autumn-100 text-autumn-800 font-bold">${item.level}</span>
              </div>
              <p class="text-[11px] font-mono text-stone-500">${item.ipa} • ${item.pos}</p>
              <p class="text-xs text-stone-700 leading-snug">${item.def}</p>
              <div class="text-[11px] font-semibold text-autumn-800 pt-1 border-t border-stone-100">
                🇪🇸 ${item.es}
              </div>
            </div>
          `;
        }
      });
    }

    // 12. SPEECH SYNTHESIS & TOGGLES
    let speechRate = 1.0;
    function setVoiceRate(rate) {
      speechRate = rate;
      const slow = document.getElementById('rate-slow');
      const norm = document.getElementById('rate-normal');
      if (rate === 0.85) {
        slow.className = 'px-2 py-0.5 rounded-lg text-[11px] bg-sage-100 text-sage-800 font-mono font-semibold transition';
        norm.className = 'px-2 py-0.5 rounded-lg text-[11px] text-stone-600 hover:bg-parchment-100 font-mono transition';
      } else {
        slow.className = 'px-2 py-0.5 rounded-lg text-[11px] text-stone-600 hover:bg-parchment-100 font-mono transition';
        norm.className = 'px-2 py-0.5 rounded-lg text-[11px] bg-sage-100 text-sage-800 font-mono font-semibold transition';
      }
    }

    function speakWord(text) {
      if (!('speechSynthesis' in window)) return;
      window.speechSynthesis.cancel();
      const utter = new SpeechSynthesisUtterance(text);
      utter.lang = 'en-GB';
      utter.rate = speechRate;
      window.speechSynthesis.speak(utter);
    }

    function speakPlainTurn(turnId) {
      const turn = TRANSCRIPT_TURNS.find(t => t.id === turnId);
      if (!turn) return;
      const temp = document.createElement('div');
      temp.innerHTML = turn.html;
      temp.querySelectorAll('.asr-fix-pill').forEach(el => el.remove());
      speakWord(temp.textContent || '');
    }

    let highlightsOn = true;
    function toggleVocabHighlights() {
      highlightsOn = !highlightsOn;
      document.body.classList.toggle('hide-vocab-highlights', !highlightsOn);
      document.getElementById('btn-toggle-highlights').querySelector('span').textContent = `Highlights: ${highlightsOn ? 'On' : 'Off'}`;
    }

    let asrBadgesOn = true;
    function toggleAsrBadges() {
      asrBadgesOn = !asrBadgesOn;
      document.body.classList.toggle('hide-asr-fixes', !asrBadgesOn);
      document.getElementById('btn-toggle-asr').querySelector('span').textContent = `Fixes: ${asrBadgesOn ? 'Visible' : 'Hidden'}`;
    }

    function setThemeMood(mood) {
      document.body.setAttribute('data-theme', mood);
    }

    // 13. AMBIENT WEB AUDIO API SOUNDSCAPE
    let audioCtx = null, soundscapePlaying = false, masterGain = null, currentFilter = null;
    function buildNoiseBuffer(ctx) {
      const bufferSize = ctx.sampleRate * 4;
      const buffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
      const output = buffer.getChannelData(0);
      let b0=0,b1=0,b2=0,b3=0,b4=0,b5=0,b6=0;
      for (let i = 0; i < bufferSize; i++) {
        const white = Math.random() * 2 - 1;
        b0 = 0.99886 * b0 + white * 0.0555179;
        b1 = 0.99332 * b1 + white * 0.0750759;
        b2 = 0.96900 * b2 + white * 0.1538520;
        b3 = 0.86650 * b3 + white * 0.3104856;
        b4 = 0.55000 * b4 + white * 0.5329522;
        b5 = -0.7616 * b5 - white * 0.0168980;
        output[i] = (b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362) * 0.04;
        b6 = white * 0.115926;
      }
      return buffer;
    }

    function toggleSoundscape() {
      const label = document.getElementById('soundscape-label');
      if (!soundscapePlaying) {
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        if (!audioCtx) audioCtx = new AudioContext();
        if (audioCtx.state === 'suspended') audioCtx.resume();
        const noiseSource = audioCtx.createBufferSource();
        noiseSource.buffer = buildNoiseBuffer(audioCtx);
        noiseSource.loop = true;
        currentFilter = audioCtx.createBiquadFilter();
        masterGain = audioCtx.createGain();
        masterGain.gain.value = parseFloat(document.getElementById('soundscape-volume').value || '0.22');
        noiseSource.connect(currentFilter);
        currentFilter.connect(masterGain);
        masterGain.connect(audioCtx.destination);
        noiseSource.start();
        audioCtx._activeSource = noiseSource;
        soundscapePlaying = true;
        changeSoundscapePreset(document.getElementById('soundscape-preset').value);
        label.textContent = 'Breeze: Playing';
      } else {
        if (audioCtx && audioCtx._activeSource) { try { audioCtx._activeSource.stop(); } catch (e) {} }
        soundscapePlaying = false;
        label.textContent = 'Breeze: Off';
      }
    }

    function changeSoundscapePreset(preset) {
      if (!currentFilter || !audioCtx) return;
      if (preset === 'breeze') {
        currentFilter.type = 'bandpass';
        currentFilter.frequency.value = 340;
      } else if (preset === 'rain') {
        currentFilter.type = 'lowpass';
        currentFilter.frequency.value = 880;
      } else {
        currentFilter.type = 'lowpass';
        currentFilter.frequency.value = 240;
      }
    }
    function updateSoundscapeVolume(val) {
      if (masterGain && audioCtx) masterGain.gain.value = parseFloat(val);
    }

    // 14. HTML5 CANVAS BREEZE ANIMATION
    const canvas = document.getElementById('autumn-breeze-canvas');
    const ctx = canvas ? canvas.getContext('2d') : null;
    let leaves = [], leafMode = 1, breezeTime = 0;
    const LEAF_COLORS = ['rgba(190,111,56,0.42)', 'rgba(211,140,87,0.40)', 'rgba(165,191,177,0.42)', 'rgba(203,179,142,0.45)'];
    function resizeCanvas() {
      if (!canvas) return;
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }
    window.addEventListener('resize', resizeCanvas);
    resizeCanvas();

    function rebuildLeaves() {
      if (!canvas) return;
      const count = leafMode === 1 ? 15 : leafMode === 2 ? 30 : 0;
      leaves = Array.from({ length: count }, () => ({
        x: Math.random() * canvas.width, y: Math.random() * canvas.height,
        size: 6 + Math.random() * 8, speedY: 0.35 + Math.random() * 0.55, speedX: 0.25 + Math.random() * 0.45,
        angle: Math.random() * Math.PI * 2, spin: (Math.random() - 0.5) * 0.014, swayOffset: Math.random() * 100,
        color: LEAF_COLORS[Math.floor(Math.random() * LEAF_COLORS.length)]
      }));
    }

    function cycleLeafBreeze() {
      leafMode = (leafMode + 1) % 3;
      document.getElementById('leaves-label').textContent = leafMode === 1 ? 'Leaves: Gentle' : leafMode === 2 ? 'Leaves: Breeze' : 'Leaves: Still';
      rebuildLeaves();
    }

    function animateLeaves() {
      if (!ctx || !canvas) return;
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      if (leafMode !== 0) {
        breezeTime += 0.01;
        leaves.forEach(l => {
          l.y += l.speedY; l.x += l.speedX + Math.sin(breezeTime + l.swayOffset) * 0.45; l.angle += l.spin;
          if (l.y > canvas.height + 20) { l.y = -20; l.x = Math.random() * canvas.width; }
          if (l.x > canvas.width + 20) l.x = -20;
          ctx.save(); ctx.translate(l.x, l.y); ctx.rotate(l.angle); ctx.fillStyle = l.color;
          ctx.beginPath(); ctx.ellipse(0, 0, l.size, l.size * 0.52, 0, 0, Math.PI * 2); ctx.fill(); ctx.restore();
        });
      }
      requestAnimationFrame(animateLeaves);
    }

    // 15. PREPLY SUMMARY COPY-TO-CLIPBOARD
    function copyPreplySummary() {
      const summaryText = `🍂 Preply Lesson Summary • Tony B (3 November 2026)\n\n` +
        `Hi Tony! Fantastic session today. Here is your study summary:\n\n` +
        `🎯 Core Focus: Eliminating the mental translation bottleneck & building spontaneous spoken coherence.\n\n` +
        `🌟 Natural Strengths Celebrated:\n` +
        `• Immediate conceptualization of abstract terms ("innocence", "forgiveness") in our 90-second Heads Up challenge.\n` +
        `• Spot-on distinction between Spanish "orgullo" and English "taking pride in your work".\n` +
        `• Instant recall of the classic English collective noun: "a murder of crows"!\n` +
        `• Thoughtful reflections on cinema as a phone-free digital sanctuary.\n\n` +
        `✨ Phrasing Polishes:\n` +
        `• "head home and completely unwind" (instead of Escoonnade)\n` +
        `• "unplug from my phone for two uninterrupted hours"\n` +
        `• "these are the kinds of activities I look forward to doing in my downtime"\n\n` +
        `🍿 Homework Pact for Thursday:\n` +
        `We are both rewatching Jonathan Glazer's "The Zone of Interest" (A24) to discuss its acoustic restraint, off-screen sound design, and moral weight.\n\n` +
        `🌐 Your Interactive Sanctuary Portal: https://log210788.github.io/movies/\n\n` +
        `See you next Thursday at the same time! Take care! — Louie`;

      navigator.clipboard.writeText(summaryText).then(() => {
        const btn = document.getElementById('btn-copy-preply');
        btn.innerHTML = `<i data-lucide="check" class="w-4 h-4 text-emerald-400"></i><span>Copied to Clipboard!</span>`;
        if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
        setTimeout(() => {
          btn.innerHTML = `<i data-lucide="clipboard-copy" class="w-4 h-4"></i><span>Copy Preply Lesson Summary to Clipboard</span>`;
          if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
        }, 2500);
      }).catch(err => {
        console.error('Failed to copy summary:', err);
      });
    }

    // 16. DEFENSIVE SAFE-RENDER INITIALIZATION (Rule 6)
    function safeRender(name, renderFn, containerId) {
      try {
        renderFn();
      } catch (err) {
        console.error(`Error rendering ${name}:`, err);
        const el = document.getElementById(containerId);
        if (el) {
          el.innerHTML = `
            <div class="p-6 bg-autumn-50 border border-autumn-200 rounded-2xl text-autumn-800 text-sm">
              <p class="font-bold mb-1">Notice: ${name} is updating...</p>
              <p class="text-xs text-autumn-600">${err.message}</p>
            </div>`;
        }
      }
    }

    window.addEventListener('DOMContentLoaded', () => {
      safeRender('Transcript', renderTranscript, 'transcript-stream-container');
      safeRender('Vocabulary Dictionary', renderVocabGrid, 'vocab-cards-grid');
      safeRender('Natural Strengths', renderStrengths, 'strengths-container');
      safeRender('Phrasing Polishes', renderPhrasing, 'phrasing-container');
      safeRender('ASR Fixes Log', renderAsrFixes, 'asr-fixes-container');
      safeRender('Editorial Topics', renderEditorialTopics, 'editorial-cards-container');
      safeRender('Flashcards', updateFlashcardUI, 'flashcard-deck');
      safeRender('The Idiom Gym', renderIdiomGym, 'idiom-gym-container');
      safeRender('Context Quiz', renderQuiz, 'quiz-container');
      safeRender('Reflections', renderReflections, 'reflections-container');

      try { inspectVocab('bottleneck'); } catch (e) { console.warn(e); }
      try { rebuildLeaves(); animateLeaves(); } catch (e) { console.warn(e); }
      try { if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons(); } catch (e) { console.warn(e); }
    });
  </script>
</body>
</html>
'@

# Assemble full self-contained single-file index.html
$fullHtml = $htmlHead + "`n" + $htmlBody + "`n<script>`n" + $dataContent + "`n</script>`n" + $htmlScripts

$outPath = "d:\Documents\Tony b\index.html"
[System.IO.File]::WriteAllText($outPath, $fullHtml, [System.Text.UTF8Encoding]::new($false))
Write-Host "SUCCESS: Fully assembled interactive sanctuary written to $outPath ($($fullHtml.Length) chars)"
