# 🍂 Haytham's English Studio & Learning Sanctuary
### Interactive Cleaned Transcripts, Medical & Scientific Lexicon, and Idiom Practice Portals

**Student:** Haytham / Preply Student  
**Tutor:** Louie (Lewis O'Shea)  
**Atmosphere:** Autumn Sanctuary • Kensington Bath Stone, Winchester Mist & Twilight Study  
**GitHub Pages Deployment:** [https://log210788.github.io/haytham/](https://log210788.github.io/haytham/)

---

## 🌟 Lesson Navigation & Learning Portals

Access the interactive study portals directly on GitHub Pages:

| Portal | Date | Primary Themes & Scientific Discussions | Access Link |
| :--- | :--- | :--- | :--- |
| **Lesson Notes (Latest)** | **24 October 2026** | **King Chulalongkorn Memorial Day (วันปิยมหาราช) & Tropical Pith Helmets, Richard Dawkins' Evolutionary Memes & Digital Gatekeepers, The Brain's Pain Paradox & Awake Craniotomies, Dura Mater Traction & Headaches, Gastric Emptying Kinetics & Alcohol Absorption, Munich Work-Life Equilibrium, UCLA Fundamental vs Applied Research, Fiber Optic Refractive Cladding.** | [**Launch Lesson Notes (index.html)**](./index.html) • [Direct Link](./lesson_10-24-2026.html) |
| **Pre-Lesson Studio** | **20 October 2026** | **Napoleon Bonaparte & The 167 French Savants (1798), The Decipherment of the Rosetta Stone, Khufu's King's Chamber, Modern Cosmic-Ray Scans & The Lost Ahramat Nile Branch.** | [**Launch Napoleon Guide**](./pre_lesson_pyramids.html) • [Notes (Markdown)](./napoleon_pyramid_notes.md) |

---

## 🏛️ Core Features of the Interactive Sanctuary

Each single-file web application (`index.html`, `lesson_10-24-2026.html`) adheres strictly to the architectural standards in `TEMPLATE_INSTRUCTIONS_FOR_AI.md`:

1. **Full Chronological Cleaned Transcript:**
   - 6 structured chapters with exact timestamps (`00:00` to `01:00:36`).
   - Forensic speaker attribution distinguishing Louie and the student.
   - Interactive search bar, speaker filter toggles (All, Louie, Student), and per-turn Web Speech audio synthesis.

2. **Forensic Speech-to-Text Corrections (`fixBadge`):**
   - Automated speech-to-text mishearings (e.g., *"ปิยมหาราชเดย์"* → *"วันปิยมหาราช"*, *"pit hat"* → *"pith helmet"*, *"grass anatomy"* → *"gross anatomy"*, *"influencer"* → *"influenza"*, *"T-shirt in high school"* → *"teacher in high school"*, *"computer ship"* → *"computer chip"*) highlighted with toggleable pills.

3. **55 Inline Vocabulary Markers & Sticky Spotlight (`v`):**
   - Graded CEFR B2–C2 vocabulary across medicine, physics, neuroscience, philosophy, and colloquial idioms.
   - IPA phonetics, definitions, spoken lesson quotes, and Tippy.js hover cards.
   - Dual-inspection: hover for a swift glance or click to populate the sticky right-hand spotlight panel.

4. **Searchable Vocabulary Dictionary Tab:**
   - Filterable card grid by category pills (*Idioms & Sayings*, *Medical & Neuroscience*, *Optics & Biology*, *Lifestyle & Philosophy*) and CEFR levels.
   - Interactive `🕒 MM:SS ↗` jump buttons that switch to the transcript, smoothly scroll to the turn, and pulse the line with a 2.8s golden glow (`.turn-highlight-flash`).

5. **Natural Strengths & Gentle Phrasing Tab:**
   - **Your Natural Strengths:** 6 celebrated high-level expressions used naturally in conversation to build confidence.
   - **Gentle Phrasing Polishes:** 6 encouraging, constructive phrase upgrades (*"In the moment spoken"* → *"Natural native polish"*).
   - **ASR Correction Log:** Detailed breakdown of automated speech-to-text stumbling points.

6. **Science, Culture & Life Philosophy Editorial Tab:**
   - 4 deep editorial cards exploring the concepts discussed in the lesson.

7. **Peaceful Practice Sanctuary & Idiom Gym:**
   - **Interactive Flippable Flashcard Deck:** 12 cards with sound pronunciation, usage examples, and translations on flip.
   - **The Idiom Gym (Scenario Matcher):** 6 real-world conversational challenges with instant feedback and canvas confetti.
   - **Context Quiz:** 6 interactive multiple-choice questions with score tracking and confetti celebrations.
   - **Peaceful Reflection Prompts:** 3 thought-provoking speaking/writing topics for Sunday's rapid-recall lesson.
   - **Preply Lesson Summary Clipboard Export:** Instant button to copy a friendly progress message for Preply chat.

8. **Calming Atmosphere & Sensory Controls:**
   - 3 Peaceful Themes: *Kensington Bath Stone*, *Winchester Mist*, and *Twilight Warm Study*.
   - Built-in procedural Web Audio API soundscape synthesizer (*Autumn Breeze*, *Soft Rain*, *Warm Study Hearth*) with no external media dependencies.
   - HTML5 Canvas ambient falling autumn leaves animation with adjustable speed modes (*Gentle*, *Breeze*, *Still*).
   - Web Speech audio synthesis with 0.85× slow and 1.0× natural speed control.

---

## 📁 Repository Structure

```text
Haytham/
├── .nojekyll                   # Bypasses GitHub Pages Jekyll processing
├── README.md                   # Repository documentation and lesson index
├── index.html                  # Default GitHub Pages landing page (Lesson 02 Latest)
├── lesson_10-24-2026.html      # Dedicated Lesson 02 portal (24 October 2026)
├── pre_lesson_pyramids.html    # Pre-Lesson Guide: Napoleon & The Pyramids
├── napoleon_pyramid_notes.md   # Pre-Lesson notes on Napoleon & Savants
├── TEMPLATE_INSTRUCTIONS_FOR_AI.md # Master instructions with Text Rendering Safeguards
└── transcripts/
    └── 10-24-2026.txt          # Raw transcript (1h 00m 36s)
```
