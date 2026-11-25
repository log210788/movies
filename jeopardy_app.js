(() => {
  "use strict";

  const VALUES = [100, 200, 300, 400, 500];
  const STORAGE_KEY = "preply_tony_jeopardy_state_v1";

  const PRESET_DECKS = {
    tony_sanctuary: {
      name: "Tony's Cinema, Idioms & Culture Quiz 🎬",
      categories: [
        {
          title: "1. Cinema & Oscars Quiz 🎬",
          clues: [
            {
              clue: "Which 2023 A24 Holocaust drama—filmed mostly in a sunny family garden right beside Auschwitz—won the Oscar for Best International Feature and Best Sound?",
              answer: "THE ZONE OF INTEREST (directed by Jonathan Glazer)—famous for its chilling cinematic restraint.",
              spanish: "La zona de interés (The Zone of Interest), dirigida por Jonathan Glazer."
            },
            {
              clue: "In 'The Matrix' (1999), Morpheus offers Neo two pills. Which color wakes him up to the real world—and what does taking the other pill do?",
              answer: "RED PILL wakes him up to reality; BLUE PILL keeps him comfortably asleep in the simulation!",
              spanish: "Pastilla roja (despertar a la realidad) frente a pastilla azul (seguir en la simulación)."
            },
            {
              clue: "In 'The Martian' (2015), astronaut Mark Watney is stranded alone on Mars. What single vegetable does he manage to farm inside the Hab to survive?",
              answer: "POTATOES! (Grown using Martian soil, water, and a lot of science and humor.)",
              spanish: "Patatas (potatoes): las cultiva en Marte para sobrevivir."
            },
            {
              clue: "Which actor—already an Oscar winner for 'Oppenheimer'—is returning to the Marvel franchise in 'Avengers: Doomsday' as the iconic villain Doctor Doom?",
              answer: "ROBERT DOWNEY JR.! (Switching from Iron Man to Doctor Doom.)",
              spanish: "Robert Downey Jr. (regresa a Marvel como Doctor Doom)."
            },
            {
              clue: "In 'The Lord of the Rings: The Two Towers', Viggo Mortensen (Aragorn) lets out a famous agonizing scream after kicking an iron helmet. Why was that scream 100% real?",
              answer: "He actually BROKE TWO TOES kicking the heavy metal helmet—and Peter Jackson kept the take in the movie!",
              spanish: "Se rompió dos dedos del pie de verdad al patear el casco de hierro."
            }
          ]
        },
        {
          title: "2. Movie Craft & Critique 🎥",
          clues: [
            {
              clue: "What 2-word film term describes the emotional journey and growth a character goes through from the beginning of a movie to the end?",
              answer: "CHARACTER ARC (or STORY ARC)! Without one, heroes feel flat or 'not fleshed out'.",
              spanish: "Arco de personaje (character arc)."
            },
            {
              clue: "According to legendary director Alexander Mackendrick ('On Filmmaking'), a truly well-directed movie should still be understandable even if you turn OFF what?",
              answer: "THE SOUND / AUDIO! Visual storytelling should carry the story on its own.",
              spanish: "El sonido / audio: una gran película debe entenderse solo con imágenes."
            },
            {
              clue: "What is the difference between a BLOCKBUSTER and an INDIE FILM—and which one usually takes bigger creative risks?",
              answer: "A BLOCKBUSTER is a huge-budget studio hit aimed at mass audiences; an INDIE FILM is independently funded and often takes bolder artistic risks.",
              spanish: "Blockbuster (gran presupuesto comercial) frente a indie film (cine independiente)."
            },
            {
              clue: "In film criticism, what does CINEMATIC RESTRAINT mean? Give an example of a scary or emotional scene that works better by NOT showing everything.",
              answer: "Evoking powerful emotion through subtlety, silence, or off-screen suggestion rather than explicit shock or melodrama.",
              spanish: "Contención cinematográfica: sugerir en lugar de mostrarlo todo explícitamente."
            },
            {
              clue: "What do movie critics mean when they complain about an 'OVERPOWERED PROTAGONIST' and 'ZERO STAKES'?",
              answer: "A hero whose powers come with no effort or real danger—so the audience never feels tension or risk.",
              spanish: "Protagonista invencible (overpowered) sin riesgo real (stakes)."
            }
          ]
        },
        {
          title: "3. Wild English Idioms 🦁",
          clues: [
            {
              clue: "If someone tells you a business deal or an excuse 'sounds a bit FISHY', what do they mean?",
              answer: "It seems SUSPICIOUS, shady, or hard to trust!",
              spanish: "Suena turbio / sospechoso (que da mala espina)."
            },
            {
              clue: "Animal Group Quiz! What is the poetic English collective noun for a flock of CROWS?",
              answer: "A MURDER of crows!",
              spanish: "Una bandada de cuervos (a murder of crows)."
            },
            {
              clue: "Double Animal Quiz! What do we call a family of LIONS—and what do we call a noisy group of GEESE?",
              answer: "A PRIDE of lions, and a GAGGLE of geese!",
              spanish: "A pride of lions (manada de leones) y a gaggle of geese (bandada de gansos)."
            },
            {
              clue: "Complete this classic proverb about jealousy and social media: 'Comparison is the ________ of ________.'",
              answer: "Comparison is the THIEF OF JOY!",
              spanish: "La comparación es el ladrón de la alegría."
            },
            {
              clue: "What does it mean to 'TURN THE OTHER CHEEK', and which formal C2 noun describes that patient self-control?",
              answer: "To refuse to retaliate when someone wrongs you—demonstrating FORBEARANCE!",
              spanish: "Poner la otra mejilla / tolerancia paciente (forbearance)."
            }
          ]
        },
        {
          title: "4. Spanish vs. English Traps 🇪🇸🇬🇧",
          clues: [
            {
              clue: "False Friend Alert! In Spanish, 'orgullo' often sounds stubborn. Why is 'You should take PRIDE in your work' a big compliment in English?",
              answer: "Because 'taking pride in' means caring about quality, craftsmanship, and self-respect—not 'showing off'!",
              spanish: "'Take pride in' significa esmerarse y sentir satisfacción sana, no presumir."
            },
            {
              clue: "Spot the Grammar Trap! Which sentence is natural English? A) 'I look forward to do sports.'  B) 'I look forward to doing sports.'",
              answer: "B! 'I look forward to DOING sports.' ('Look forward to' is always followed by -ing!)",
              spanish: "Después de 'look forward to' siempre va gerundio (-ing)."
            },
            {
              clue: "Phone Habit Fix! Native speakers don't say 'watching my phone' when you check notifications. What are TWO natural verbs you can use instead?",
              answer: "CHECKING my phone, LOOKING AT my phone, or UNPLUGGING from my phone!",
              spanish: "Se dice 'checking my phone' o 'unplugging from my phone' (no 'watching')."
            },
            {
              clue: "What's the difference between CONSCIENCE (your inner moral voice) and CONSCIENTIOUS (a personality trait)?",
              answer: "CONSCIENCE tells you right from wrong; CONSCIENTIOUS means diligent, careful, and thorough in your work!",
              spanish: "Conscience (conciencia moral) frente a conscientious (concienzudo/diligente)."
            },
            {
              clue: "Upgrade 'spare time' and 'relax after work' using TWO natural B2 English words: 'In my ________, I love to ________.'",
              answer: "In my DOWNTIME, I love to UNWIND!",
              spanish: "Downtime (tiempo libre) y unwind (desconectar/relajarse)."
            }
          ]
        },
        {
          title: "5. World, Food & Brainteasers 🌍",
          clues: [
            {
              clue: "Which 3-word English noun describes a narrow point in a pipe—or a mental traffic jam that slows down your speaking fluency?",
              answer: "A BOTTLENECK! (1 word: bottleneck.)",
              spanish: "Cuello de botella (bottleneck)."
            },
            {
              clue: "Culinary Quiz! What is the difference between Italian GELATO and American ice cream (in texture, air, and serving temperature)?",
              answer: "Gelato is churned slower (less air = denser & creamier), uses more milk than cream, and is served slightly warmer!",
              spanish: "El gelato tiene menos aire, más leche que nata y se sirve un poco menos frío."
            },
            {
              clue: "In New York delis, what cured, spiced, smoked beef brisket is famously stacked sky-high inside a bagel or rye bread?",
              answer: "PASTRAMI!",
              spanish: "El pastrami."
            },
            {
              clue: "Which global racket sport—invented in Mexico and massively popular across Spain—is played in doubles inside an enclosed glass court?",
              answer: "PADEL!",
              spanish: "El pádel."
            },
            {
              clue: "Science Brainteaser! Why does inhaling helium make your voice sound like a cartoon chipmunk—even though helium does NOT change your vocal cord pitch?",
              answer: "Sound travels ~3x faster in lighter helium than in air, shifting the resonant frequencies (timbre) of your throat!",
              spanish: "El sonido viaja casi 3 veces más rápido en el helio, cambiando la resonancia de tu garganta."
            }
          ]
        }
      ],
      final: {
        category: "THE ULTIMATE FILM & FLUENCY QUIZ 🏆",
        clue: "3-Part Final Challenge: 1) Name one movie with a great 'character arc' and explain why in 2 sentences. 2) Explain the difference between 'unplugging' at the cinema vs. streaming at home. 3) Define 'serendipity' in your own words!",
        answer: "Great answer hits: 1) Clear film example with 'character arc' or 'stakes'. 2) Contrast 'unplug / immersive / communal' vs checking phones at home. 3) Serendipity = finding something wonderful by happy accident!",
        spanish: "Reto final: 1) Una película con gran arco de personaje, 2) Desconectar en el cine vs ver en casa, 3) Define 'serendipity'."
      }
    },

    tony_cinema: {
      name: "Tony's Film Buff & Hot-Take Quiz 🍿",
      categories: [
        {
          title: "1. Guess the Movie or Show 🍿",
          clues: [
            {
              clue: "Which hit British reality game show locks contestants in a Scottish castle where secret 'Traitors' eliminate 'Faithfuls' every night?",
              answer: "THE TRAITORS!",
              spanish: "The Traitors (el concurso británico de estrategia y traiciones)."
            },
            {
              clue: "Which 2019 psychological thriller won Joaquin Phoenix the Best Actor Oscar for playing struggling stand-up comedian Arthur Fleck?",
              answer: "JOKER!",
              spanish: "Joker (2019), con Joaquin Phoenix."
            },
            {
              clue: "In which 2014 Christopher Nolan sci-fi epic does Matthew McConaughey pilot a spacecraft through a wormhole near Saturn to save humanity?",
              answer: "INTERSTELLAR!",
              spanish: "Interstellar (2014), de Christopher Nolan."
            },
            {
              clue: "Which actress holds the all-time record with 21 Oscar nominations (winning 3, including 'Sophie's Choice' and 'The Iron Lady')?",
              answer: "MERYL STREEP!",
              spanish: "Meryl Streep (21 nominaciones al Óscar)."
            },
            {
              clue: "Which young Franco-American actor starred in 'Dune', 'Call Me by Your Name', 'Wonka', and 'Marty Supreme'?",
              answer: "TIMOTHÉE CHALAMET!",
              spanish: "Timothée Chalamet."
            }
          ]
        },
        {
          title: "2. Psychology & Nuance 🧠",
          clues: [
            {
              clue: "What is the difference between being AFFECTIONATE and being INFATUATED? Which one lasts longer?",
              answer: "AFFECTIONATE = warm, steady tenderness (family, pets, partners); INFATUATED = sudden, intense, short-lived obsession!",
              spanish: "Affectionate (cariñoso/ternura duradera) frente a infatuated (encaprichado)."
            },
            {
              clue: "What does the acronym FOMO stand for—and what adjective describes the feeling when you wish you had what someone else has?",
              answer: "Fear Of Missing Out — and ENVIOUS!",
              spanish: "Fear Of Missing Out (miedo a perderse algo) y envious (envidioso)."
            },
            {
              clue: "Which C1 verb means deliberately or subconsciously pushing down painful memories so you don't have to face them?",
              answer: "SUPPRESS!",
              spanish: "Suppress (reprimir o sofocar recuerdos/sentimientos)."
            },
            {
              clue: "If a person is APOLOGETIC, are they weak, rude, or considerate?",
              answer: "CONSIDERATE! It means acknowledging a mistake politely and thoughtfully.",
              spanish: "Considerado y educado (considerate), nunca débil."
            },
            {
              clue: "What 2-word noun describes the ongoing stream of thoughts, questions, and silent voice inside your own head?",
              answer: "INNER MONOLOGUE!",
              spanish: "Monólogo interior (inner monologue)."
            }
          ]
        },
        {
          title: "3. Culture, Sport & Cities 🌍",
          clues: [
            {
              clue: "Which coastal Spanish city hosts one of Europe's most prestigious international film festivals every September (famous for the Golden Shell)?",
              answer: "SAN SEBASTIÁN (Donostia)!",
              spanish: "San Sebastián (la Concha de Oro)."
            },
            {
              clue: "Which C1 two-word phrase describes rebuilding 700-year-old historic stone buildings—and which verb means bringing a whole street back to life?",
              answer: "ARCHITECTURAL RESTORATION and REVITALIZE!",
              spanish: "Architectural restoration (restauración arquitectónica) y revitalize (revitalizar)."
            },
            {
              clue: "What C1 noun names the coastal tidal swamp trees with dense, tangled roots that protect tropical shorelines?",
              answer: "MANGROVES!",
              spanish: "Los manglares (mangroves)."
            },
            {
              clue: "Which European country is home to Valencia—and what famous Sunday rice dish originated in its coastal lagoons?",
              answer: "SPAIN — and PAELLA VALENCIANA!",
              spanish: "España y la paella valenciana."
            },
            {
              clue: "Which 3-word phrase means a skill has become so automatic through practice that you do it without even thinking?",
              answer: "SECOND NATURE! ('Speaking English is becoming second nature.')",
              spanish: "Una segunda naturaleza (second nature)."
            }
          ]
        },
        {
          title: "4. Heads Up Speed-Round 🎯",
          clues: [
            {
              clue: "🚫 Describe MEATBALLS in 15 seconds WITHOUT saying 'meat', 'ball', 'beef', or 'pork'!",
              answer: "Example: 'Spherical, minced Italian-style bites simmered in rich tomato sauce and served over pasta!'",
              spanish: "Describe albóndigas sin decir meat, ball, beef ni pork."
            },
            {
              clue: "🚫 Describe INNOCENCE in 15 seconds WITHOUT saying 'child', 'kid', 'pure', or 'guilty'!",
              answer: "Example: 'Seeing only the good in everyone because you're incapable of imagining malice or bad intentions.'",
              spanish: "Describe inocencia sin decir child, kid, pure ni guilty."
            },
            {
              clue: "🚫 Describe FOMO in 15 seconds WITHOUT saying 'fear', 'missing', 'out', or 'party'!",
              answer: "Example: 'That anxious feeling scrolling Instagram on Friday night when everyone else looks like they're having the time of their lives!'",
              spanish: "Describe FOMO sin decir fear, missing, out ni party."
            },
            {
              clue: "🚫 Describe CINEMA in 15 seconds WITHOUT saying 'movie', 'film', 'screen', or 'popcorn'!",
              answer: "Example: 'A dark communal sanctuary where you unplug your phone for two hours and get lost in a story with strangers!'",
              spanish: "Describe el cine sin decir movie, film, screen ni popcorn."
            },
            {
              clue: "🚫 Describe A MURDER OF CROWS in 15 seconds WITHOUT saying 'bird', 'black', 'crow', or 'kill'!",
              answer: "Example: 'A spooky, poetic British collective noun for a noisy group of dark-feathered flying creatures!'",
              spanish: "Describe 'a murder of crows' sin decir bird, black, crow ni kill."
            }
          ]
        },
        {
          title: "5. 30-Second Hot-Take Sprints ⏱️",
          clues: [
            {
              clue: "🔥 Hot Take #1 (30s): Are 3-hour movies worth it, or should most films stay under 100 minutes? Defend your stance!",
              answer: "Goal: 2–3 punchy sentences using 'character arc', 'pacing', or 'stakes'.",
              spanish: "¿Valen la pena las películas de 3 horas o mejor menos de 100 minutos? Defiéndelo en 30s."
            },
            {
              clue: "🔥 Hot Take #2 (30s): Would you rather live in a world with ZERO FOMO or ZERO embarrassment? Choose one and explain why!",
              answer: "Goal: Quick, confident stance + 1 real-life example.",
              spanish: "¿Preferirías vivir sin FOMO o sin vergüenza? Defiéndelo en 30s."
            },
            {
              clue: "🔥 Hot Take #3 (30s): Convince a friend to turn off their phone and go to the cinema tonight using UNPLUG and IMMERSIVE!",
              answer: "Goal: Persuasive, natural English using 'unplug' and 'immersive'.",
              spanish: "Convence a un amigo de ir al cine hoy usando 'unplug' e 'immersive'."
            },
            {
              clue: "🔥 Hot Take #4 (30s): Would you rather be a Traitor or a Faithful on 'The Traitors'—and what would be your strategy?",
              answer: "Goal: Fun, spontaneous storytelling without translating word-for-word.",
              spanish: "¿Preferirías ser Traidor o Fiel en 'The Traitors'? Explica tu estrategia."
            },
            {
              clue: "🔥 Hot Take #5 (30s): Pitch your ideal Saturday in Valencia—include CYCLING, PADEL, UNWIND, and DOWNTIME!",
              answer: "Goal: Smooth, natural English using 'look forward to doing'!",
              spanish: "Describe tu sábado ideal en Valencia usando cycling, padel, unwind y downtime."
            }
          ]
        }
      ],
      final: {
        category: "THE 60-SECOND FILM REVIEW CHALLENGE 🎙️",
        clue: "Review any movie or series you watched recently in 45–60 seconds! Answer all 3: 1) Did it meet your expectations? 2) Did the characters have a proper arc? 3) Could the story be told with images alone and no audio?",
        answer: "A fluent, confident mini-review using natural cinema vocabulary ('character arc', 'stakes', 'fleshed out', 'cinematic restraint', 'immersive')!",
        spanish: "Reto de reseña en 60s: 1) ¿Cumplió expectativas? 2) ¿Hubo buen arco de personaje? 3) ¿Se entendería solo con imágenes sin audio?"
      }
    }
  };

  // State
  let state = {
    deckKey: "tony_sanctuary",
    deck: structuredClone(PRESET_DECKS.tony_sanctuary),
    usedTiles: {}, // "col-row": true
    dailyDoubleKey: "4-3",
    players: [
      { name: "Tony 🇪🇸", score: 0 },
      { name: "Louie 🇬🇧", score: 0 }
    ],
    activePlayerIdx: 0,
    timerSeconds: 45,
    soundEnabled: true,
    musicEnabled: true
  };

  let activeTile = null; // { col, row, value, isDailyDouble, wager }
  let timerInterval = null;
  let audioCtx = null;
  let musicInterval = null;

  // DOM Elements
  const $ = (id) => document.getElementById(id);
  const presetSelect = $("presetSelect");
  const timerSelect = $("timerSelect");
  const soundToggleBtn = $("soundToggleBtn");
  const musicToggleBtn = $("musicToggleBtn");
  const scoreboardEl = $("scoreboard");
  const boardEl = $("jeopardyBoard");

  // Clue Modal
  const clueModal = $("clueModal");
  const modalCategory = $("modalCategory");
  const modalValue = $("modalValue");
  const dailyDoubleBadge = $("dailyDoubleBadge");
  const modalTimer = $("modalTimer");
  const wagerView = $("wagerView");
  const wagerPlayerSelect = $("wagerPlayerSelect");
  const wagerInput = $("wagerInput");
  const clueView = $("clueView");
  const clueText = $("clueText");
  const answerBox = $("answerBox");
  const answerText = $("answerText");
  const modalFooter = $("modalFooter");
  const revealAnswerBtn = $("revealAnswerBtn");
  const awardRow = $("awardRow");

  // Final Modal
  const finalModal = $("finalModal");
  const finalCategoryBadge = $("finalCategoryBadge");
  const finalWagerStage = $("finalWagerStage");
  const finalWagersList = $("finalWagersList");
  const finalClueStage = $("finalClueStage");
  const finalClueText = $("finalClueText");
  const finalAnswerBox = $("finalAnswerBox");
  const finalAnswerText = $("finalAnswerText");
  const finalResolveList = $("finalResolveList");

  // Editor Modal
  const editorModal = $("editorModal");
  const playerCountInput = $("playerCountInput");
  const playerNamesInputs = $("playerNamesInputs");
  const editorGrid = $("editorGrid");
  const editFinalCat = $("editFinalCat");
  const editFinalClue = $("editFinalClue");
  const editFinalAnswer = $("editFinalAnswer");

  // Sound Effects & Thinking Music via HTML5 <audio> + PCM WAV Generator
  function buildWavUrl(notes, waveType = "triangle", volume = 0.5) {
    const sampleRate = 22050;
    const totalSamples = notes.reduce((sum, n) => sum + Math.floor(n.dur * sampleRate), 0);
    const buffer = new ArrayBuffer(44 + totalSamples * 2);
    const view = new DataView(buffer);

    const writeStr = (offset, str) => {
      for (let i = 0; i < str.length; i++) view.setUint8(offset + i, str.charCodeAt(i));
    };

    writeStr(0, "RIFF");
    view.setUint32(4, 36 + totalSamples * 2, true);
    writeStr(8, "WAVE");
    writeStr(12, "fmt ");
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true);
    view.setUint16(22, 1, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * 2, true);
    view.setUint16(32, 2, true);
    view.setUint16(34, 16, true);
    writeStr(36, "data");
    view.setUint32(40, totalSamples * 2, true);

    let offset = 44;
    for (const note of notes) {
      const len = Math.floor(note.dur * sampleRate);
      for (let i = 0; i < len; i++) {
        let sample = 0;
        if (note.freq > 0) {
          const t = i / sampleRate;
          const phase = (t * note.freq) % 1;
          if (waveType === "square") {
            sample = phase < 0.5 ? 1 : -1;
          } else if (waveType === "sawtooth") {
            sample = 2 * phase - 1;
          } else if (waveType === "triangle") {
            sample = 1 - 4 * Math.abs(phase - 0.5);
          } else {
            sample = Math.sin(2 * Math.PI * note.freq * t);
          }
          // Smooth attack & decay envelope
          const env = Math.min(1, i / 120) * Math.max(0, 1 - i / len);
          sample *= env * volume;
        }
        view.setInt16(offset, Math.max(-1, Math.min(1, sample)) * 32767, true);
        offset += 2;
      }
    }

    return URL.createObjectURL(new Blob([buffer], { type: "audio/wav" }));
  }

  const AUDIO_URLS = {
    open: buildWavUrl([{ freq: 523.25, dur: 0.14 }], "triangle", 0.55),
    dailyDouble: buildWavUrl(
      [
        { freq: 440, dur: 0.12 },
        { freq: 554.37, dur: 0.12 },
        { freq: 659.25, dur: 0.28 }
      ],
      "square",
      0.45
    ),
    correct: buildWavUrl(
      [
        { freq: 523.25, dur: 0.12 },
        { freq: 783.99, dur: 0.25 }
      ],
      "triangle",
      0.6
    ),
    wrong: buildWavUrl([{ freq: 185, dur: 0.32 }], "sawtooth", 0.45),
    timeUp: buildWavUrl(
      [
        { freq: 330, dur: 0.16 },
        { freq: 0, dur: 0.04 },
        { freq: 247, dur: 0.34 }
      ],
      "sawtooth",
      0.5
    ),
    dot: buildWavUrl([{ freq: 660, dur: 0.08 }], "triangle", 0.45),
    think: buildWavUrl(
      [
        { freq: 392.0, dur: 0.3 }, { freq: 523.25, dur: 0.3 }, { freq: 392.0, dur: 0.3 }, { freq: 329.63, dur: 0.3 },
        { freq: 392.0, dur: 0.3 }, { freq: 523.25, dur: 0.3 }, { freq: 392.0, dur: 0.3 }, { freq: 0, dur: 0.3 },
        { freq: 392.0, dur: 0.3 }, { freq: 523.25, dur: 0.3 }, { freq: 392.0, dur: 0.3 }, { freq: 523.25, dur: 0.3 },
        { freq: 587.33, dur: 0.3 }, { freq: 523.25, dur: 0.3 }, { freq: 493.88, dur: 0.3 }, { freq: 440.0, dur: 0.3 }
      ],
      "triangle",
      0.38
    )
  };

  const thinkAudio = new Audio(AUDIO_URLS.think);
  thinkAudio.loop = true;

  function playSound(key) {
    if (!state.soundEnabled) return;
    const url = AUDIO_URLS[key];
    if (!url) return;
    try {
      const a = new Audio(url);
      a.play().catch(() => {});
    } catch (_) {}
  }

  function playTone() {
    playSound("dot");
  }

  function stopThinkMusic() {
    try {
      thinkAudio.pause();
      thinkAudio.currentTime = 0;
    } catch (_) {}
  }

  function startThinkMusic() {
    stopThinkMusic();
    if (!state.musicEnabled) return;
    try {
      thinkAudio.currentTime = 0;
      thinkAudio.play().catch(() => {});
    } catch (_) {}
  }

  const sfx = {
    open: () => playSound("open"),
    dailyDouble: () => playSound("dailyDouble"),
    correct: () => playSound("correct"),
    wrong: () => playSound("wrong"),
    timeUp: () => playSound("timeUp")
  };

  function pickDailyDouble() {
    const numCols = state.deck?.categories?.length || 5;
    const col = Math.floor(Math.random() * numCols);
    const row = Math.floor(Math.random() * 3) + 1; // rows 1..3 ($200-$400)
    state.dailyDoubleKey = `${col}-${row}`;
  }

  function saveState() {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    } catch (_) {}
  }

  function loadState() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) {
        pickDailyDouble();
        return;
      }
      const parsed = JSON.parse(raw);
      if (parsed && parsed.deck && Array.isArray(parsed.deck.categories)) {
        state = { ...state, ...parsed };
      }
    } catch (_) {
      pickDailyDouble();
    }
  }

  function populatePresetSelect() {
    presetSelect.innerHTML = "";
    Object.entries(PRESET_DECKS).forEach(([key, deck]) => {
      const opt = document.createElement("option");
      opt.value = key;
      opt.textContent = deck.name;
      presetSelect.appendChild(opt);
    });
    const customOpt = document.createElement("option");
    customOpt.value = "custom";
    customOpt.textContent = "Custom Board";
    presetSelect.appendChild(customOpt);
    presetSelect.value = state.deckKey;
  }

  function renderScoreboard() {
    scoreboardEl.innerHTML = "";
    state.players.forEach((player, idx) => {
      const card = document.createElement("div");
      card.className = `player-card${idx === state.activePlayerIdx ? " active-turn" : ""}`;
      card.addEventListener("click", (e) => {
        if (e.target.closest("button")) return;
        state.activePlayerIdx = idx;
        saveState();
        renderScoreboard();
      });

      const info = document.createElement("div");
      info.className = "player-info";
      const nameEl = document.createElement("div");
      nameEl.className = "player-name";
      nameEl.textContent = player.name;

      const scoreEl = document.createElement("div");
      scoreEl.className = `player-score${player.score < 0 ? " negative" : ""}`;
      scoreEl.textContent = `${player.score < 0 ? "-" : ""}$${Math.abs(player.score)}`;

      info.append(nameEl, scoreEl);

      const nudge = document.createElement("div");
      nudge.className = "player-nudge";
      const plusBtn = document.createElement("button");
      plusBtn.type = "button";
      plusBtn.className = "nudge-btn";
      plusBtn.textContent = "+100";
      plusBtn.onclick = () => {
        player.score += 100;
        saveState();
        renderScoreboard();
      };

      const minusBtn = document.createElement("button");
      minusBtn.type = "button";
      minusBtn.className = "nudge-btn";
      minusBtn.textContent = "-100";
      minusBtn.onclick = () => {
        player.score -= 100;
        saveState();
        renderScoreboard();
      };

      nudge.append(plusBtn, minusBtn);
      card.append(info, nudge);
      scoreboardEl.appendChild(card);
    });
  }

  function renderBoard() {
    boardEl.innerHTML = "";
    const numCols = state.deck.categories.length;
    boardEl.style.gridTemplateColumns = `repeat(${numCols}, 1fr)`;

    // Category Headers
    state.deck.categories.forEach((cat) => {
      const header = document.createElement("div");
      header.className = "cat-header";
      header.textContent = cat.title;
      boardEl.appendChild(header);
    });

    // Clue Tiles (5 rows x N cols)
    for (let row = 0; row < 5; row++) {
      for (let col = 0; col < numCols; col++) {
        const key = `${col}-${row}`;
        const used = Boolean(state.usedTiles[key]);
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = `clue-tile${used ? " used" : ""}`;
        btn.disabled = used;
        btn.textContent = `$${VALUES[row]}`;
        btn.addEventListener("click", () => openTile(col, row));
        boardEl.appendChild(btn);
      }
    }
  }

  function stopTimer() {
    if (timerInterval) {
      clearInterval(timerInterval);
      timerInterval = null;
    }
    stopThinkMusic();
  }

  function startTimer() {
    stopTimer();
    const secs = Number(state.timerSeconds);
    if (!secs) {
      modalTimer.classList.add("hidden");
      return;
    }
    let remaining = secs;
    modalTimer.classList.remove("hidden", "danger");
    modalTimer.textContent = remaining;
    startThinkMusic();

    timerInterval = setInterval(() => {
      remaining -= 1;
      modalTimer.textContent = remaining;
      if (remaining <= 5 && remaining > 0) {
        modalTimer.classList.add("danger");
      }
      if (remaining <= 0) {
        stopTimer();
        modalTimer.textContent = "TIME";
        sfx.timeUp();
      }
    }, 1000);
  }

  function renderAwardButtons() {
    awardRow.innerHTML = "";
    const pts = activeTile.wager ?? activeTile.value;

    state.players.forEach((player, idx) => {
      const group = document.createElement("div");
      group.className = "award-group";

      const label = document.createElement("span");
      label.className = "award-player-label";
      label.textContent = player.name;

      const winBtn = document.createElement("button");
      winBtn.type = "button";
      winBtn.className = "btn btn-green";
      winBtn.textContent = `+$${pts}`;
      winBtn.onclick = () => {
        sfx.correct();
        player.score += pts;
        state.activePlayerIdx = idx;
        finishTile();
      };

      const loseBtn = document.createElement("button");
      loseBtn.type = "button";
      loseBtn.className = "btn btn-red";
      loseBtn.textContent = `-$${pts}`;
      loseBtn.onclick = () => {
        sfx.wrong();
        player.score -= pts;
        saveState();
        renderScoreboard();
      };

      group.append(label, winBtn, loseBtn);
      awardRow.appendChild(group);
    });

    const passBtn = document.createElement("button");
    passBtn.type = "button";
    passBtn.className = "btn btn-ghost";
    passBtn.textContent = "Pass / No Points";
    passBtn.onclick = finishTile;
    awardRow.appendChild(passBtn);
  }

  function openTile(col, row) {
    const key = `${col}-${row}`;
    const cat = state.deck.categories[col];
    const item = cat.clues[row];
    const value = VALUES[row];
    const isDD = key === state.dailyDoubleKey;

    activeTile = { col, row, key, value, isDailyDouble: isDD, wager: null, item };

    modalCategory.textContent = cat.title;
    modalValue.textContent = `$${value}`;
    clueText.textContent = item.clue;
    answerText.textContent = item.answer;
    answerBox.classList.add("hidden");
    $("clueTranslateBox").classList.add("hidden");
    revealAnswerBtn.classList.remove("hidden");

    if (isDD) {
      sfx.dailyDouble();
      dailyDoubleBadge.classList.remove("hidden");
      wagerView.classList.remove("hidden");
      clueView.classList.add("hidden");
      modalFooter.classList.add("hidden");
      modalTimer.classList.add("hidden");

      wagerPlayerSelect.innerHTML = "";
      state.players.forEach((p, idx) => {
        const opt = document.createElement("option");
        opt.value = String(idx);
        opt.textContent = `${p.name} ($${p.score})`;
        wagerPlayerSelect.appendChild(opt);
      });
      wagerPlayerSelect.value = String(state.activePlayerIdx);
      wagerInput.value = String(Math.max(value, 400));
    } else {
      sfx.open();
      dailyDoubleBadge.classList.add("hidden");
      wagerView.classList.add("hidden");
      clueView.classList.remove("hidden");
      modalFooter.classList.remove("hidden");
      renderAwardButtons();
      startTimer();
    }

    clueModal.classList.remove("hidden");
  }

  function lockDailyDoubleWager() {
    const idx = Number(wagerPlayerSelect.value);
    const wager = Math.max(50, Number(wagerInput.value) || activeTile.value);
    state.activePlayerIdx = idx;
    activeTile.wager = wager;
    modalValue.textContent = `$${wager} WAGER`;

    wagerView.classList.add("hidden");
    clueView.classList.remove("hidden");
    modalFooter.classList.remove("hidden");
    renderAwardButtons();
    renderScoreboard();
    startTimer();
  }

  function finishTile() {
    if (activeTile) {
      state.usedTiles[activeTile.key] = true;
    }
    closeClueModal();
    saveState();
    renderScoreboard();
    renderBoard();
  }

  function closeClueModal() {
    stopTimer();
    clueModal.classList.add("hidden");
    activeTile = null;
  }

  // Final Jeopardy
  function openFinalJeopardy() {
    const finalData = state.deck.final || PRESET_DECKS.tony_sanctuary.final;
    finalCategoryBadge.textContent = finalData.category;
    finalClueText.textContent = finalData.clue;
    finalAnswerText.textContent = finalData.answer;

    finalWagerStage.classList.remove("hidden");
    finalClueStage.classList.add("hidden");
    finalAnswerBox.classList.add("hidden");
    $("finalTranslateBox").classList.add("hidden");
    finalResolveList.classList.add("hidden");

    finalWagersList.innerHTML = "";
    state.players.forEach((p, idx) => {
      const row = document.createElement("div");
      row.className = "final-player-row";
      row.innerHTML = `
        <strong>${p.name} (Score: $${p.score})</strong>
        <label>Wager: <input type="number" class="final-wager-input" data-idx="${idx}" min="0" step="50" value="${Math.max(0, Math.min(500, p.score))}" /></label>
      `;
      finalWagersList.appendChild(row);
    });

    finalModal.classList.remove("hidden");
  }

  function revealFinalClue() {
    sfx.open();
    const wagers = [...document.querySelectorAll(".final-wager-input")].map((el) =>
      Math.max(0, Number(el.value) || 0)
    );

    finalWagerStage.classList.add("hidden");
    finalClueStage.classList.remove("hidden");

    finalResolveList.innerHTML = "";
    state.players.forEach((p, idx) => {
      const wager = wagers[idx] || 0;
      const box = document.createElement("div");
      box.className = "final-player-row";
      box.innerHTML = `<strong>${p.name} (Wager: $${wager})</strong>`;

      const btns = document.createElement("div");
      btns.style.display = "flex";
      btns.style.gap = "6px";

      const okBtn = document.createElement("button");
      okBtn.type = "button";
      okBtn.className = "btn btn-green";
      okBtn.textContent = `+$${wager}`;
      okBtn.onclick = () => {
        sfx.correct();
        p.score += wager;
        okBtn.disabled = true;
        badBtn.disabled = true;
        saveState();
        renderScoreboard();
      };

      const badBtn = document.createElement("button");
      badBtn.type = "button";
      badBtn.className = "btn btn-red";
      badBtn.textContent = `-$${wager}`;
      badBtn.onclick = () => {
        sfx.wrong();
        p.score -= wager;
        okBtn.disabled = true;
        badBtn.disabled = true;
        saveState();
        renderScoreboard();
      };

      btns.append(okBtn, badBtn);
      box.appendChild(btns);
      finalResolveList.appendChild(box);
    });
  }

  // Board Editor
  function renderPlayerNameInputs() {
    const count = Math.min(4, Math.max(1, Number(playerCountInput.value) || 2));
    playerCountInput.value = String(count);
    playerNamesInputs.innerHTML = "";
    for (let i = 0; i < count; i++) {
      const inp = document.createElement("input");
      inp.type = "text";
      inp.value = state.players[i]?.name || `Player ${i + 1}`;
      inp.placeholder = `Player ${i + 1}`;
      inp.dataset.pidx = String(i);
      playerNamesInputs.appendChild(inp);
    }
  }

  function openEditor() {
    playerCountInput.value = String(state.players.length);
    renderPlayerNameInputs();

    editorGrid.innerHTML = "";
    state.deck.categories.forEach((cat, col) => {
      const colEl = document.createElement("div");
      colEl.className = "editor-col";

      const catInp = document.createElement("input");
      catInp.type = "text";
      catInp.className = "editor-cat-input";
      catInp.value = cat.title;
      catInp.dataset.col = String(col);
      colEl.appendChild(catInp);

      cat.clues.forEach((item, row) => {
        const cell = document.createElement("div");
        cell.className = "editor-cell";
        cell.innerHTML = `<span class="editor-cell-val">$${VALUES[row]}</span>`;

        const clueArea = document.createElement("textarea");
        clueArea.value = item.clue;
        clueArea.placeholder = "Clue / Prompt";
        clueArea.dataset.col = String(col);
        clueArea.dataset.row = String(row);
        clueArea.dataset.field = "clue";

        const ansArea = document.createElement("textarea");
        ansArea.value = item.answer;
        ansArea.placeholder = "Answer";
        ansArea.dataset.col = String(col);
        ansArea.dataset.row = String(row);
        ansArea.dataset.field = "answer";

        cell.append(clueArea, ansArea);
        colEl.appendChild(cell);
      });

      editorGrid.appendChild(colEl);
    });

    const finalData = state.deck.final || PRESET_DECKS.tony_sanctuary.final;
    editFinalCat.value = finalData.category;
    editFinalClue.value = finalData.clue;
    editFinalAnswer.value = finalData.answer;

    editorModal.classList.remove("hidden");
  }

  function saveEditorChanges() {
    const newPlayers = [...playerNamesInputs.querySelectorAll("input")].map((inp, i) => ({
      name: inp.value.trim() || `Player ${i + 1}`,
      score: state.players[i]?.score ?? 0
    }));
    state.players = newPlayers;
    if (state.activePlayerIdx >= state.players.length) state.activePlayerIdx = 0;

    editorGrid.querySelectorAll(".editor-cat-input").forEach((inp) => {
      const col = Number(inp.dataset.col);
      state.deck.categories[col].title = inp.value.trim() || `Category ${col + 1}`;
    });

    editorGrid.querySelectorAll("textarea").forEach((ta) => {
      const col = Number(ta.dataset.col);
      const row = Number(ta.dataset.row);
      const field = ta.dataset.field;
      state.deck.categories[col].clues[row][field] = ta.value.trim();
    });

    state.deck.final = {
      category: editFinalCat.value.trim() || "FINAL JEOPARDY",
      clue: editFinalClue.value.trim() || "Bonus speaking challenge!",
      answer: editFinalAnswer.value.trim() || "Open-ended"
    };

    state.deckKey = "custom";
    presetSelect.value = "custom";
    saveState();
    renderScoreboard();
    renderBoard();
    editorModal.classList.add("hidden");
  }

  // Event Listeners
  presetSelect.addEventListener("change", () => {
    const key = presetSelect.value;
    if (key === "custom") return;
    state.deckKey = key;
    state.deck = structuredClone(PRESET_DECKS[key]);
    state.usedTiles = {};
    if (DEFAULT_PLAYER_BY_DECK[key] && state.players.length >= 1) {
      state.players[0].name = DEFAULT_PLAYER_BY_DECK[key];
      state.players.forEach((p) => { p.score = 0; });
      state.activePlayerIdx = 0;
    }
    blitzIdx = 0;
    tabooIdx = 0;
    structureTopicIdx = 0;
    pickDailyDouble();
    updateTranslateLabels();
    saveState();
    renderScoreboard();
    renderBoard();
  });

  timerSelect.addEventListener("change", () => {
    state.timerSeconds = Number(timerSelect.value);
    saveState();
  });

  soundToggleBtn.addEventListener("click", () => {
    state.soundEnabled = !state.soundEnabled;
    soundToggleBtn.textContent = state.soundEnabled ? "🔊 Sound On" : "🔇 Sound Off";
    if (state.soundEnabled) sfx.open();
    saveState();
  });

  musicToggleBtn.addEventListener("click", () => {
    state.musicEnabled = !state.musicEnabled;
    musicToggleBtn.textContent = state.musicEnabled ? "🎵 Music On" : "🔇 Music Off";
    if (!state.musicEnabled) {
      stopThinkMusic();
    } else if (!clueModal.classList.contains("hidden") && timerInterval) {
      startThinkMusic();
    }
    saveState();
  });

  $("resetBoardBtn").addEventListener("click", () => {
    state.usedTiles = {};
    state.players.forEach((p) => (p.score = 0));
    pickDailyDouble();
    saveState();
    renderScoreboard();
    renderBoard();
  });

  $("closeModalBtn").addEventListener("click", closeClueModal);
  $("lockWagerBtn").addEventListener("click", lockDailyDoubleWager);
  revealAnswerBtn.addEventListener("click", () => {
    stopTimer();
    answerBox.classList.remove("hidden");
    revealAnswerBtn.classList.add("hidden");
  });

  $("finalJeopardyBtn").addEventListener("click", openFinalJeopardy);
  $("closeFinalBtn").addEventListener("click", () => {
    stopThinkMusic();
    finalModal.classList.add("hidden");
  });
  $("revealFinalClueBtn").addEventListener("click", () => {
    revealFinalClue();
    startThinkMusic();
  });
  $("showFinalAnswerBtn").addEventListener("click", () => {
    stopThinkMusic();
    finalAnswerBox.classList.remove("hidden");
    finalResolveList.classList.remove("hidden");
  });

  $("editBoardBtn").addEventListener("click", openEditor);
  $("closeEditorBtn").addEventListener("click", () => editorModal.classList.add("hidden"));
  playerCountInput.addEventListener("change", renderPlayerNameInputs);
  $("saveEditorBtn").addEventListener("click", saveEditorChanges);

  $("exportJsonBtn").addEventListener("click", () => {
    const blob = new Blob([JSON.stringify(state.deck, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "preply-jeopardy-deck.json";
    a.click();
    URL.revokeObjectURL(url);
  });

  $("importJsonInput").addEventListener("change", (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = () => {
      try {
        const imported = JSON.parse(String(reader.result));
        if (Array.isArray(imported.categories) && imported.categories.length >= 5) {
          state.deck = imported;
          state.deckKey = "custom";
          state.usedTiles = {};
          saveState();
          openEditor();
          renderBoard();
        } else {
          alert("Invalid Jeopardy JSON format (expected at least 5 categories).");
        }
      } catch {
        alert("Could not parse JSON file.");
      }
    };
    reader.readAsText(file);
  });

  document.addEventListener("keydown", (e) => {
    if (clueModal.classList.contains("hidden")) return;
    if (e.key === "Escape") closeClueModal();
    if (e.code === "Space" && wagerView.classList.contains("hidden")) {
      e.preventDefault();
      stopTimer();
      answerBox.classList.remove("hidden");
      revealAnswerBtn.classList.add("hidden");
    }
  });

  // =========================


  // =========================
  // Tony B Bonus Round Data
  // =========================
  const TONY_BLITZ_PROMPTS = [
    "Name 5 FILM GENRES or ICONIC BLOCKBUSTERS in 15 seconds!",
    "Name 5 EMOTIONS or PERSONALITY ADJECTIVES (e.g. suspicious, envious, affectionate) in 15 seconds!",
    "Name 5 CULINARY ITEMS or DISHES you can describe in English in 15 seconds!",
    "Name 5 WAYS TO UNWIND or SPEND YOUR DOWNTIME in 15 seconds!",
    "Name 5 THINGS THAT MAKE A MOVIE GREAT (e.g. character arc, stakes, pacing) in 15 seconds!",
    "Name 5 COLLECTIVE ANIMAL NOUNS or ENGLISH IDIOMS in 15 seconds!"
  ];

  const TONY_BLITZ_SPANISH = [
    "¡Di 5 géneros de cine o grandes taquillazos en 15 segundos!",
    "¡Di 5 emociones o adjetivos de personalidad en 15 segundos!",
    "¡Di 5 platos o alimentos que puedas describir en inglés en 15 segundos!",
    "¡Di 5 formas de desconectar (unwind) en tu tiempo libre en 15 segundos!",
    "¡Di 5 elementos que hacen grande a una película en 15 segundos!",
    "¡Di 5 sustantivos colectivos de animales o modismos en inglés en 15 segundos!"
  ];

  function isTonyDeck() {
    return state.deckKey === "tony_sanctuary" || state.deckKey === "tony_cinema";
  }

  function getBlitzPrompts() {
    return TONY_BLITZ_PROMPTS;
  }

  function getBlitzDurationMs() {
    return 15000;
  }

  const blitzModal = $("blitzModal");
  const blitzTimerEl = $("blitzTimer");
  const blitzCounterLabel = $("blitzCounterLabel");
  const blitzPromptEl = $("blitzPrompt");
  const blitzDots = [...document.querySelectorAll("#blitzDots .blitz-dot")];
  const blitzAwardRow = $("blitzAwardRow");

  let blitzIdx = 0;
  let blitzInterval = null;
  let blitzRemainingMs = 10000;

  function stopBlitzTimer() {
    if (blitzInterval) {
      clearInterval(blitzInterval);
      blitzInterval = null;
    }
  }

  function renderBlitzPrompt() {
    stopBlitzTimer();
    const prompts = getBlitzPrompts();
    if (blitzIdx >= prompts.length) blitzIdx = 0;
    blitzRemainingMs = getBlitzDurationMs();
    blitzTimerEl.textContent = (blitzRemainingMs / 1000).toFixed(1);
    blitzTimerEl.classList.remove("danger");
    blitzCounterLabel.textContent = `Prompt ${blitzIdx + 1} of ${prompts.length}`;
    blitzPromptEl.textContent = prompts[blitzIdx];
    const blitzBadge = blitzModal?.querySelector(".dd-badge");
    if (blitzBadge) blitzBadge.textContent = `5 IN ${Math.round(blitzRemainingMs / 1000)} SECONDS`;
    const startBtn = $("blitzStartBtn");
    if (startBtn) {
      startBtn.textContent = "▶ Start 15s Timer";
    }
    $("blitzTranslateBox").classList.add("hidden");
    blitzDots.forEach((d) => d.classList.remove("checked"));
  }

  function renderBlitzAwardButtons() {
    blitzAwardRow.innerHTML = "";
    state.players.forEach((player, idx) => {
      const group = document.createElement("div");
      group.className = "award-group";

      const label = document.createElement("span");
      label.className = "award-player-label";
      label.textContent = player.name;

      const winBtn = document.createElement("button");
      winBtn.type = "button";
      winBtn.className = "btn btn-green";
      winBtn.textContent = "+$300 (5/5)";
      winBtn.onclick = () => {
        sfx.correct();
        player.score += 300;
        state.activePlayerIdx = idx;
        saveState();
        renderScoreboard();
      };

      const partialBtn = document.createElement("button");
      partialBtn.type = "button";
      partialBtn.className = "btn btn-secondary";
      partialBtn.textContent = "+$100";
      partialBtn.onclick = () => {
        sfx.open();
        player.score += 100;
        saveState();
        renderScoreboard();
      };

      group.append(label, winBtn, partialBtn);
      blitzAwardRow.appendChild(group);
    });
  }

  function startBlitzTimer() {
    stopBlitzTimer();
    blitzRemainingMs = getBlitzDurationMs();
    blitzTimerEl.classList.remove("danger");
    sfx.open();

    blitzInterval = setInterval(() => {
      blitzRemainingMs -= 100;
      if (blitzRemainingMs <= 3000 && blitzRemainingMs > 0) {
        blitzTimerEl.classList.add("danger");
      }
      if (blitzRemainingMs <= 0) {
        stopBlitzTimer();
        blitzTimerEl.textContent = "0.0";
        sfx.timeUp();
        return;
      }
      blitzTimerEl.textContent = (blitzRemainingMs / 1000).toFixed(1);
    }, 100);
  }

  blitzDots.forEach((dot) => {
    dot.addEventListener("click", () => {
      dot.classList.toggle("checked");
      playTone(660, 0.06, "triangle");
    });
  });

  $("blitzBtn").addEventListener("click", () => {
    renderBlitzPrompt();
    renderBlitzAwardButtons();
    blitzModal.classList.remove("hidden");
  });

  $("closeBlitzBtn").addEventListener("click", () => {
    stopBlitzTimer();
    blitzModal.classList.add("hidden");
  });

  $("blitzStartBtn").addEventListener("click", startBlitzTimer);
  $("blitzNextBtn").addEventListener("click", () => {
    const prompts = getBlitzPrompts();
    blitzIdx = (blitzIdx + 1) % prompts.length;
    renderBlitzPrompt();
  });

  // =========================
  // Bonus Round 2: Taboo
  // =========================


  // =========================
  // Bonus Round 2: Taboo (Heads Up Style)
  // =========================
  const TONY_TABOO_CARDS = [
    { target: "BOTTLENECK 🧠", forbidden: ["traffic", "slow", "translate", "Spanish"], spanish: "Cuello de botella: el atasco mental que frena la fluidez al traducir." },
    { target: "MEATBALLS 🍝", forbidden: ["meat", "ball", "beef", "pork"], spanish: "Albóndigas: carne picada (minced) con forma esférica (spherical)." },
    { target: "CINEMATIC RESTRAINT 🎬", forbidden: ["movie", "film", "show", "horror"], spanish: "Contención cinematográfica: sugerir sin mostrarlo todo." },
    { target: "A MURDER OF CROWS 🐦‍⬛", forbidden: ["bird", "black", "kill", "group"], spanish: "Una bandada de cuervos (sustantivo colectivo poético)." },
    { target: "UNPLUG 📵", forbidden: ["phone", "screen", "disconnect", "cinema"], spanish: "Desconectar temporalmente de las pantallas y notificaciones." },
    { target: "CHARACTER ARC 📈", forbidden: ["hero", "story", "change", "journey"], spanish: "Arco de transformación de un personaje a lo largo de la película." },
    { target: "INFATUATED 💘", forbidden: ["love", "crush", "romantic", "obsessed"], spanish: "Encaprichado o enamorado ciegamente de forma repentina." },
    { target: "FOMO 📱", forbidden: ["fear", "missing", "out", "envious"], spanish: "Miedo a perderse algo que otros están disfrutando." },
    { target: "TAKE PRIDE IN ✨", forbidden: ["proud", "orgullo", "work", "arrogant"], spanish: "Esmerarse y sentir satisfacción sana por el trabajo bien hecho." },
    { target: "UNWIND 🛋️", forbidden: ["relax", "stress", "home", "office"], spanish: "Soltar la tensión y relajarse después de la jornada." }
  ];

  function getTabooCards() {
    return TONY_TABOO_CARDS;
  }

  const tabooModal = $("tabooModal");
  const tabooTimerEl = $("tabooTimer");
  const tabooRoundScoreEl = $("tabooRoundScore");
  const tabooTargetEl = $("tabooTarget");
  const tabooListEl = $("tabooList");
  const tabooAwardRow = $("tabooAwardRow");

  let tabooIdx = 0;
  let tabooRoundPoints = 0;
  let tabooInterval = null;
  let tabooRemaining = 45;

  function stopTabooTimer() {
    if (tabooInterval) {
      clearInterval(tabooInterval);
      tabooInterval = null;
    }
  }

  function renderTabooCard() {
    const cards = getTabooCards();
    if (tabooIdx >= cards.length) tabooIdx = 0;
    const card = cards[tabooIdx];
    tabooTargetEl.textContent = card.target;
    $("tabooTranslateBox").classList.add("hidden");
    const forbiddenLabel = document.querySelector(".taboo-forbidden-label");
    if (forbiddenLabel) {
      forbiddenLabel.textContent = state.deckKey === "abdi" ? "SPEAKING HELPER CLUES" : "FORBIDDEN WORDS";
    }
    tabooListEl.innerHTML = "";
    card.forbidden.forEach((word) => {
      const li = document.createElement("li");
      li.textContent = word;
      tabooListEl.appendChild(li);
    });
    tabooRoundScoreEl.textContent = `Round: ${tabooRoundPoints < 0 ? "-" : ""}$${Math.abs(tabooRoundPoints)}`;
  }

  function renderTabooAwardButtons() {
    tabooAwardRow.innerHTML = "";
    state.players.forEach((player, idx) => {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "btn btn-gold";
      btn.textContent = `Bank Round to ${player.name}`;
      btn.onclick = () => {
        sfx.correct();
        player.score += tabooRoundPoints;
        state.activePlayerIdx = idx;
        tabooRoundPoints = 0;
        renderTabooCard();
        saveState();
        renderScoreboard();
      };
      tabooAwardRow.appendChild(btn);
    });
  }

  function startTabooTimer() {
    stopTabooTimer();
    tabooRemaining = 45;
    tabooTimerEl.textContent = "45";
    tabooTimerEl.classList.remove("danger");
    sfx.open();

    tabooInterval = setInterval(() => {
      tabooRemaining -= 1;
      tabooTimerEl.textContent = String(tabooRemaining);
      if (tabooRemaining <= 10 && tabooRemaining > 0) {
        tabooTimerEl.classList.add("danger");
      }
      if (tabooRemaining <= 0) {
        stopTabooTimer();
        tabooTimerEl.textContent = "TIME";
        sfx.timeUp();
      }
    }, 1000);
  }

  $("tabooBtn").addEventListener("click", () => {
    stopTabooTimer();
    tabooRemaining = 45;
    tabooTimerEl.textContent = "45";
    tabooTimerEl.classList.remove("danger");
    tabooRoundPoints = 0;
    renderTabooCard();
    renderTabooAwardButtons();
    tabooModal.classList.remove("hidden");
  });

  $("closeTabooBtn").addEventListener("click", () => {
    stopTabooTimer();
    tabooModal.classList.add("hidden");
  });

  $("tabooStartBtn").addEventListener("click", startTabooTimer);
  $("tabooGotItBtn").addEventListener("click", () => {
    sfx.correct();
    tabooRoundPoints += 200;
    const cards = getTabooCards();
    tabooIdx = (tabooIdx + 1) % cards.length;
    renderTabooCard();
  });

  $("tabooBuzzBtn").addEventListener("click", () => {
    sfx.wrong();
    tabooRoundPoints -= 100;
    const cards = getTabooCards();
    tabooIdx = (tabooIdx + 1) % cards.length;
    renderTabooCard();
  });

  $("tabooNextBtn").addEventListener("click", () => {
    const cards = getTabooCards();
    tabooIdx = (tabooIdx + 1) % cards.length;
    renderTabooCard();
  });

  // =========================
  // Slow Speech (TTS) & Afaan Oromoo / Italian Translation Helper
  // =========================
  function speakSlowEnglish(text) {
    if (!("speechSynthesis" in window)) return;
    try {
      window.speechSynthesis.cancel();
      const clean = String(text || "").replace(/[🟢🔴⏰🍕🇪🇹🏙️🌍📅❌✅]/g, "").trim();
      if (!clean) return;
      const u = new SpeechSynthesisUtterance(clean);
      u.lang = "en-US";
      u.rate = state.deckKey === "abdi" ? 0.78 : 0.92;
      window.speechSynthesis.speak(u);
    } catch (_) {}
  }

  if ($("speakClueBtn")) {
    $("speakClueBtn").addEventListener("click", () => {
      const ansVisible = !answerBox.classList.contains("hidden");
      const textToRead = ansVisible ? `${clueText.textContent}. ${answerText.textContent}` : clueText.textContent;
      speakSlowEnglish(textToRead);
    });
  }

  if ($("speakFinalBtn")) {
    $("speakFinalBtn").addEventListener("click", () => {
      const ansVisible = !finalAnswerBox.classList.contains("hidden");
      const textToRead = ansVisible ? `${finalClueText.textContent}. ${finalAnswerText.textContent}` : finalClueText.textContent;
      speakSlowEnglish(textToRead);
    });
  }

  // =========================
  // Language Hint & Translation Helpers (Spanish for Tony B)
  // =========================
  function updateTranslateLabels() {
    const badgeText = "🇪🇸 Español";
    const btnFullText = "🇪🇸 Pista en Español";
    const btnShortText = "🇪🇸 Español";

    ["clueTranslateLabel", "finalTranslateLabel", "blitzTranslateLabel", "tabooTranslateLabel"].forEach((id) => {
      const el = $(id);
      if (el) el.textContent = badgeText;
    });
    if ($("translateClueBtn")) $("translateClueBtn").textContent = btnFullText;
    if ($("translateFinalBtn")) $("translateFinalBtn").textContent = btnFullText;
    if ($("translateBlitzBtn")) $("translateBlitzBtn").textContent = btnShortText;
    if ($("translateTabooBtn")) $("translateTabooBtn").textContent = btnShortText;
  }

  const translationCache = new Map();

  async function translateText(text, targetLang = "es") {
    const clean = (text || "").trim();
    if (!clean) return "";
    const cacheKey = `${targetLang}:${clean}`;
    if (translationCache.has(cacheKey)) return translationCache.get(cacheKey);

    try {
      const url = `https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=${targetLang}&dt=t&q=${encodeURIComponent(clean)}`;
      const res = await fetch(url);
      if (res.ok) {
        const data = await res.json();
        const translated = (data?.[0] || []).map((part) => part?.[0] || "").join("").trim();
        if (translated) {
          translationCache.set(cacheKey, translated);
          return translated;
        }
      }
    } catch (_) {}

    try {
      const url = `https://api.mymemory.translated.net/get?q=${encodeURIComponent(clean)}&langpair=en|${targetLang}`;
      const res = await fetch(url);
      if (res.ok) {
        const data = await res.json();
        const translated = data?.responseData?.translatedText?.trim();
        if (translated) {
          translationCache.set(cacheKey, translated);
          return translated;
        }
      }
    } catch (_) {}

    return null;
  }

  async function handleTranslateClick(btn, boxEl, textEl, getSourceText, getDirectHint) {
    if (!boxEl.classList.contains("hidden")) {
      boxEl.classList.add("hidden");
      return;
    }
    updateTranslateLabels();

    if (typeof getDirectHint === "function") {
      const direct = getDirectHint();
      if (direct) {
        textEl.textContent = direct;
        boxEl.classList.remove("hidden");
        return;
      }
    }

    const targetLang = "es";
    const source = getSourceText();
    const originalLabel = btn.textContent;
    btn.disabled = true;
    btn.textContent = "⏳ Translating...";
    const translated = await translateText(source, targetLang);
    btn.disabled = false;
    btn.textContent = originalLabel;

    if (translated) {
      textEl.textContent = translated;
      boxEl.classList.remove("hidden");
    } else {
      window.open(`https://translate.google.com/?sl=en&tl=${targetLang}&text=${encodeURIComponent(source)}&op=translate`, "_blank");
    }
  }

  $("translateClueBtn").addEventListener("click", () => {
    const clue = clueText.textContent;
    const ansVisible = !answerBox.classList.contains("hidden");
    const source = ansVisible ? `${clue}\n\nAnswer: ${answerText.textContent}` : clue;
    handleTranslateClick(
      $("translateClueBtn"),
      $("clueTranslateBox"),
      $("clueTranslateText"),
      () => source,
      () => activeTile?.item?.spanish
    );
  });

  $("translateFinalBtn").addEventListener("click", () => {
    handleTranslateClick(
      $("translateFinalBtn"),
      $("finalTranslateBox"),
      $("finalTranslateText"),
      () => finalClueText.textContent,
      () => state.deck?.final?.spanish
    );
  });

  $("translateBlitzBtn").addEventListener("click", () => {
    handleTranslateClick(
      $("translateBlitzBtn"),
      $("blitzTranslateBox"),
      $("blitzTranslateText"),
      () => blitzPromptEl.textContent,
      () => TONY_BLITZ_SPANISH[blitzIdx]
    );
  });

  $("translateTabooBtn").addEventListener("click", () => {
    const cards = getTabooCards();
    const card = cards[tabooIdx];
    const source = `${card.target} (${card.forbidden.join(", ")})`;
    handleTranslateClick(
      $("translateTabooBtn"),
      $("tabooTranslateBox"),
      $("tabooTranslateText"),
      () => source,
      () => card?.spanish
    );
  });


  // =========================
  // Bonus Round 3: Structure Sprint (Tony's 30s–60s Concise Fluency Drills)
  // =========================
  const TONY_STRUCTURE_TOPICS = [
    {
      topic: "Modern Cinema & Commercialization (30s–45s Pitch) 🎬",
      framework: "STANCE • HABITS • FORMAT",
      phases: ["1. CORE STANCE", "2. CONSUMER HABITS", "3. FORMAT & CONCLUSION"],
      tips: [
        "Stance: 'Commercialization is an issue because modern films often lack a proper character arc.'",
        "Habits: 'Changing consumer habits mean audiences want fast entertainment rather than slow character development.'",
        "Format: 'Those habits don't fit the traditional cinema format—everything gets squeezed to maximize revenue.'"
      ]
    },
    {
      topic: "Cinema as a Digital Sanctuary 📵",
      framework: "NOISE • UNPLUG • COMMUNAL",
      phases: ["1. DIGITAL NOISE", "2. UNPLUGGING", "3. COMMUNAL IMMERSION"],
      tips: [
        "Digital Noise: Explain how constant notifications at home make it tempting to pause and check your phone.",
        "Unplugging: 'Going to the cinema allows me to unplug from my phone for two uninterrupted hours.'",
        "Communal: 'Sharing a dark room with people who made an effort to be there makes it truly immersive.'"
      ]
    },
    {
      topic: "Dinner Party with 4 Cinema Characters 🍽️",
      framework: "GUESTS • DYNAMIC • QUESTION",
      phases: ["1. THE GUEST LIST", "2. TABLE DYNAMIC", "3. ONE BIG QUESTION"],
      tips: [
        "Guests: Name your 4 characters (e.g. Mark Watney from The Martian, Joaquin Phoenix's Joker, etc.) and why.",
        "Dynamic: Imagine how those very different personalities would interact over dinner!",
        "Question: What is the one question you would ask them before the night ends?"
      ]
    },
    {
      topic: "'The Zone of Interest' & Cinematic Restraint 🎥",
      framework: "CONTRAST • SOUND • IMPACT",
      phases: ["1. THE CONTRAST", "2. AUDIO & RESTRAINT", "3. WHY IT STAYS WITH YOU"],
      tips: [
        "Contrast: Describe the idyllic family garden right beside the walls of Auschwitz.",
        "Restraint: Explain how the camera never enters the camp—the eerie power comes from sound and suggestion.",
        "Impact: Use 'chilling', 'cinematic restraint', and 'suppress' in your wrap-up!"
      ]
    },
    {
      topic: "Pride vs. 'Orgullo' & Collective Nouns 🦁",
      framework: "FALSE FRIEND • CRAFT • IDIOM",
      phases: ["1. SPANISH 'ORGULLO'", "2. ENGLISH 'PRIDE'", "3. FOLKLORE IDIOM"],
      tips: [
        "False Friend: Explain why Spanish 'orgullo' often carries a stubborn or negative tone.",
        "Craft: Contrast that with 'taking pride in your work'—craftsmanship, diligence, and self-respect.",
        "Idiom: Drop in 'a pride of lions', 'a murder of crows', or 'a gaggle of geese'!"
      ]
    },
    {
      topic: "Weekend Downtime in Valencia 🚴‍♂️",
      framework: "WORKWEEK • SATURDAY • SUNDAY",
      phases: ["1. UNWINDING", "2. CYCLING & PADEL", "3. DOWNTIME"],
      tips: [
        "Unwinding: Describe finishing work and needing to completely unwind.",
        "Active: Talk about your Saturday cycling group and playing padel.",
        "Downtime: Use 'I look forward to doing...' (gerund!) and 'downtime' cleanly!"
      ]
    }
  ];

  function getStructureTopics() {
    return TONY_STRUCTURE_TOPICS;
  }

  const structureModal = $("structureModal");
  const structureTimerEl = $("structureTimer");
  const structureFrameworkBadge = $("structureFrameworkBadge");
  const structureCounterLabel = $("structureCounterLabel");
  const structurePromptEl = $("structurePrompt");
  const structureTipEl = $("structureTip");
  const structurePhasesWrap = $("structurePhases");
  const structurePhaseBtns = [...document.querySelectorAll("#structurePhases .phase-pill")];
  const structureAwardRow = $("structureAwardRow");
  const fillerCountEl = $("fillerCount");

  let structureTopicIdx = 0;
  let structurePhaseIdx = 0;
  let structureInterval = null;
  let structureRemaining = 60;
  let fillerSlips = 0;

  function stopStructureTimer() {
    if (structureInterval) {
      clearInterval(structureInterval);
      structureInterval = null;
    }
  }

  function renderStructureView() {
    stopStructureTimer();
    const topics = getStructureTopics();
    if (structureTopicIdx >= topics.length) structureTopicIdx = 0;
    structureRemaining = 60;
    structureTimerEl.textContent = "60";
    structureTimerEl.classList.remove("danger");

    const item = topics[structureTopicIdx];
    structureFrameworkBadge.textContent = item.framework;
    structureCounterLabel.textContent = `Topic ${structureTopicIdx + 1} of ${topics.length}`;
    structurePromptEl.textContent = item.topic;
    structureTipEl.textContent = item.tips[structurePhaseIdx];

    structurePhaseBtns.forEach((btn, i) => {
      btn.textContent = item.phases[i];
      btn.classList.toggle("active", i === structurePhaseIdx);
      btn.classList.toggle("done", i < structurePhaseIdx);
    });
  }

  function renderStructureAwardButtons() {
    structureAwardRow.innerHTML = "";
    state.players.forEach((player, idx) => {
      const group = document.createElement("div");
      group.className = "award-group";

      const label = document.createElement("span");
      label.className = "award-player-label";
      label.textContent = player.name;

      const phaseBtn = document.createElement("button");
      phaseBtn.type = "button";
      phaseBtn.className = "btn btn-secondary";
      phaseBtn.textContent = "+$150 (Phase)";
      phaseBtn.onclick = () => {
        sfx.open();
        player.score += 150;
        saveState();
        renderScoreboard();
      };

      const cleanBtn = document.createElement("button");
      cleanBtn.type = "button";
      cleanBtn.className = "btn btn-green";
      cleanBtn.textContent = "+$500 (Clean Sprint!)";
      cleanBtn.onclick = () => {
        sfx.correct();
        player.score += 500;
        state.activePlayerIdx = idx;
        saveState();
        renderScoreboard();
      };

      group.append(label, phaseBtn, cleanBtn);
      structureAwardRow.appendChild(group);
    });
  }

  function startStructureTimer() {
    stopStructureTimer();
    structureRemaining = 60;
    structureTimerEl.textContent = "60";
    structureTimerEl.classList.remove("danger");
    sfx.open();

    structureInterval = setInterval(() => {
      structureRemaining -= 1;
      structureTimerEl.textContent = String(structureRemaining);
      if (structureRemaining <= 5 && structureRemaining > 0) {
        structureTimerEl.classList.add("danger");
      }
      if (structureRemaining <= 0) {
        stopStructureTimer();
        structureTimerEl.textContent = "TIME";
        sfx.timeUp();
      }
    }, 1000);
  }

  structurePhaseBtns.forEach((btn) => {
    btn.addEventListener("click", () => {
      structurePhaseIdx = Number(btn.dataset.phase);
      renderStructureView();
    });
  });

  $("structureBtn").addEventListener("click", () => {
    structurePhaseIdx = 0;
    fillerSlips = 0;
    fillerCountEl.textContent = "0";
    renderStructureView();
    renderStructureAwardButtons();
    structureModal.classList.remove("hidden");
  });

  $("closeStructureBtn").addEventListener("click", () => {
    stopStructureTimer();
    structureModal.classList.add("hidden");
  });

  $("structureStartBtn").addEventListener("click", startStructureTimer);

  $("structureNextPhaseBtn").addEventListener("click", () => {
    structurePhaseIdx = (structurePhaseIdx + 1) % 3;
    renderStructureView();
  });

  $("structureNextTopicBtn").addEventListener("click", () => {
    const topics = getStructureTopics();
    structureTopicIdx = (structureTopicIdx + 1) % topics.length;
    structurePhaseIdx = 0;
    fillerSlips = 0;
    fillerCountEl.textContent = "0";
    renderStructureView();
  });

  $("fillerPlusBtn").addEventListener("click", () => {
    sfx.wrong();
    fillerSlips += 1;
    fillerCountEl.textContent = String(fillerSlips);
  });

  $("fillerResetBtn").addEventListener("click", () => {
    fillerSlips = 0;
    fillerCountEl.textContent = "0";
  });

  // =========================
  // How to Play Modal (Afaan Oromoo - Qubee)
  // =========================
  const howToPlayModal = $("howToPlayModal");
  if ($("howToPlayBtn") && howToPlayModal) {
    $("howToPlayBtn").addEventListener("click", () => {
      sfx.open();
      howToPlayModal.classList.remove("hidden");
    });
  }
  if ($("closeHowToPlayBtn") && howToPlayModal) {
    $("closeHowToPlayBtn").addEventListener("click", () => {
      howToPlayModal.classList.add("hidden");
    });
  }
  if ($("startFromHowToBtn") && howToPlayModal) {
    $("startFromHowToBtn").addEventListener("click", () => {
      sfx.correct();
      howToPlayModal.classList.add("hidden");
    });
  }
  if ($("speakHowToPhraseBtn")) {
    $("speakHowToPhraseBtn").addEventListener("click", () => {
      speakSlowEnglish("Could I have Cinema and Character Arcs for three hundred, please?");
    });
  }

  // Init
  loadState();
  populatePresetSelect();
  updateTranslateLabels();
  timerSelect.value = String(state.timerSeconds);
  soundToggleBtn.textContent = state.soundEnabled ? "🔊 Sound On" : "🔇 Sound Off";
  musicToggleBtn.textContent = state.musicEnabled ? "🎵 Music On" : "🔇 Music Off";
  renderScoreboard();
  renderBoard();
})();
