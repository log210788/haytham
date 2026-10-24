# PowerShell Portal Generator for Louie's English Studio & Medical Science Sanctuary
# Lesson: 24 October 2026
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Compiling Louie's English Sanctuary & Medical Science Studio for Lesson 10-24-2026..."

# Read curated data from lesson02_data.js
$dataPath = "d:\Documents\Worachon P\lesson02_data.js"
if (-not (Test-Path $dataPath)) {
    throw "Data file not found at $dataPath"
}

$raw = [System.IO.File]::ReadAllText($dataPath, [System.Text.Encoding]::UTF8)

# Extract core JS structures
function Extract-Block($varName) {
    if ($raw -match "const $varName = ([\s\S]*?\n\};|const $varName = ([\s\S]*?\n\];))") {
        # Find start of declaration
        $idx = $raw.IndexOf("const $varName =")
        if ($idx -lt 0) { throw "Cannot find $varName" }
        $after = $raw.Substring($idx)
        # Find closing delimiter
        if ($after -match "^const $varName = ([\s\S]*?\n(?:\};|\];))") {
            return $matches[1]
        }
    }
    throw "Failed to extract $varName"
}

$vocabDbBlock = Extract-Block "VOCAB_DB"
$asrFixesBlock = Extract-Block "ASR_FIXES"
$naturalStrengthsBlock = Extract-Block "NATURAL_STRENGTHS"
$phrasingPolishesBlock = Extract-Block "PHRASING_POLISHES"
$transcriptTurnsBlock = Extract-Block "TRANSCRIPT_TURNS"
$editorialTopicsBlock = Extract-Block "EDITORIAL_TOPICS"
$flashcardsBlock = Extract-Block "FLASHCARDS"
$idiomChallengesBlock = Extract-Block "IDIOM_CHALLENGES"
$quizQuestionsBlock = Extract-Block "QUIZ_QUESTIONS"
$reflectionPromptsBlock = Extract-Block "REFLECTION_PROMPTS"

Write-Host "All data blocks extracted successfully."

# Construct the Complete HTML Page
$htmlHeader = @'
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Louie's English Studio | Medical Science & Conversational Sanctuary</title>

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

  <!-- GSAP for Gentle Animations -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>

  <!-- Popper & Tippy.js for Interactive Vocabulary Explanations -->
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
      --grad-1: rgba(238, 208, 181, 0.42);
      --grad-2: rgba(202, 218, 209, 0.48);
      --grad-3: rgba(246, 241, 231, 0.70);
    }

    body[data-theme="winchester"] {
      --bg-base: #f3f6f5;
      --bg-card: rgba(252, 254, 253, 0.93);
      --bg-subcard: rgba(255, 255, 255, 0.97);
      --border-soft: #d7e2dc;
      --border-accent: #b8ccc2;
      --text-main: #26312d;
      --text-muted: #52635c;
      --grad-1: rgba(202, 218, 209, 0.50);
      --grad-2: rgba(219, 228, 238, 0.48);
      --grad-3: rgba(244, 240, 230, 0.55);
    }

    body[data-theme="twilight"] {
      --bg-base: #f5efe6;
      --bg-card: rgba(253, 249, 242, 0.94);
      --bg-subcard: rgba(255, 252, 247, 0.97);
      --border-soft: #e2d2be;
      --border-accent: #cfaea0;
      --text-main: #2d2622;
      --text-muted: #665850;
      --grad-1: rgba(226, 176, 134, 0.36);
      --grad-2: rgba(214, 196, 176, 0.42);
      --grad-3: rgba(235, 220, 202, 0.55);
    }

    body {
      background-color: var(--bg-base);
      background-image:
        radial-gradient(at 8% 5%, var(--grad-1) 0px, transparent 52%),
        radial-gradient(at 92% 18%, var(--grad-2) 0px, transparent 52%),
        radial-gradient(at 50% 88%, var(--grad-3) 0px, transparent 58%);
      background-attachment: fixed;
      color: var(--text-main);
      transition: background-color 0.4s ease, color 0.3s ease;
      overflow-x: hidden;
    }

    .sanctuary-card {
      background: var(--bg-card);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px);
      border: 1px solid var(--border-soft);
      box-shadow: 0 12px 36px -10px rgba(91, 130, 111, 0.08), 0 4px 14px -3px rgba(43, 49, 46, 0.04);
      transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .sanctuary-subcard {
      background: var(--bg-subcard);
      border: 1px solid var(--border-soft);
      box-shadow: 0 4px 14px -4px rgba(43, 49, 46, 0.04);
      transition: all 0.25s ease;
    }

    /* Vocabulary Inline Marks */
    .vocab-mark {
      background: linear-gradient(120deg, rgba(226, 176, 134, 0.30) 0%, rgba(190, 111, 56, 0.38) 100%);
      border-bottom: 2px solid #be6f38;
      border-radius: 4px;
      padding: 1px 5px;
      margin: 0 1px;
      font-weight: 600;
      cursor: pointer;
      color: #6c3921;
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      display: inline-block;
    }
    .vocab-mark:hover {
      background: linear-gradient(120deg, rgba(226, 176, 134, 0.55) 0%, rgba(190, 111, 56, 0.65) 100%);
      color: #2b312e;
      transform: translateY(-1px);
      box-shadow: 0 2px 6px rgba(190, 111, 56, 0.25);
    }
    .vocab-mark.active-vocab {
      background: #be6f38 !important;
      color: #ffffff !important;
      border-bottom-color: #6c3921 !important;
      box-shadow: 0 0 0 3px rgba(190, 111, 56, 0.35);
    }

    body.hide-vocab-highlights .vocab-mark {
      background: transparent !important;
      border-bottom: none !important;
      color: inherit !important;
      font-weight: inherit !important;
      padding: 0 !important;
      box-shadow: none !important;
    }

    /* Speech-to-Text Correction Badges */
    .asr-fix-pill {
      display: inline-flex;
      align-items: center;
      gap: 3px;
      font-size: 11px;
      font-family: 'JetBrains Mono', monospace;
      padding: 2px 8px;
      border-radius: 9999px;
      background-color: #e4ece7;
      border: 1px solid #cadad1;
      color: #30443b;
      margin: 0 3px;
      vertical-align: middle;
      cursor: help;
    }

    body.hide-asr-fixes .asr-fix-pill {
      display: none !important;
    }

    /* Flashcard 3D Perspective */
    .flashcard-inner {
      transform-style: preserve-3d;
      transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .flashcard-inner.flipped {
      transform: rotateY(180deg);
    }
    .flashcard-front, .flashcard-back {
      backface-visibility: hidden;
      -webkit-backface-visibility: hidden;
    }
    .flashcard-back {
      transform: rotateY(180deg);
    }

    /* Golden Pulse on Jump to Transcript */
    @keyframes gentleGlow {
      0% { background-color: rgba(226, 176, 134, 0.55); transform: scale(1.008); }
      50% { background-color: rgba(165, 191, 177, 0.42); }
      100% { background-color: transparent; transform: scale(1); }
    }
    .turn-highlight-flash {
      animation: gentleGlow 2.8s ease-out;
    }

    /* Custom Tippy Tooltip Theme */
    .tippy-box[data-theme~='autumn-sanctuary'] {
      background-color: #fffdf9;
      color: #2b312e;
      border: 1px solid #dfd0b5;
      border-radius: 1rem;
      box-shadow: 0 20px 38px -8px rgba(61, 68, 65, 0.16), 0 6px 16px -4px rgba(163, 88, 43, 0.08);
      padding: 0.35rem;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }
    .tippy-box[data-theme~='autumn-sanctuary'][data-placement^='top'] > .tippy-arrow::before {
      border-top-color: #dfd0b5;
    }
    .tippy-box[data-theme~='autumn-sanctuary'][data-placement^='bottom'] > .tippy-arrow::before {
      border-bottom-color: #dfd0b5;
    }

    @media print {
      .no-print, #autumn-breeze-canvas { display: none !important; }
      body { background: #fff !important; }
      .sanctuary-card, .sanctuary-subcard { box-shadow: none !important; border: 1px solid #ccc !important; }
    }
  </style>
</head>
<body data-theme="kensington" class="font-sans antialiased min-h-screen selection:bg-autumn-200 selection:text-slatewarm-900 relative">

  <!-- CALMING LONDON AUTUMN BREEZE CANVAS OVERLAY -->
  <canvas id="autumn-breeze-canvas" class="fixed inset-0 pointer-events-none z-20 opacity-80"></canvas>

  <!-- TOP MULTI-LESSON & PRE-LESSON ARCHIVE BAR -->
  <aside class="bg-gradient-to-r from-sage-800 via-sage-700 to-autumn-700 text-white text-xs py-2 px-4 shadow-sm relative z-50 flex items-center justify-between gap-3 flex-wrap">
    <div class="flex items-center gap-2 flex-wrap">
      <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-white/20 text-white font-mono text-[11px] font-bold">
        🌿 Lesson 02 • Latest
      </span>
      <span class="font-medium">Louie's English Studio: Friday Class (24 October 2026)</span>
    </div>
    <div class="flex items-center gap-2">
      <a href="./pre_lesson_pyramids.html" class="px-2.5 py-0.5 rounded-lg bg-amber-400/20 hover:bg-amber-400/30 text-amber-200 border border-amber-300/40 text-[11px] font-semibold transition flex items-center gap-1">
        <span>🏛️ Napoleon & Pyramids Guide</span>
        <i data-lucide="external-link" class="w-3 h-3"></i>
      </a>
      <a href="#how-it-works" class="underline font-semibold hover:text-parchment-100 transition text-[11px]">How It Works ↓</a>
    </div>
  </aside>

  <!-- STICKY PEACEFUL NAVIGATION & ATMOSPHERE BAR -->
  <header class="sticky top-0 z-40 border-b border-[#e6decb]/90 bg-[#fbf9f5]/85 backdrop-blur-md no-print">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-2.5 flex flex-wrap items-center justify-between gap-3">
      
      <!-- Brand Identity -->
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-sage-600 via-sage-500 to-autumn-500 flex items-center justify-center text-white font-serif text-xl font-bold shadow-sm">
          L
        </div>
        <div>
          <div class="flex items-center gap-2">
            <span class="font-serif font-bold text-lg sm:text-xl tracking-tight text-slatewarm-900">Louie's English Studio</span>
            <span class="hidden sm:inline-flex items-center gap-1 px-2.5 py-0.5 text-[11px] font-medium rounded-full bg-sage-100 text-sage-800 border border-sage-200">
              <i data-lucide="sparkles" class="w-3 h-3 text-autumn-600"></i>
              Medicine & Science Companion
            </span>
          </div>
          <p class="text-[11px] text-stone-500 hidden md:block">Full cleaned transcript, inline medical & C2 lexicon, gentle phrase polishes, and British audio</p>
        </div>
      </div>

      <!-- Calming Atmosphere Controls -->
      <div class="flex flex-wrap items-center gap-2">
        
        <!-- London Breeze Audio Player -->
        <div class="flex items-center gap-1.5 bg-white/90 border border-[#dfd0b5] rounded-xl px-2.5 py-1 shadow-sm">
          <button id="soundscape-btn" onclick="toggleSoundscape()" class="flex items-center gap-1.5 text-xs font-semibold text-sage-700 hover:text-sage-900 transition px-1.5 py-0.5 rounded-lg" title="Play soothing London autumn breeze soundscape">
            <i data-lucide="wind" id="soundscape-icon" class="w-3.5 h-3.5 text-autumn-600"></i>
            <span id="soundscape-label">London Breeze: Off</span>
          </button>
          <select id="soundscape-preset" onchange="changeSoundscapePreset(this.value)" class="text-[11px] bg-parchment-50 border border-parchment-200 rounded-lg px-1.5 py-0.5 text-stone-700 focus:outline-none">
            <option value="breeze">🍂 Kensington Breeze</option>
            <option value="rain">🌧️ Soft London Rain</option>
            <option value="study">🕯️ Warm Study Hearth</option>
          </select>
          <input id="soundscape-volume" type="range" min="0.05" max="0.6" step="0.05" value="0.22" oninput="updateSoundscapeVolume(this.value)" class="w-14 accent-sage-600 cursor-pointer hidden sm:block" />
        </div>

        <!-- Falling Leaves Toggle -->
        <button id="leaves-toggle-btn" onclick="cycleLeafBreeze()" class="px-2.5 py-1.5 rounded-xl bg-white/90 hover:bg-autumn-50 border border-[#dfd0b5] text-xs font-medium text-stone-700 flex items-center gap-1.5 shadow-sm transition">
          <i data-lucide="leaf" class="w-3.5 h-3.5 text-autumn-600"></i>
          <span id="leaves-label" class="hidden sm:inline">Leaves: Gentle</span>
        </button>

        <!-- UK Voice Speed -->
        <div class="flex items-center gap-1 bg-white/90 border border-[#dfd0b5] rounded-xl px-2 py-1 shadow-sm text-xs">
          <i data-lucide="volume-2" class="w-3.5 h-3.5 text-sage-600"></i>
          <button onclick="setVoiceRate(0.85)" id="rate-slow" class="px-1.5 py-0.5 rounded-md text-[11px] text-stone-600 hover:bg-parchment-100 transition">0.85×</button>
          <button onclick="setVoiceRate(1.0)" id="rate-normal" class="px-1.5 py-0.5 rounded-md text-[11px] bg-sage-600 text-white font-semibold transition">UK 1×</button>
        </div>

        <!-- Theme Mood Selector -->
        <div class="hidden lg:flex items-center gap-1 bg-white/90 border border-[#dfd0b5] rounded-xl p-1 text-[11px] shadow-sm">
          <button onclick="setThemeMood('kensington')" id="theme-kensington" class="px-2 py-0.5 rounded-lg bg-autumn-100 text-autumn-800 font-semibold transition">Bath Stone</button>
          <button onclick="setThemeMood('winchester')" id="theme-winchester" class="px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition">Winchester Mist</button>
          <button onclick="setThemeMood('twilight')" id="theme-twilight" class="px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition">Warm Study</button>
        </div>
      </div>

    </div>
  </header>

  <!-- MAIN CONTAINER -->
  <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-7 space-y-7 relative z-10">

    <!-- HERO / LESSON OVERVIEW -->
    <section class="sanctuary-card rounded-3xl p-6 sm:p-9 relative overflow-hidden">
      <div class="absolute -right-12 -top-12 w-64 h-64 bg-autumn-200/30 rounded-full blur-3xl pointer-events-none"></div>
      <div class="absolute -left-12 -bottom-12 w-64 h-64 bg-sage-200/35 rounded-full blur-3xl pointer-events-none"></div>

      <div class="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-7 items-center">
        <div class="lg:col-span-8 space-y-3.5">
          <div class="inline-flex flex-wrap items-center gap-2 px-3 py-1 rounded-full bg-sage-100/90 border border-sage-200 text-sage-800 text-xs font-medium">
            <i data-lucide="compass" class="w-3.5 h-3.5 text-autumn-600"></i>
            <span>Lesson 02 • 24 October 2026 • 1 Hour Full Session</span>
          </div>

          <h1 class="font-serif text-3xl sm:text-4xl lg:text-[2.65rem] font-bold text-slatewarm-900 leading-[1.16]">
            From King Chulalongkorn &amp; Richard Dawkins to the <span class="text-autumn-700 italic font-semibold">Brain's Pain Paradox</span>
          </h1>

          <p class="text-stone-600 text-sm sm:text-base leading-relaxed max-w-3xl">
            In today's lesson, we explored a rich tapestry of conversational and scientific frontiers: the cultural significance of <strong>วันปิยมหาราช (Chulalongkorn Day)</strong> and colonial pith helmets, Richard Dawkins' evolutionary memes and digital gatekeepers, the neurosurgical wonder of <strong>awake craniotomies</strong> and dura mater pain, gastric emptying kinetics, and total internal reflection in fiber optics.
          </p>

          <!-- 4 Pillars for the Student -->
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5 pt-2 text-xs">
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">Zero Note-Taking Friction:</strong> Every spoken turn is preserved, chronologically arranged into 6 chapters with per-turn audio.
              </div>
            </div>
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">55 Curated Lexicon Items:</strong> Hover or click any highlighted term for IPA, CEFR grade, Thai translations, and British audio.
              </div>
            </div>
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">Natural Strengths &amp; Upgrades:</strong> Celebrating 6 natural idiomatic moments followed by 6 gentle phrase polishes.
              </div>
            </div>
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">Note-Taker Fixes Log:</strong> All speech-to-text slips (e.g. <em>grass anatomy</em>, <em>pit hat</em>, <em>influencer</em>) cleaned up cleanly.
              </div>
            </div>
          </div>
        </div>

        <!-- Quick Lesson Stats Cards -->
        <div class="lg:col-span-4 grid grid-cols-2 gap-3">
          <div onclick="switchTab('transcript')" class="cursor-pointer p-4 rounded-2xl bg-parchment-50/95 border border-parchment-300 hover:border-autumn-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-autumn-700 flex items-center justify-between">
              <span>Section 1</span>
              <i data-lucide="scroll-text" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Full Transcript</div>
            <p class="text-[11px] text-stone-600 mt-0.5">6 chapters • 00:00 to 01:00:36</p>
          </div>

          <div onclick="switchTab('vocab')" class="cursor-pointer p-4 rounded-2xl bg-sage-50/95 border border-sage-200 hover:border-sage-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-sage-700 flex items-center justify-between">
              <span>Section 2</span>
              <i data-lucide="book-marked" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Flagged Lexicon</div>
            <p class="text-[11px] text-stone-600 mt-0.5">55 B2–C2 terms with Thai translations</p>
          </div>

          <div onclick="switchTab('fixes')" class="cursor-pointer p-4 rounded-2xl bg-autumn-50/95 border border-autumn-200 hover:border-autumn-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-autumn-700 flex items-center justify-between">
              <span>Section 3</span>
              <i data-lucide="wand-sparkles" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Strengths &amp; Fixes</div>
            <p class="text-[11px] text-stone-600 mt-0.5">Confidence boosters &amp; gentle polishes</p>
          </div>

          <div onclick="switchTab('practice')" class="cursor-pointer p-4 rounded-2xl bg-parchment-50/95 border border-parchment-300 hover:border-sage-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-sage-700 flex items-center justify-between">
              <span>Section 4</span>
              <i data-lucide="coffee" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Peaceful Review</div>
            <p class="text-[11px] text-stone-600 mt-0.5">Flashcards, Idiom Gym &amp; quiz</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 5-TAB NAVIGATION BAR -->
    <nav class="sanctuary-card rounded-2xl p-2 flex flex-wrap items-center justify-between gap-2 no-print">
      <div class="flex flex-wrap items-center gap-1.5 w-full sm:w-auto">
        <button onclick="switchTab('transcript')" id="tab-btn-transcript" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm">
          <i data-lucide="message-square-quote" class="w-4 h-4"></i>
          <span>1. Cleaned Transcript</span>
          <span class="px-2 py-0.5 text-[10px] rounded-full bg-white/20 text-white font-mono">00:00–01:00</span>
        </button>

        <button onclick="switchTab('vocab')" id="tab-btn-vocab" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="book-marked" class="w-4 h-4 text-autumn-600"></i>
          <span>2. Vocabulary Dictionary</span>
          <span id="vocab-total-badge" class="px-2 py-0.5 text-[10px] rounded-full bg-autumn-100 text-autumn-800 font-mono">55 Words</span>
        </button>

        <button onclick="switchTab('fixes')" id="tab-btn-fixes" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="sparkles" class="w-4 h-4 text-sage-600"></i>
          <span>3. Note-Taker Fixes &amp; Gentle Notes</span>
        </button>

        <button onclick="switchTab('editorials')" id="tab-btn-editorials" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="landmark" class="w-4 h-4 text-autumn-600"></i>
          <span>4. Science &amp; Culture Editorials</span>
        </button>

        <button onclick="switchTab('practice')" id="tab-btn-practice" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="coffee" class="w-4 h-4 text-sage-600"></i>
          <span>5. Peaceful Practice Sanctuary</span>
        </button>
      </div>

      <div class="hidden sm:block">
        <button onclick="copyPreplySummary()" class="px-3.5 py-2 rounded-xl bg-autumn-600 hover:bg-autumn-700 text-white font-semibold text-xs flex items-center gap-1.5 shadow-sm transition">
          <i data-lucide="clipboard-copy" class="w-3.5 h-3.5"></i>
          <span>Copy Preply Lesson Note</span>
        </button>
      </div>
    </nav>

    <!-- =================================================================== -->
    <!-- TAB 1: FULL CLEANED TRANSCRIPT & SPOTLIGHT                          -->
    <!-- =================================================================== -->
    <section id="tab-panel-transcript" class="tab-panel space-y-6">
      
      <div class="sanctuary-card rounded-3xl p-5 sm:p-6 space-y-4">
        <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 border-b border-[#e6decb] pb-4">
          <div>
            <div class="flex items-center gap-2">
              <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Interactive Lesson Transcript</h2>
              <span class="px-2.5 py-0.5 rounded-full text-xs font-mono font-semibold bg-sage-100 text-sage-800">
                Full 60-Minute Lesson
              </span>
            </div>
            <p class="text-xs text-stone-500 mt-1">
              Click any <span class="vocab-mark">highlighted phrase</span> to inspect in the Spotlight. Hover for instant British pronunciation &amp; Thai translations.
            </p>
          </div>

          <!-- Controls: Speaker filter, badge toggles -->
          <div class="flex flex-wrap items-center gap-2 text-xs">
            <!-- Speaker Filter Buttons -->
            <div class="flex items-center gap-1 bg-parchment-100 p-1 rounded-xl border border-parchment-300">
              <button id="spk-all-btn" onclick="filterSpeaker('all')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition">All</button>
              <button id="spk-louie-btn" onclick="filterSpeaker('Louie')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Louie</button>
              <button id="spk-worachon-btn" onclick="filterSpeaker('Worachon')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Student</button>
            </div>

            <!-- Fix Badges Toggle -->
            <button onclick="toggleAsrBadges()" class="px-3 py-1.5 rounded-xl bg-white border border-stone-200 hover:bg-parchment-100 text-stone-700 font-medium transition flex items-center gap-1.5">
              <i data-lucide="wand-2" class="w-3.5 h-3.5 text-sage-600"></i>
              <span id="asr-btn-text">Note-Taker Fixes: Visible</span>
            </button>

            <!-- Vocab Highlights Toggle -->
            <button onclick="toggleVocabHighlights()" class="px-3 py-1.5 rounded-xl bg-white border border-stone-200 hover:bg-parchment-100 text-stone-700 font-medium transition flex items-center gap-1.5">
              <i data-lucide="highlighter" class="w-3.5 h-3.5 text-autumn-600"></i>
              <span id="vocab-btn-text">Vocab Highlights: On</span>
            </button>
          </div>
        </div>

        <!-- Search Bar -->
        <div class="relative">
          <i data-lucide="search" class="w-4 h-4 absolute left-3.5 top-1/2 -translate-y-1/2 text-stone-400"></i>
          <input id="transcript-search" oninput="filterTranscript()" type="text" placeholder="Search spoken conversation, keywords, or medical concepts..." class="w-full pl-10 pr-10 py-2.5 rounded-xl bg-parchment-50 border border-parchment-300 text-xs sm:text-sm text-slatewarm-900 focus:outline-none focus:border-autumn-500 transition" />
          <button id="clear-search-btn" onclick="clearTranscriptSearch()" class="hidden absolute right-3 top-1/2 -translate-y-1/2 text-stone-400 hover:text-stone-600">
            <i data-lucide="x" class="w-4 h-4"></i>
          </button>
        </div>

        <!-- Transcript Two-Column Grid: Turns on left, Spotlight on right -->
        <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 pt-2">
          
          <!-- Turns Scroll Area (8 cols) -->
          <div id="transcript-turns-container" class="lg:col-span-8 space-y-4">
            <!-- Populated via renderTranscript() -->
          </div>

          <!-- Sticky Vocabulary Spotlight Panel (4 cols) -->
          <aside class="lg:col-span-4">
            <div class="sticky top-20 sanctuary-card rounded-3xl p-5 sm:p-6 space-y-4 border-t-4 border-t-autumn-500">
              <div class="flex items-center justify-between border-b border-[#e6decb] pb-3">
                <div class="flex items-center gap-2">
                  <i data-lucide="sparkle" class="w-4 h-4 text-autumn-600"></i>
                  <span class="font-serif font-bold text-lg text-slatewarm-900">Vocabulary Spotlight</span>
                </div>
                <span id="spotlight-badge" class="px-2 py-0.5 rounded text-[11px] font-mono font-bold bg-autumn-100 text-autumn-800">
                  Select a Word
                </span>
              </div>

              <!-- Spotlight Content Area -->
              <div id="spotlight-body" class="space-y-4">
                <div class="text-center py-8 text-stone-400 space-y-2">
                  <i data-lucide="book-open" class="w-8 h-8 mx-auto text-stone-300"></i>
                  <p class="text-xs">Click any highlighted word in the transcript to inspect definitions, Thai translations, and spoken quotes.</p>
                </div>
              </div>
            </div>
          </aside>

        </div>
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 2: VOCABULARY DICTIONARY (55 Items)                             -->
    <!-- =================================================================== -->
    <section id="tab-panel-vocab" class="tab-panel hidden space-y-6">
      
      <div class="sanctuary-card rounded-3xl p-5 sm:p-6 space-y-5">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-[#e6decb] pb-4">
          <div>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Vocabulary &amp; Scientific Lexicon</h2>
            <p class="text-xs text-stone-500 mt-0.5">55 B2–C2 terms, idioms, medical concepts &amp; physics principles curated from the lesson</p>
          </div>

          <!-- Level Badges Filter -->
          <div class="flex items-center gap-1.5 flex-wrap">
            <span class="text-xs font-semibold text-stone-500 mr-1">Level:</span>
            <button id="lvl-all" onclick="filterVocabLevel('all')" class="px-2.5 py-1 rounded-lg bg-autumn-600 text-white font-bold transition text-xs">All</button>
            <button id="lvl-B2" onclick="filterVocabLevel('B2')" class="px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs">B2</button>
            <button id="lvl-C1" onclick="filterVocabLevel('C1')" class="px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs">C1</button>
            <button id="lvl-C2" onclick="filterVocabLevel('C2')" class="px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs">C2</button>
          </div>
        </div>

        <!-- Category Buttons & Search Filter -->
        <div class="grid grid-cols-1 md:grid-cols-12 gap-3">
          <div class="md:col-span-8 flex flex-wrap items-center gap-1.5">
            <button id="cat-all" onclick="filterVocabCategory('all')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition">All Categories</button>
            <button id="cat-idioms" onclick="filterVocabCategory('idioms')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Idioms &amp; Sayings</button>
            <button id="cat-medical" onclick="filterVocabCategory('medical')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Medical &amp; Neuroscience</button>
            <button id="cat-science" onclick="filterVocabCategory('science')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Optics &amp; Biology</button>
            <button id="cat-lifestyle" onclick="filterVocabCategory('lifestyle')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Lifestyle &amp; Philosophy</button>
          </div>

          <div class="md:col-span-4 relative">
            <i data-lucide="search" class="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-stone-400"></i>
            <input id="vocab-search" oninput="renderVocabGrid()" type="text" placeholder="Filter by English or Thai..." class="w-full pl-9 pr-3 py-2 rounded-xl bg-parchment-50 border border-parchment-300 text-xs text-slatewarm-900 focus:outline-none focus:border-autumn-500 transition" />
          </div>
        </div>

        <!-- 3-Column Vocabulary Grid -->
        <div id="vocab-cards-grid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 pt-2">
          <!-- Populated via renderVocabGrid() -->
        </div>

      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 3: NOTE-TAKER FIXES & GENTLE PHRASING                           -->
    <!-- =================================================================== -->
    <section id="tab-panel-fixes" class="tab-panel hidden space-y-6">
      
      <!-- Confidence First: Natural Strengths -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-7 space-y-4">
        <div class="flex items-center gap-2.5 border-b border-[#e6decb] pb-3">
          <div class="w-8 h-8 rounded-xl bg-sage-100 text-sage-800 flex items-center justify-center font-bold">
            <i data-lucide="award" class="w-4 h-4 text-sage-700"></i>
          </div>
          <div>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Your Natural Strengths (Confidence First)</h2>
            <p class="text-xs text-stone-500">6 high-level idioms, phrasal verbs, and ideas you used with natural confidence today</p>
          </div>
        </div>

        <div id="strengths-container" class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
          <!-- Populated via renderStrengths() -->
        </div>
      </div>

      <!-- Encouraging Upgrades: Gentle Phrasing Polishes -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-7 space-y-4">
        <div class="flex items-center gap-2.5 border-b border-[#e6decb] pb-3">
          <div class="w-8 h-8 rounded-xl bg-autumn-100 text-autumn-800 flex items-center justify-center font-bold">
            <i data-lucide="sparkles" class="w-4 h-4 text-autumn-700"></i>
          </div>
          <div>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Gentle Phrasing Polishes</h2>
            <p class="text-xs text-stone-500">Encouraging language upgrades showing how native English speakers polish spoken thoughts</p>
          </div>
        </div>

        <div id="phrasing-container" class="space-y-3.5 pt-2">
          <!-- Populated via renderPhrasing() -->
        </div>
      </div>

      <!-- Speech-to-Text Correction Log -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-7 space-y-4">
        <div class="flex items-center justify-between border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2.5">
            <div class="w-8 h-8 rounded-xl bg-parchment-200 text-stone-700 flex items-center justify-center font-bold">
              <i data-lucide="wand-2" class="w-4 h-4 text-autumn-600"></i>
            </div>
            <div>
              <h2 class="font-serif text-2xl font-bold text-slatewarm-900">AI Note-Taker Mishearing Log</h2>
              <p class="text-xs text-stone-500">Speech-to-text algorithms often mishear medical terms and proper nouns—here is what was sorted out</p>
            </div>
          </div>
        </div>

        <div class="overflow-x-auto pt-2">
          <table class="w-full text-left text-xs">
            <thead>
              <tr class="border-b border-parchment-300 text-stone-500 font-mono text-[11px] uppercase">
                <th class="py-2 px-3">Time</th>
                <th class="py-2 px-3">Note-Taker Misheard</th>
                <th class="py-2 px-3">Actual Spoken Phrase</th>
                <th class="py-2 px-3">Context / Meaning</th>
              </tr>
            </thead>
            <tbody id="asr-fixes-tbody" class="divide-y divide-stone-100">
              <!-- Populated via renderAsrFixes() -->
            </tbody>
          </table>
        </div>
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 4: SCIENCE, CULTURE & EDITORIAL TOPICS                          -->
    <!-- =================================================================== -->
    <section id="tab-panel-editorials" class="tab-panel hidden space-y-6">
      
      <div class="sanctuary-card rounded-3xl p-6 sm:p-7 space-y-4">
        <div class="border-b border-[#e6decb] pb-3">
          <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Cultural &amp; Scientific Inquiries</h2>
          <p class="text-xs text-stone-500 mt-0.5">Four deep editorial explorations connecting today's dialogue to science, medicine &amp; sociology</p>
        </div>

        <div id="editorial-grid" class="grid grid-cols-1 md:grid-cols-2 gap-6 pt-2">
          <!-- Populated via renderEditorialTopics() -->
        </div>
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 5: PEACEFUL PRACTICE SANCTUARY & IDIOM GYM                      -->
    <!-- =================================================================== -->
    <section id="tab-panel-practice" class="tab-panel hidden space-y-6">
      
      <!-- Interactive Flippable Flashcards -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-[#e6decb] pb-3">
          <div>
            <div class="flex items-center gap-2">
              <span class="font-serif font-bold text-2xl text-slatewarm-900">Interactive Flashcard Deck</span>
              <span id="flashcard-counter" class="px-2.5 py-0.5 rounded-full text-xs font-mono font-bold bg-autumn-100 text-autumn-800">1 / 12</span>
            </div>
            <p class="text-xs text-stone-500 mt-0.5">Click the card to flip and view the Thai translation, usage context &amp; cultural origin</p>
          </div>

          <div class="flex items-center gap-2">
            <button onclick="prevFlashcard()" class="p-2 rounded-xl bg-white border border-stone-200 hover:bg-parchment-100 transition shadow-xs" title="Previous Card">
              <i data-lucide="chevron-left" class="w-4 h-4 text-stone-700"></i>
            </button>
            <button onclick="nextFlashcard()" class="p-2 rounded-xl bg-white border border-stone-200 hover:bg-parchment-100 transition shadow-xs" title="Next Card">
              <i data-lucide="chevron-right" class="w-4 h-4 text-stone-700"></i>
            </button>
          </div>
        </div>

        <!-- 3D Flippable Flashcard Card Container -->
        <div class="w-full max-w-xl mx-auto h-72 [perspective:1000px] cursor-pointer" onclick="flipFlashcard()">
          <div id="flashcard-card-inner" class="flashcard-inner relative w-full h-full shadow-lg rounded-3xl border border-parchment-300">
            
            <!-- Card Front -->
            <div class="flashcard-front absolute inset-0 rounded-3xl p-7 flex flex-col justify-between bg-gradient-to-br from-white via-parchment-50 to-parchment-100 text-slatewarm-900">
              <div class="flex items-center justify-between text-xs">
                <span id="fc-type-front" class="px-2.5 py-0.5 rounded-full font-mono text-[10px] font-bold bg-autumn-100 text-autumn-800">Spoken Idiom</span>
                <span class="text-stone-400 text-xs flex items-center gap-1">
                  <i data-lucide="rotate-cw" class="w-3.5 h-3.5"></i>
                  <span>Click to flip</span>
                </span>
              </div>
              <div class="text-center space-y-2">
                <h3 id="fc-front-word" class="font-serif font-bold text-2xl sm:text-3xl text-slatewarm-900"></h3>
                <div id="fc-front-ipa" class="font-mono text-xs text-stone-500"></div>
                <p id="fc-front-example" class="font-serif italic text-xs sm:text-sm text-stone-700 max-w-md mx-auto pt-2"></p>
              </div>
              <div class="flex items-center justify-between text-xs text-stone-400 font-mono">
                <span>🔊 Listen</span>
                <span>Flip for Thai ↓</span>
              </div>
            </div>

            <!-- Card Back -->
            <div class="flashcard-back absolute inset-0 rounded-3xl p-7 flex flex-col justify-between bg-gradient-to-br from-sage-800 via-sage-900 to-slatewarm-900 text-white">
              <div class="flex items-center justify-between text-xs">
                <span id="fc-type-back" class="px-2.5 py-0.5 rounded-full font-mono text-[10px] font-bold bg-white/20 text-white">Thai Translation</span>
                <span class="text-stone-300 text-xs flex items-center gap-1">
                  <i data-lucide="rotate-cw" class="w-3.5 h-3.5"></i>
                  <span>Click to return</span>
                </span>
              </div>
              <div class="text-center space-y-3">
                <div class="text-xs text-autumn-300 font-mono font-bold tracking-wider uppercase">Thai Translation (ความหมาย):</div>
                <h3 id="fc-back-th" class="font-sans font-bold text-xl sm:text-2xl text-white"></h3>
                <p id="fc-back-origin" class="text-xs text-parchment-200 leading-relaxed max-w-md mx-auto pt-1 font-sans"></p>
              </div>
              <div class="text-center text-[11px] text-stone-400 font-mono">
                Louie's English Studio Practice
              </div>
            </div>

          </div>
        </div>

        <div class="text-center">
          <button onclick="speakCurrentFlashcard()" class="px-4 py-2 rounded-xl bg-parchment-100 hover:bg-parchment-200 border border-parchment-300 text-slatewarm-900 font-semibold text-xs inline-flex items-center gap-2 transition">
            <i data-lucide="volume-2" class="w-4 h-4 text-autumn-600"></i>
            <span>Listen to Pronunciation</span>
          </button>
        </div>
      </div>

      <!-- The Idiom Gym: Scenario Matcher -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2">
            <i data-lucide="dumbbell" class="w-5 h-5 text-autumn-600"></i>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">The Idiom Gym: Scenario Matcher</h2>
          </div>
          <p class="text-xs text-stone-500 mt-0.5">Select the idiomatic phrase that best matches each real-world conversational challenge</p>
        </div>

        <div id="idiom-gym-container" class="space-y-4 pt-2">
          <!-- Populated via renderIdiomGym() -->
        </div>
      </div>

      <!-- 6-Question Context Quiz -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="flex items-center justify-between border-b border-[#e6decb] pb-3">
          <div>
            <div class="flex items-center gap-2">
              <i data-lucide="check-square" class="w-5 h-5 text-sage-600"></i>
              <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Context &amp; Science Quiz</h2>
            </div>
            <p class="text-xs text-stone-500 mt-0.5">Test your recall of medical physiology, Dawkins' memes, and English expressions</p>
          </div>
          <div id="quiz-score-badge" class="px-3 py-1 rounded-full bg-sage-100 text-sage-800 font-mono font-bold text-xs">
            Score: 0 / 6
          </div>
        </div>

        <div id="quiz-questions-container" class="space-y-5 pt-2">
          <!-- Populated via renderQuiz() -->
        </div>
      </div>

      <!-- Next Lesson Reflections -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-4">
        <div class="border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2">
            <i data-lucide="feather" class="w-5 h-5 text-autumn-600"></i>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Reflections for Sunday's Rapid-Recall Class</h2>
          </div>
          <p class="text-xs text-stone-500 mt-0.5">Three thought-provoking prompts to prepare for Sunday's 30-minute fast-paced session</p>
        </div>

        <div id="reflections-container" class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
          <!-- Populated via renderReflections() -->
        </div>
      </div>

    </section>

    <!-- FOOTER -->
    <footer id="how-it-works" class="sanctuary-card rounded-3xl p-6 sm:p-8 text-center space-y-3 no-print">
      <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-sage-600 to-autumn-600 flex items-center justify-center text-white font-serif text-xl font-bold mx-auto">
        L
      </div>
      <h3 class="font-serif font-bold text-xl text-slatewarm-900">Louie's English Sanctuary • Preply Partner Portal</h3>
      <p class="text-xs text-stone-500 max-w-xl mx-auto leading-relaxed">
        Crafted with calm attention to detail for Friday's lesson (24 October 2026). Designed to provide zero-stress review, pristine audio synthesis, and lasting confidence on the global stage.
      </p>
      <div class="pt-2 text-[11px] font-mono text-stone-400">
        Kensington Stone &bull; Winchester Mist &bull; Twilight Study &bull; Built with Tailwind CSS, Lucide, Tippy.js &amp; Web Audio API
      </div>
    </footer>

  </main>
'@

# Now assemble JavaScript blocks safely
$jsScript = @"
  <script>
    // -------------------------------------------------------------------------
    // 1. DATA OBJECTS INJECTED FROM LESSON DATA
    // -------------------------------------------------------------------------
    function v(key, displayWord) {
      const item = (typeof VOCAB_DB !== 'undefined' && VOCAB_DB[key]) ? VOCAB_DB[key] : null;
      const label = displayWord || (item ? item.word : key);
      return '<span class=\"vocab-mark\" data-vkey=\"' + key + '\" onclick=\"inspectVocab(\\'' + key + '\\')\">' + label + '</span>';
    }

    function fixBadge(corrected, rawMistake) {
      return '<span class=\"asr-fix-pill\" title=\"Note-taker misheard \\'' + corrected + '\\' as \\'' + rawMistake + '\\'\">⚡ Fixed: \"' + corrected + '\" <span class=\"text-stone-400 font-normal\">(heard: \"' + rawMistake + '\")</span></span>';
    }

    const VOCAB_DB = $vocabDbBlock

    const ASR_FIXES = $asrFixesBlock

    const NATURAL_STRENGTHS = $naturalStrengthsBlock

    const PHRASING_POLISHES = $phrasingPolishesBlock

    const TRANSCRIPT_TURNS = $transcriptTurnsBlock

    const EDITORIAL_TOPICS = $editorialTopicsBlock

    const FLASHCARDS = $flashcardsBlock

    const IDIOM_CHALLENGES = $idiomChallengesBlock

    const QUIZ_QUESTIONS = $quizQuestionsBlock

    const REFLECTION_PROMPTS = $reflectionPromptsBlock

    // -------------------------------------------------------------------------
    // 2. STATE MANAGEMENT
    // -------------------------------------------------------------------------
    let activeTab = 'transcript';
    let activeSpeakerFilter = 'all';
    let activeVocabCategory = 'all';
    let activeVocabLevel = 'all';
    let currentFlashcardIndex = 0;
    let isFlashcardFlipped = false;
    let currentVoiceRate = 1.0;
    let quizAnswers = {};
    let idiomAnswers = {};

    // -------------------------------------------------------------------------
    // 3. TAB SWITCHING
    // -------------------------------------------------------------------------
    function switchTab(tabId) {
      activeTab = tabId;
      const tabs = ['transcript', 'vocab', 'fixes', 'editorials', 'practice'];
      
      tabs.forEach(t => {
        const panel = document.getElementById('tab-panel-' + t);
        const btn = document.getElementById('tab-btn-' + t);
        if (panel) {
          panel.classList.toggle('hidden', t !== tabId);
        }
        if (btn) {
          if (t === tabId) {
            btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm';
          } else {
            btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100';
          }
        }
      });

      window.scrollTo({ top: 400, behavior: 'smooth' });
    }

    // -------------------------------------------------------------------------
    // 4. SPOTLIGHT & TIPPY
    // -------------------------------------------------------------------------
    function inspectVocab(key) {
      const item = VOCAB_DB[key];
      if (!item) return;

      document.querySelectorAll('.vocab-mark').forEach(el => {
        el.classList.toggle('active-vocab', el.getAttribute('data-vkey') === key);
      });

      const badge = document.getElementById('spotlight-badge');
      if (badge) {
        badge.textContent = item.level + ' • ' + (item.pos || 'term');
      }

      const body = document.getElementById('spotlight-body');
      if (body) {
        const cleanWord = (item.word || '').replace(/'/g, "\\'");
        body.innerHTML = 
          '<div class=\"space-y-3\">' +
            '<div class=\"flex items-baseline justify-between\">' +
              '<h3 class=\"font-serif font-bold text-2xl text-slatewarm-900 leading-tight\">' + item.word + '</h3>' +
              '<button onclick=\"speakWord(\\'' + cleanWord + '\\')\" class=\"p-1.5 text-stone-400 hover:text-autumn-600 transition\" title=\"Listen\">' +
                '<i data-lucide=\"volume-2\" class=\"w-5 h-5\"></i>' +
              '</button>' +
            '</div>' +
            '<div class=\"text-xs font-mono text-stone-500\">' + item.ipa + ' &bull; <span class=\"italic font-sans\">' + item.pos + '</span></div>' +
            '<p class=\"text-xs sm:text-sm text-stone-700 font-sans leading-relaxed pt-1\">' + item.def + '</p>' +
            (item.th ? '<div class=\"p-3 rounded-xl bg-gradient-to-r from-parchment-100 to-autumn-50/70 border border-autumn-200 text-xs font-medium text-slatewarm-900\">🇹🇭 <strong>ไทย:</strong> ' + item.th + '</div>' : '') +
            (item.quote ? '<div class=\"pt-2 border-t border-parchment-200 text-[11px] text-stone-500 italic font-serif leading-relaxed\">“' + item.quote + '”</div>' : '') +
            '<div class=\"flex items-center justify-between text-xs pt-2 text-stone-400 font-mono\">' +
              '<span>🕒 ' + (item.time || '--:--') + '</span>' +
              '<button onclick=\"jumpToTranscriptTurn(\\'' + (item.turnId || '') + '\\', \\'' + key + '\\')\" class=\"text-autumn-700 hover:text-autumn-800 font-semibold flex items-center gap-1 transition\">' +
                '<span>View in turn</span>' +
                '<i data-lucide=\"arrow-up-right\" class=\"w-3.5 h-3.5\"></i>' +
              '</button>' +
            '</div>' +
          '</div>';
        if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
      }
    }

    function initTippyTooltips() {
      if (typeof tippy !== 'function') return;
      tippy('.vocab-mark', {
        theme: 'autumn-sanctuary',
        animation: 'shift-away',
        allowHTML: true,
        interactive: true,
        placement: 'top',
        delay: [120, 80],
        content(reference) {
          const key = reference.getAttribute('data-vkey');
          const item = (typeof VOCAB_DB !== 'undefined' && VOCAB_DB[key]) ? VOCAB_DB[key] : null;
          if (!item) return '';
          return '<div class=\"p-2.5 space-y-1.5 text-left text-xs max-w-xs\">' +
            '<div class=\"flex items-center justify-between gap-2 border-b border-parchment-200 pb-1\">' +
              '<strong class=\"font-serif text-sm text-slatewarm-900\">' + item.word + '</strong>' +
              '<span class=\"px-1.5 py-0.2 rounded text-[10px] font-mono font-bold bg-autumn-100 text-autumn-800\">' + item.level + '</span>' +
            '</div>' +
            '<div class=\"font-mono text-[10px] text-stone-500\">' + item.ipa + ' &bull; ' + item.pos + '</div>' +
            '<p class=\"text-[11px] text-stone-700 leading-snug\">' + item.def + '</p>' +
            (item.th ? '<div class=\"text-[11px] text-autumn-800 font-medium pt-1\">🇹🇭 ' + item.th + '</div>' : '') +
          '</div>';
        }
      });
    }

    // -------------------------------------------------------------------------
    // 5. RENDER TRANSCRIPT
    // -------------------------------------------------------------------------
    function renderTranscript() {
      const container = document.getElementById('transcript-turns-container');
      if (!container) return;
      const search = (document.getElementById('transcript-search').value || '').toLowerCase().trim();
      let html = '';
      let currentChapter = '';

      TRANSCRIPT_TURNS.forEach(turn => {
        if (activeSpeakerFilter !== 'all' && turn.speaker.toLowerCase() !== activeSpeakerFilter.toLowerCase()) {
          return;
        }

        if (search) {
          const textToSearch = (turn.speaker + ' ' + turn.time + ' ' + turn.html.replace(/<[^>]*>/g, '')).toLowerCase();
          if (!textToSearch.includes(search)) return;
        }

        if (turn.chapter && turn.chapter !== currentChapter) {
          currentChapter = turn.chapter;
          html += '<div class=\"py-3 px-4 rounded-2xl bg-parchment-200/60 border border-parchment-300 flex items-center justify-between text-xs font-serif font-bold text-slatewarm-900 mt-6 mb-2\">' +
            '<span class=\"flex items-center gap-2\"><i data-lucide=\"bookmark\" class=\"w-4 h-4 text-autumn-600\"></i>' + currentChapter + '</span>' +
            '<span class=\"font-mono text-[11px] text-stone-500 font-normal\">🕒 ' + turn.time + '</span>' +
          '</div>';
        }

        const isLouie = turn.speaker.toLowerCase() === 'louie';
        const borderStyle = isLouie ? 'border-l-4 border-l-sage-600 bg-sage-50/40' : 'border-l-4 border-l-autumn-500 bg-parchment-50/50';
        const avatarBg = isLouie ? 'bg-sage-600 text-white' : 'bg-autumn-500 text-white';
        const speakerLabel = isLouie ? 'Louie (Teacher)' : 'Student';
        const cleanSpoken = turn.html.replace(/<[^>]*>/g, '').replace(/'/g, "\\'");

        html += '<div id=\"' + turn.id + '\" class=\"sanctuary-subcard rounded-2xl p-4 sm:p-5 ' + borderStyle + ' space-y-2.5 transition hover:shadow-sm\">' +
          '<div class=\"flex items-center justify-between gap-2 border-b border-stone-200/60 pb-2\">' +
            '<div class=\"flex items-center gap-2.5\">' +
              '<div class=\"w-7 h-7 rounded-full ' + avatarBg + ' flex items-center justify-center font-bold text-xs\">' + turn.speaker.charAt(0) + '</div>' +
              '<div>' +
                '<span class=\"font-bold text-xs sm:text-sm text-slatewarm-900\">' + speakerLabel + '</span>' +
                '<span class=\"ml-2 font-mono text-[11px] text-stone-400\">🕒 ' + turn.time + '</span>' +
              '</div>' +
            '</div>' +
            '<button onclick=\"speakText(\\'' + cleanSpoken + '\\', \\'en-GB\\')\" class=\"p-1.5 rounded-lg text-stone-400 hover:text-autumn-600 hover:bg-parchment-100 transition\" title=\"Listen to this turn\">' +
              '<i data-lucide=\"volume-2\" class=\"w-4 h-4\"></i>' +
            '</button>' +
          '</div>' +
          '<div class=\"text-xs sm:text-sm text-slatewarm-900 leading-relaxed font-sans turn-body\">' + turn.html + '</div>' +
        '</div>';
      });

      if (!html) {
        html = '<div class=\"text-center py-12 text-stone-500 font-serif text-base\">No turns match your search criteria.</div>';
      }

      container.innerHTML = html;
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
      initTippyTooltips();
    }

    function filterTranscript() {
      const val = document.getElementById('transcript-search').value;
      document.getElementById('clear-search-btn').classList.toggle('hidden', !val);
      renderTranscript();
    }

    function clearTranscriptSearch() {
      document.getElementById('transcript-search').value = '';
      document.getElementById('clear-search-btn').classList.add('hidden');
      renderTranscript();
    }

    function filterSpeaker(speaker) {
      activeSpeakerFilter = speaker;
      ['all', 'Louie', 'Worachon'].forEach(s => {
        const btn = document.getElementById('spk-' + s.toLowerCase() + '-btn');
        if (btn) {
          if (s === speaker) {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition';
          } else {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition';
          }
        }
      });
      renderTranscript();
    }

    function toggleAsrBadges() {
      document.body.classList.toggle('hide-asr-fixes');
      const hidden = document.body.classList.contains('hide-asr-fixes');
      document.getElementById('asr-btn-text').textContent = hidden ? 'Note-Taker Fixes: Hidden' : 'Note-Taker Fixes: Visible';
    }

    function toggleVocabHighlights() {
      document.body.classList.toggle('hide-vocab-highlights');
      const hidden = document.body.classList.contains('hide-vocab-highlights');
      document.getElementById('vocab-btn-text').textContent = hidden ? 'Vocab Highlights: Off' : 'Vocab Highlights: On';
    }

    function jumpToTranscriptTurn(turnId, vocabKey) {
      switchTab('transcript');
      if (vocabKey) inspectVocab(vocabKey);

      setTimeout(() => {
        const el = document.getElementById(turnId);
        if (el) {
          el.scrollIntoView({ behavior: 'smooth', block: 'center' });
          el.classList.add('turn-highlight-flash');
          setTimeout(() => el.classList.remove('turn-highlight-flash'), 2900);
        }
      }, 150);
    }

    // -------------------------------------------------------------------------
    // 6. RENDER VOCABULARY DICTIONARY
    // -------------------------------------------------------------------------
    function renderVocabGrid() {
      const container = document.getElementById('vocab-cards-grid');
      if (!container) return;
      const searchVal = (document.getElementById('vocab-search').value || '').toLowerCase().trim();
      let html = '';
      let count = 0;

      Object.keys(VOCAB_DB).forEach(key => {
        const item = VOCAB_DB[key];
        if (!item) return;

        if (activeVocabCategory !== 'all') {
          if (activeVocabCategory === 'idioms' && item.cat !== 'idioms') return;
          if (activeVocabCategory === 'science' && item.cat !== 'science' && item.cat !== 'technology') return;
          if (activeVocabCategory === 'medical' && item.cat !== 'medical') return;
          if (activeVocabCategory === 'lifestyle' && item.cat !== 'lifestyle' && item.cat !== 'concepts' && item.cat !== 'culture') return;
        }

        if (activeVocabLevel !== 'all' && !item.level.startsWith(activeVocabLevel)) {
          return;
        }

        if (searchVal) {
          const combined = ((item.word || '') + ' ' + (item.def || '') + ' ' + (item.th || '') + ' ' + (item.cat || '') + ' ' + (item.quote || '')).toLowerCase();
          if (!combined.includes(searchVal)) return;
        }

        count++;
        const cleanWord = (item.word || '').replace(/'/g, "\\'");

        html += '<div class=\"sanctuary-subcard rounded-2xl p-5 space-y-3.5 transition hover:shadow-md flex flex-col justify-between border-t-2 border-t-autumn-400\">' +
          '<div class=\"space-y-2\">' +
            '<div class=\"flex items-center justify-between gap-2\">' +
              '<span class=\"px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-autumn-100 text-autumn-800\">' + item.level + '</span>' +
              '<span class=\"px-2 py-0.5 rounded text-[10px] font-mono text-stone-500 capitalize bg-stone-100\">' + item.cat + '</span>' +
            '</div>' +
            '<div>' +
              '<div class=\"flex items-baseline justify-between\">' +
                '<h3 class=\"font-serif font-bold text-xl text-slatewarm-900 leading-tight\">' + item.word + '</h3>' +
                '<button onclick=\"speakWord(\\'' + cleanWord + '\\')\" class=\"p-1 text-stone-400 hover:text-autumn-600 transition\" title=\"Listen\">' +
                  '<i data-lucide=\"volume-2\" class=\"w-4 h-4\"></i>' +
                '</button>' +
              '</div>' +
              '<div class=\"text-[11px] font-mono text-stone-500\">' + item.ipa + ' &bull; <span class=\"italic font-sans\">' + item.pos + '</span></div>' +
            '</div>' +
            '<p class=\"text-xs text-stone-700 font-sans leading-relaxed\">' + item.def + '</p>' +
            (item.th ? '<div class=\"p-2.5 rounded-xl bg-gradient-to-r from-parchment-100 to-autumn-50/50 border border-autumn-200/70 text-xs font-medium text-slatewarm-900\">🇹🇭 <strong>ไทย:</strong> ' + item.th + '</div>' : '') +
            (item.quote ? '<blockquote class=\"border-l-2 border-stone-300 pl-2.5 text-[11px] italic text-stone-500 leading-relaxed font-serif\">“' + item.quote + '”</blockquote>' : '') +
          '</div>' +
          '<div class=\"pt-3 border-t border-stone-100 flex items-center justify-between text-xs\">' +
            '<span class=\"text-stone-400 font-mono text-[11px]\">🕒 ' + (item.time || '--:--') + '</span>' +
            '<button onclick=\"jumpToTranscriptTurn(\\'' + (item.turnId || '') + '\\', \\'' + key + '\\')\" class=\"text-autumn-700 hover:text-autumn-800 font-semibold flex items-center gap-1 transition\">' +
              '<span>View in turn</span>' +
              '<i data-lucide=\"arrow-up-right\" class=\"w-3.5 h-3.5\"></i>' +
            '</button>' +
          '</div>' +
        '</div>';
      });

      if (!html) {
        html = '<div class=\"col-span-full text-center py-12 sanctuary-card rounded-3xl p-6 text-stone-500 space-y-2\">' +
          '<i data-lucide=\"book-x\" class=\"w-8 h-8 mx-auto text-stone-400\"></i>' +
          '<p class=\"font-serif text-base\">No vocabulary items matched your filter.</p>' +
        '</div>';
      }

      container.innerHTML = html;
      const countEl = document.getElementById('vocab-total-badge');
      if (countEl) countEl.textContent = count + ' Words';
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
    }

    function filterVocabCategory(cat) {
      activeVocabCategory = cat;
      ['all', 'idioms', 'medical', 'science', 'lifestyle'].forEach(c => {
        const btn = document.getElementById('cat-' + c);
        if (btn) {
          if (c === cat) {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition';
          } else {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition';
          }
        }
      });
      renderVocabGrid();
    }

    function filterVocabLevel(lvl) {
      activeVocabLevel = lvl;
      ['all', 'B2', 'C1', 'C2'].forEach(l => {
        const btn = document.getElementById('lvl-' + l);
        if (btn) {
          if (l === lvl) {
            btn.className = 'px-2.5 py-1 rounded-lg bg-autumn-600 text-white font-bold transition text-xs';
          } else {
            btn.className = 'px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs';
          }
        }
      });
      renderVocabGrid();
    }

    // -------------------------------------------------------------------------
    // 7. RENDER TAB 3 (Strengths, Phrasing, ASR Fixes) & TAB 4 (Editorials)
    // -------------------------------------------------------------------------
    function renderStrengths() {
      const container = document.getElementById('strengths-container');
      if (!container) return;
      container.innerHTML = NATURAL_STRENGTHS.map((item, idx) => 
        '<div class=\"sanctuary-subcard p-5 rounded-2xl border-l-4 border-l-sage-500 space-y-2\">' +
          '<div class=\"flex items-center justify-between text-xs\">' +
            '<span class=\"font-mono text-sage-800 font-bold\">' + (idx + 1) + '. Natural Strength</span>' +
            '<span class=\"font-mono text-stone-400\">🕒 ' + item.time + '</span>' +
          '</div>' +
          '<p class=\"font-serif italic text-sm text-stone-800\">\"' + item.quote + '\"</p>' +
          '<p class=\"text-xs text-stone-600\"><strong>Why this stood out:</strong> ' + item.praise + '</p>' +
        '</div>'
      ).join('');
    }

    function renderPhrasing() {
      const container = document.getElementById('phrasing-container');
      if (!container) return;
      container.innerHTML = PHRASING_POLISHES.map(item => 
        '<div class=\"sanctuary-subcard p-5 rounded-2xl space-y-2\">' +
          '<div class=\"flex items-center justify-between text-xs\">' +
            '<span class=\"px-2 py-0.5 rounded-full bg-amber-100 text-amber-800 font-mono font-bold\">Gentle Polish</span>' +
            '<span class=\"text-stone-400 font-mono\">🕒 ' + item.time + '</span>' +
          '</div>' +
          '<div class=\"grid grid-cols-1 md:grid-cols-2 gap-3 text-xs sm:text-sm\">' +
            '<div class=\"bg-stone-50 p-3 rounded-xl border border-stone-200\">' +
              '<span class=\"text-[10px] uppercase font-mono font-bold text-stone-400 block mb-1\">In The Moment Spoken</span>' +
              '<p class=\"text-stone-700 italic\">\"' + item.spoken + '\"</p>' +
            '</div>' +
            '<div class=\"bg-sage-50 p-3 rounded-xl border border-sage-200\">' +
              '<span class=\"text-[10px] uppercase font-mono font-bold text-sage-700 block mb-1\">Gentle Native Polish</span>' +
              '<p class=\"text-sage-900 font-semibold\">\"' + item.polished + '\"</p>' +
            '</div>' +
          '</div>' +
          '<p class=\"text-xs text-stone-500\"><em>Why:</em> ' + item.why + '</p>' +
        '</div>'
      ).join('');
    }

    function renderAsrFixes() {
      const tbody = document.getElementById('asr-fixes-tbody');
      if (!tbody) return;
      tbody.innerHTML = ASR_FIXES.map(fix => 
        '<tr>' +
          '<td class=\"py-2.5 px-3 font-mono text-autumn-700\">🕒 ' + fix.time + '</td>' +
          '<td class=\"py-2.5 px-3 font-mono text-red-600 line-through\">\"' + fix.misheard + '\"</td>' +
          '<td class=\"py-2.5 px-3 font-bold text-sage-900\">' + fix.corrected + '</td>' +
          '<td class=\"py-2.5 px-3 text-stone-600\">' + fix.context + '</td>' +
        '</tr>'
      ).join('');
    }

    function renderEditorialTopics() {
      const container = document.getElementById('editorial-grid');
      if (!container) return;
      container.innerHTML = EDITORIAL_TOPICS.map(item => 
        '<article class=\"sanctuary-card rounded-3xl p-6 sm:p-7 space-y-3.5 transition hover:shadow-md border-t-4 ' + item.border + '\">' +
          '<div class=\"flex items-center justify-between text-xs\">' +
            '<span class=\"px-2.5 py-0.5 rounded-full bg-parchment-200 text-stone-700 font-mono font-bold text-[11px]\">' + item.tag + '</span>' +
            '<span class=\"font-mono text-stone-400\">🕒 ' + item.time + '</span>' +
          '</div>' +
          '<h3 class=\"font-serif font-bold text-xl sm:text-2xl text-slatewarm-900 leading-snug\">' + item.title + '</h3>' +
          '<div class=\"text-xs sm:text-sm text-stone-700 font-sans leading-relaxed space-y-2.5\">' +
            '<p>' + item.p1 + '</p>' +
            '<p>' + item.p2 + '</p>' +
          '</div>' +
        '</article>'
      ).join('');
    }

    function renderReflections() {
      const container = document.getElementById('reflections-container');
      if (!container) return;
      container.innerHTML = REFLECTION_PROMPTS.map((p, idx) => 
        '<div class=\"sanctuary-subcard p-5 rounded-2xl space-y-2\">' +
          '<span class=\"text-[10px] uppercase font-mono font-bold text-autumn-700\">Prompt ' + (idx + 1) + '</span>' +
          '<h4 class=\"font-serif font-bold text-base text-slatewarm-900\">' + p.title + '</h4>' +
          '<p class=\"text-xs text-stone-600 leading-relaxed\">' + p.prompt + '</p>' +
        '</div>'
      ).join('');
    }

    // -------------------------------------------------------------------------
    // 8. FLASHCARDS, IDIOM GYM & QUIZ
    // -------------------------------------------------------------------------
    function updateFlashcardUI() {
      const fc = FLASHCARDS[currentFlashcardIndex];
      if (!fc) return;

      document.getElementById('flashcard-counter').textContent = (currentFlashcardIndex + 1) + ' / ' + FLASHCARDS.length;
      document.getElementById('fc-type-front').textContent = fc.type;
      document.getElementById('fc-front-word').textContent = fc.front;
      document.getElementById('fc-front-ipa').textContent = fc.ipa;
      document.getElementById('fc-front-example').textContent = fc.example;

      document.getElementById('fc-type-back').textContent = fc.type;
      document.getElementById('fc-back-th').textContent = fc.back;
      document.getElementById('fc-back-origin').textContent = fc.origin;

      const inner = document.getElementById('flashcard-card-inner');
      if (inner) {
        if (isFlashcardFlipped) {
          inner.classList.add('flipped');
        } else {
          inner.classList.remove('flipped');
        }
      }
    }

    function flipFlashcard() {
      isFlashcardFlipped = !isFlashcardFlipped;
      const inner = document.getElementById('flashcard-card-inner');
      if (inner) inner.classList.toggle('flipped', isFlashcardFlipped);
    }

    function nextFlashcard() {
      isFlashcardFlipped = false;
      currentFlashcardIndex = (currentFlashcardIndex + 1) % FLASHCARDS.length;
      updateFlashcardUI();
    }

    function prevFlashcard() {
      isFlashcardFlipped = false;
      currentFlashcardIndex = (currentFlashcardIndex - 1 + FLASHCARDS.length) % FLASHCARDS.length;
      updateFlashcardUI();
    }

    function speakCurrentFlashcard() {
      const fc = FLASHCARDS[currentFlashcardIndex];
      if (fc) speakText(fc.front, 'en-GB');
    }

    // Idiom Gym Scenario Matcher
    function renderIdiomGym() {
      const container = document.getElementById('idiom-gym-container');
      if (!container) return;

      container.innerHTML = IDIOM_CHALLENGES.map(ch => 
        '<div class=\"sanctuary-subcard p-5 rounded-2xl space-y-3\">' +
          '<div class=\"flex items-center gap-2 text-xs font-mono text-autumn-700 font-bold\">' +
            '<i data-lucide=\"target\" class=\"w-4 h-4\"></i>' +
            '<span>Challenge ' + ch.id + '</span>' +
          '</div>' +
          '<p class=\"text-xs sm:text-sm text-slatewarm-900 leading-relaxed font-medium\">' + ch.scenario + '</p>' +
          '<div class=\"flex flex-wrap gap-2 pt-1\">' +
            ch.options.map(opt => 
              '<button onclick=\"selectIdiomOption(' + ch.id + ', \\'' + opt.replace(/'/g, "\\'") + '\\')\" id=\"idiom-btn-' + ch.id + '-' + opt.replace(/[^a-zA-Z0-9]/g, '') + '\" class=\"px-3.5 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition\">' +
                opt +
              '</button>'
            ).join('') +
          '</div>' +
          '<div id=\"idiom-fb-' + ch.id + '\" class=\"hidden p-3 rounded-xl text-xs mt-2\"></div>' +
        '</div>'
      ).join('');
    }

    function selectIdiomOption(chId, chosen) {
      const ch = IDIOM_CHALLENGES.find(c => c.id === chId);
      if (!ch) return;
      idiomAnswers[chId] = chosen;

      const fb = document.getElementById('idiom-fb-' + chId);
      if (!fb) return;
      fb.classList.remove('hidden');

      ch.options.forEach(opt => {
        const btn = document.getElementById('idiom-btn-' + chId + '-' + opt.replace(/[^a-zA-Z0-9]/g, ''));
        if (btn) {
          if (opt === ch.correct) {
            btn.className = 'px-3.5 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs';
          } else if (opt === chosen && chosen !== ch.correct) {
            btn.className = 'px-3.5 py-1.5 rounded-xl text-xs font-semibold bg-red-100 text-red-700 border border-red-300';
          } else {
            btn.className = 'px-3.5 py-1.5 rounded-xl text-xs font-semibold bg-stone-100 text-stone-400 border border-stone-200';
          }
        }
      });

      if (chosen === ch.correct) {
        fb.className = 'p-3 rounded-xl text-xs mt-2 bg-sage-100 text-sage-900 border border-sage-300';
        fb.innerHTML = '<strong>✨ Spot On!</strong> ' + ch.explanation;
        if (typeof confetti === 'function') confetti({ particleCount: 35, spread: 50, origin: { y: 0.7 } });
      } else {
        fb.className = 'p-3 rounded-xl text-xs mt-2 bg-autumn-50 text-autumn-900 border border-autumn-200';
        fb.innerHTML = '<strong>💡 Almost there:</strong> ' + ch.explanation;
      }
    }

    // 6-Question Quiz
    function renderQuiz() {
      const container = document.getElementById('quiz-questions-container');
      if (!container) return;

      container.innerHTML = QUIZ_QUESTIONS.map(q => 
        '<div class=\"sanctuary-subcard p-5 rounded-2xl space-y-3\">' +
          '<div class=\"flex items-center gap-2 text-xs font-mono text-sage-800 font-bold\">' +
            '<i data-lucide=\"help-circle\" class=\"w-4 h-4 text-sage-600\"></i>' +
            '<span>Question ' + q.id + ' of ' + QUIZ_QUESTIONS.length + '</span>' +
          '</div>' +
          '<h3 class=\"font-serif font-bold text-base sm:text-lg text-slatewarm-900\">' + q.question + '</h3>' +
          '<div class=\"space-y-2 pt-1\">' +
            q.options.map((opt, oIdx) => 
              '<button onclick=\"selectQuizAnswer(' + q.id + ', ' + oIdx + ')\" id=\"quiz-btn-' + q.id + '-' + oIdx + '\" class=\"w-full text-left p-3 rounded-xl text-xs sm:text-sm font-medium bg-white border border-stone-200 hover:bg-parchment-100 transition flex items-start gap-2.5\">' +
                '<span class=\"w-5 h-5 rounded-full bg-parchment-200 text-stone-700 flex items-center justify-center font-mono text-[10px] shrink-0 font-bold\">' + String.fromCharCode(65 + oIdx) + '</span>' +
                '<span>' + opt + '</span>' +
              '</button>'
            ).join('') +
          '</div>' +
          '<div id=\"quiz-fb-' + q.id + '\" class=\"hidden p-3.5 rounded-xl text-xs mt-2 leading-relaxed\"></div>' +
        '</div>'
      ).join('');
    }

    function selectQuizAnswer(qId, choiceIdx) {
      const q = QUIZ_QUESTIONS.find(item => item.id === qId);
      if (!q) return;
      quizAnswers[qId] = choiceIdx;

      const fb = document.getElementById('quiz-fb-' + qId);
      if (!fb) return;
      fb.classList.remove('hidden');

      q.options.forEach((opt, idx) => {
        const btn = document.getElementById('quiz-btn-' + qId + '-' + idx);
        if (btn) {
          if (idx === q.correctIndex) {
            btn.className = 'w-full text-left p-3 rounded-xl text-xs sm:text-sm font-semibold bg-sage-700 text-white shadow-xs flex items-start gap-2.5';
          } else if (idx === choiceIdx && choiceIdx !== q.correctIndex) {
            btn.className = 'w-full text-left p-3 rounded-xl text-xs sm:text-sm font-semibold bg-red-100 text-red-700 border border-red-300 flex items-start gap-2.5';
          } else {
            btn.className = 'w-full text-left p-3 rounded-xl text-xs sm:text-sm font-medium bg-stone-50 text-stone-400 border border-stone-200 flex items-start gap-2.5';
          }
        }
      });

      if (choiceIdx === q.correctIndex) {
        fb.className = 'p-3.5 rounded-xl text-xs mt-2 leading-relaxed bg-sage-100 text-sage-900 border border-sage-300';
        fb.innerHTML = '<strong>✅ Correct!</strong> ' + q.explanation;
      } else {
        fb.className = 'p-3.5 rounded-xl text-xs mt-2 leading-relaxed bg-autumn-50 text-autumn-900 border border-autumn-200';
        fb.innerHTML = '<strong>💡 Solution:</strong> ' + q.explanation;
      }

      // Update score badge
      let score = 0;
      QUIZ_QUESTIONS.forEach(item => {
        if (quizAnswers[item.id] === item.correctIndex) score++;
      });
      document.getElementById('quiz-score-badge').textContent = 'Score: ' + score + ' / ' + QUIZ_QUESTIONS.length;

      if (score === QUIZ_QUESTIONS.length && typeof confetti === 'function') {
        confetti({ particleCount: 70, spread: 70, origin: { y: 0.6 } });
      }
    }

    // -------------------------------------------------------------------------
    // 9. WEB SPEECH API PRONUNCIATION
    // -------------------------------------------------------------------------
    function speakText(text, lang = 'en-GB') {
      if (!('speechSynthesis' in window)) return;
      window.speechSynthesis.cancel();
      const utterance = new SpeechSynthesisUtterance(text);
      utterance.lang = lang;
      utterance.rate = currentVoiceRate;
      
      const voices = window.speechSynthesis.getVoices();
      const british = voices.find(v => v.lang.includes('en-GB') || v.name.includes('UK') || v.name.includes('British'));
      if (british) utterance.voice = british;

      window.speechSynthesis.speak(utterance);
    }

    function speakWord(word) {
      speakText(word, 'en-GB');
    }

    function setVoiceRate(rate) {
      currentVoiceRate = rate;
      const slowBtn = document.getElementById('rate-slow');
      const normBtn = document.getElementById('rate-normal');
      if (rate === 0.85) {
        slowBtn.className = 'px-1.5 py-0.5 rounded-md text-[11px] bg-sage-600 text-white font-semibold transition';
        normBtn.className = 'px-1.5 py-0.5 rounded-md text-[11px] text-stone-600 hover:bg-parchment-100 transition';
      } else {
        normBtn.className = 'px-1.5 py-0.5 rounded-md text-[11px] bg-sage-600 text-white font-semibold transition';
        slowBtn.className = 'px-1.5 py-0.5 rounded-md text-[11px] text-stone-600 hover:bg-parchment-100 transition';
      }
    }

    // -------------------------------------------------------------------------
    // 10. PROCEDURAL WEB AUDIO API SOUNDSCAPE
    // -------------------------------------------------------------------------
    let audioCtx = null;
    let soundscapeNode = null;
    let soundscapeGain = null;
    let isSoundscapePlaying = false;
    let currentSoundscapePreset = 'breeze';

    function initAudioContext() {
      if (!audioCtx) {
        const AudioContext = window.AudioContext || window.webkitAudioContext;
        audioCtx = new AudioContext();
      }
    }

    function createPinkNoise() {
      const bufferSize = audioCtx.sampleRate * 2;
      const buffer = audioCtx.createBuffer(1, bufferSize, audioCtx.sampleRate);
      const data = buffer.getChannelData(0);
      let b0 = 0, b1 = 0, b2 = 0, b3 = 0, b4 = 0, b5 = 0, b6 = 0;
      for (let i = 0; i < bufferSize; i++) {
        const white = Math.random() * 2 - 1;
        b0 = 0.99886 * b0 + white * 0.0555179;
        b1 = 0.99332 * b1 + white * 0.0750759;
        b2 = 0.96900 * b2 + white * 0.1538520;
        b3 = 0.86650 * b3 + white * 0.3104856;
        b4 = 0.55000 * b4 + white * 0.5329522;
        b5 = -0.7616 * b5 - white * 0.0168980;
        data[i] = (b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362) * 0.11;
        b6 = white * 0.115926;
      }
      return buffer;
    }

    function toggleSoundscape() {
      initAudioContext();
      if (audioCtx.state === 'suspended') {
        audioCtx.resume();
      }

      if (isSoundscapePlaying) {
        stopSoundscape();
      } else {
        startSoundscape();
      }
    }

    function startSoundscape() {
      stopSoundscape();
      const buffer = createPinkNoise();
      const noise = audioCtx.createBufferSource();
      noise.buffer = buffer;
      noise.loop = true;

      const filter = audioCtx.createBiquadFilter();
      if (currentSoundscapePreset === 'rain') {
        filter.type = 'lowpass';
        filter.frequency.setValueAtTime(800, audioCtx.currentTime);
      } else if (currentSoundscapePreset === 'study') {
        filter.type = 'bandpass';
        filter.frequency.setValueAtTime(450, audioCtx.currentTime);
        filter.Q.setValueAtTime(1.5, audioCtx.currentTime);
      } else {
        filter.type = 'lowpass';
        filter.frequency.setValueAtTime(400, audioCtx.currentTime);
        // LFO wind swell
        const lfo = audioCtx.createOscillator();
        const lfoGain = audioCtx.createGain();
        lfo.frequency.setValueAtTime(0.12, audioCtx.currentTime);
        lfoGain.gain.setValueAtTime(250, audioCtx.currentTime);
        lfo.connect(lfoGain);
        lfoGain.connect(filter.frequency);
        lfo.start();
      }

      const gain = audioCtx.createGain();
      const vol = parseFloat(document.getElementById('soundscape-volume').value || 0.22);
      gain.gain.setValueAtTime(vol, audioCtx.currentTime);

      noise.connect(filter);
      filter.connect(gain);
      gain.connect(audioCtx.destination);
      noise.start();

      soundscapeNode = noise;
      soundscapeGain = gain;
      isSoundscapePlaying = true;

      document.getElementById('soundscape-label').textContent = 'Soundscape: On';
      document.getElementById('soundscape-btn').classList.add('bg-sage-100');
    }

    function stopSoundscape() {
      if (soundscapeNode) {
        try { soundscapeNode.stop(); soundscapeNode.disconnect(); } catch (e) {}
        soundscapeNode = null;
      }
      isSoundscapePlaying = false;
      const label = document.getElementById('soundscape-label');
      if (label) label.textContent = 'London Breeze: Off';
      const btn = document.getElementById('soundscape-btn');
      if (btn) btn.classList.remove('bg-sage-100');
    }

    function changeSoundscapePreset(preset) {
      currentSoundscapePreset = preset;
      if (isSoundscapePlaying) startSoundscape();
    }

    function updateSoundscapeVolume(vol) {
      if (soundscapeGain && audioCtx) {
        soundscapeGain.gain.setValueAtTime(parseFloat(vol), audioCtx.currentTime);
      }
    }

    // -------------------------------------------------------------------------
    // 11. HTML5 CANVAS FALLING LEAVES
    // -------------------------------------------------------------------------
    let leafMode = 'gentle'; // 'gentle', 'breeze', 'off'
    let canvas, ctx, animFrameId;
    let leaves = [];

    function initLeafCanvas() {
      canvas = document.getElementById('autumn-breeze-canvas');
      if (!canvas) return;
      ctx = canvas.getContext('2d');
      resizeCanvas();
      window.addEventListener('resize', resizeCanvas);
      createLeaves(28);
      animateLeaves();
    }

    function resizeCanvas() {
      if (!canvas) return;
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }

    function createLeaves(count) {
      leaves = [];
      const colors = ['#be6f38', '#d38c57', '#eed0b5', '#5b826f', '#cbb38e'];
      for (let i = 0; i < count; i++) {
        leaves.push({
          x: Math.random() * canvas.width,
          y: Math.random() * canvas.height,
          size: Math.random() * 8 + 6,
          speedY: Math.random() * 0.9 + 0.4,
          speedX: Math.random() * 0.8 - 0.2,
          rot: Math.random() * 360,
          rotSpeed: Math.random() * 1.5 - 0.75,
          color: colors[Math.floor(Math.random() * colors.length)],
          alpha: Math.random() * 0.35 + 0.25
        });
      }
    }

    function animateLeaves() {
      if (!ctx || !canvas) return;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      if (leafMode !== 'off') {
        leaves.forEach(leaf => {
          ctx.save();
          ctx.translate(leaf.x, leaf.y);
          ctx.rotate((leaf.rot * Math.PI) / 180);
          ctx.fillStyle = leaf.color;
          ctx.globalAlpha = leaf.alpha;
          
          // Draw leaf shape
          ctx.beginPath();
          ctx.moveTo(0, -leaf.size);
          ctx.quadraticCurveTo(leaf.size * 0.8, 0, 0, leaf.size);
          ctx.quadraticCurveTo(-leaf.size * 0.8, 0, 0, -leaf.size);
          ctx.fill();
          ctx.restore();

          const mult = leafMode === 'breeze' ? 2.2 : 1.0;
          leaf.y += leaf.speedY * mult;
          leaf.x += leaf.speedX * mult;
          leaf.rot += leaf.rotSpeed * mult;

          if (leaf.y > canvas.height + 20) {
            leaf.y = -20;
            leaf.x = Math.random() * canvas.width;
          }
          if (leaf.x > canvas.width + 20) leaf.x = -20;
          if (leaf.x < -20) leaf.x = canvas.width + 20;
        });
      }

      animFrameId = requestAnimationFrame(animateLeaves);
    }

    function cycleLeafBreeze() {
      const label = document.getElementById('leaves-label');
      if (leafMode === 'gentle') {
        leafMode = 'breeze';
        if (label) label.textContent = 'Leaves: Breeze';
      } else if (leafMode === 'breeze') {
        leafMode = 'off';
        if (label) label.textContent = 'Leaves: Still (Off)';
      } else {
        leafMode = 'gentle';
        if (label) label.textContent = 'Leaves: Gentle';
      }
    }

    // -------------------------------------------------------------------------
    // 12. THEME MOOD SELECTOR
    // -------------------------------------------------------------------------
    function setThemeMood(theme) {
      document.body.setAttribute('data-theme', theme);
      ['kensington', 'winchester', 'twilight'].forEach(t => {
        const btn = document.getElementById('theme-' + t);
        if (btn) {
          if (t === theme) {
            btn.className = 'px-2 py-0.5 rounded-lg bg-autumn-100 text-autumn-800 font-semibold transition';
          } else {
            btn.className = 'px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition';
          }
        }
      });
    }

    // -------------------------------------------------------------------------
    // 13. PREPLY SUMMARY CLIPBOARD EXPORT
    // -------------------------------------------------------------------------
    function copyPreplySummary() {
      const summaryText = 
        \"🌿 Louie's English Studio - Lesson Notes (24 Oct 2026)\\n\" +
        \"Student: Worachon P. | Tutor: Louie\\n\\n\" +
        \"✨ Topics Covered Today:\\n\" +
        \"• Chulalongkorn Day (วันปิยมหาราช) & Ceremonial Pith Helmets\\n\" +
        \"• Richard Dawkins, The Selfish Gene, Memes & Digital Gatekeepers\\n\" +
        \"• The Brain's Pain Paradox: Awake Craniotomies & Dura Mater Traction\\n\" +
        \"• Gastric Emptying Kinetics & Alcohol Absorption\\n\" +
        \"• Optics: Snell's Law, Total Internal Reflection & Cladding in Fiber Cables\\n\" +
        \"• Work-Life Balance: London Overwork vs Munich 40-hr Statutory Laws\\n\\n\" +
        \"🌟 6 Natural Strengths Celebrated & 6 Gentle Phrasing Polishes\\n\" +
        \"🎯 Next Lesson (Sunday): 30-Minute Fast Recall ('wham, bam, thank you, ma'am')\\n\\n\" +
        \"Explore your full interactive sanctuary notes, audio pronunciations, and flashcards on GitHub Pages!\";

      navigator.clipboard.writeText(summaryText).then(() => {
        alert('✨ Preply lesson summary copied to your clipboard!');
      }).catch(() => {
        alert('Could not copy automatically. Please copy the text from the notes tab.');
      });
    }

    // -------------------------------------------------------------------------
    // 14. INITIALIZATION
    // -------------------------------------------------------------------------
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

        // Select initial spotlight item
        inspectVocab('chulalongkorn-day');

        if (typeof lucide !== 'undefined' && lucide.createIcons) {
          lucide.createIcons();
        }
      } catch (err) {
        console.error('Initialization error:', err);
      }
    });
  </script>
</body>
</html>
"@

$fullHtml = $htmlHeader + "`n" + $jsScript

Write-Host "Writing index.html and lesson_10-24-2026.html with UTF-8 without BOM..."

[System.IO.File]::WriteAllText("d:\Documents\Haytham\index.html", $fullHtml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText("d:\Documents\Haytham\lesson_10-24-2026.html", $fullHtml, [System.Text.UTF8Encoding]::new($false))

Write-Host "Success! Created index.html and lesson_10-24-2026.html"
Write-Host "File size: $((Get-Item 'index.html').Length) bytes"
