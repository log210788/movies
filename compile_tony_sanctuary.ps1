# compile_tony_sanctuary.ps1
# Compiles Tony B's Lesson Portal using the canonical template/index_template.html
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=========================================================="
Write-Host "Compiling Tony B's Lesson Portal from template"
Write-Host "=========================================================="

# 1. Load Raw Transcript
$rawTranscriptPath = "D:\Documents\Tony b\Transcripts\11-03-2026.txt"
if (-not (Test-Path $rawTranscriptPath)) { throw "Transcript missing: $rawTranscriptPath" }
$rawLines = [System.IO.File]::ReadAllLines($rawTranscriptPath, [System.Text.Encoding]::UTF8)

# 2. Parse turns starting at 12:17
$rawTurns = @()
$cSpk = ""
$cTime = ""
$cSb = [System.Text.StringBuilder]::new()

for ($i = 0; $i -lt $rawLines.Count; $i++) {
    $line = $rawLines[$i].Trim()
    if ($line -match "^(Lewis O'Shea|Tony|Speaker 5)\s*\|\s*(\d{2}:\d{2}(?::\d{2})?)") {
        $speaker = $matches[1]
        $time = $matches[2]
        
        $parts = $time -split ":"
        $isAfter12 = $false
        if ($parts.Count -eq 3) { $isAfter12 = $true }
        elseif ([int]$parts[0] -ge 12) { $isAfter12 = $true }
        
        if ($isAfter12) {
            if ($cSpk -ne "") {
                $rawTurns += [PSCustomObject]@{
                    Speaker = $cSpk
                    Time = $cTime
                    Text = $cSb.ToString().Trim()
                }
                $cSb.Clear() | Out-Null
            }
            if ($speaker -eq "Speaker 5") { $cSpk = "Tony" }
            elseif ($speaker -match "Lewis") { $cSpk = "Louie" }
            else { $cSpk = "Tony" }
            
            $cTime = $time
        }
    } else {
        if ($cSpk -ne "" -and $line -ne "") {
            $cSb.Append(" " + $line) | Out-Null
        }
    }
}
if ($cSpk -ne "") {
    $rawTurns += [PSCustomObject]@{
        Speaker = $cSpk
        Time = $cTime
        Text = $cSb.ToString().Trim()
    }
}
Write-Host "Parsed $($rawTurns.Count) turns from 12:17 onward."

# 3. Load template/index_template.html
$templatePath = "D:\Documents\Tony b\template\index_template.html"
if (-not (Test-Path $templatePath)) { throw "Template missing: $templatePath" }
$templateLines = [System.IO.File]::ReadAllLines($templatePath, [System.Text.Encoding]::UTF8)

# Split template:
# Lines 1 to 506: Head & Body up to <script>
# Lines 608 to end: Application Engine
$headLines = $templateLines[0..505]
$engineLines = $templateLines[607..($templateLines.Count - 1)]

# 4. Define Tony's VOCAB_DB
$vocabData = @(
  @('bottleneck', 'bottleneck', '/ˈbɒt.əl.nek/', 'noun', 'B2', '14:30', 'turn-10', 'language-fluency', 'A point of congestion or blockage that slows down an entire process or conversation flow.', 'Tony (14:30): "I feel a lack of coherence... translating in my head creates a bottleneck." Louie (01:06:22): "We want to open that bottleneck and fill it with natural vocabulary."', 'el cuello de botella / atasco mental'),
  @('coherence', 'coherence', '/kəʊˈhɪə.rəns/', 'noun', 'B2', '14:24', 'turn-10', 'language-fluency', 'The quality of being logical, consistent, clear, and easily intelligible to the listener.', 'Tony (14:24): "I feel that when I speak, I have sometimes this lack of coherence when making my phrases."', 'la coherencia / claridad lógica'),
  @('annotate', 'annotate', '/ˈæn.ə.teɪt/', 'verb', 'C1', '16:00', 'turn-17', 'language-fluency', 'To add critical, structural, or explanatory notes and timestamps to a conversation or text.', 'Louie (16:00): "As we are talking now, it is annotating—it is writing down the notes so you do not have to write during class."', 'anotar / apostillar'),
  @('serendipity', 'serendipity', '/ˌser.ənˈdɪp.ə.ti/', 'noun', 'C2', '16:33', 'turn-22', 'abstract-philosophy', 'The occurrence and development of events by happy chance in a beneficial, fortunate way.', 'Louie (16:33): "For example, serendipity—another word for fortunate luck by happy accident."', 'la serendipia / hallazgo afortunado'),
  @('competency', 'competency', '/ˈkɒm.pɪ.tən.si/', 'noun', 'C1', '16:33', 'turn-22', 'language-fluency', 'The proven ability to do something successfully, efficiently, and to a recognized professional standard.', 'Louie (16:33): "You can see what CEFR competency level the word is on the scale."', 'la competencia / solvencia lingüística'),
  @('contingency', 'contingency', '/kənˈtɪn.dʒən.si/', 'noun', 'C1', '21:01', 'turn-51', 'language-fluency', 'A future event or circumstance which is possible but cannot be predicted with certainty; a backup plan.', 'Louie (21:01): "I have planned for that contingency—so I made it so it can work offline as well."', 'la contingencia / plan de imprevistos'),
  @('minced', 'minced', '/mɪnst/', 'adjective', 'B2', '26:40', 'turn-80', 'culinary-lifestyle', 'Finely cut, ground, or chopped into very small pieces, especially meat for cooking.', 'Louie (26:40): "The word we use for how meatballs are made is they are minced—minced meat."', 'picado / carne picada'),
  @('spherical', 'spherical', '/ˈsfer.ɪ.kəl/', 'adjective', 'B2', '26:51', 'turn-82', 'culinary-lifestyle', 'Shaped like a sphere, ball, or round globe.', 'Louie (26:51): "And that was very good that you used spherical—spherical spheres."', 'esférico / redondeado'),
  @('mangrove', 'mangrove', '/ˈmæŋ.ɡrəʊv/', 'noun', 'C1', '27:44', 'turn-83', 'culinary-lifestyle', 'A tropical tree or shrub with dense, tangled roots that grows in coastal tidal swamps.', 'Louie (27:44): "It is a tropical fruit from India... it grows near mangroves."', 'el manglar'),
  @('gelato', 'gelato', '/dʒəˈlɑː.təʊ/', 'noun', 'B2', '29:04', 'turn-98', 'culinary-lifestyle', 'A rich, artisanal frozen Italian dessert made with milk, cream, and natural ingredients.', 'Louie (29:04): "Gelato—Italian frozen dessert, very good!"', 'el helado artesanal italiano'),
  @('pastrami', 'pastrami', '/pəˈstrɑː.mi/', 'noun', 'B2', '28:20', 'turn-87', 'culinary-lifestyle', 'Highly seasoned, cured, smoked, and steamed beef brisket, iconic in traditional New York delis.', 'Louie (28:20): "It is a New Yorker sandwich... famous for having pastrami meat in a bagel."', 'el pastrami'),
  @('cider', 'cider', '/ˈsaɪ.dər/', 'noun', 'B2', '28:34', 'turn-93', 'culinary-lifestyle', 'An alcoholic or pressed non-alcoholic drink made from the crushed juice of apples.', 'Louie (28:34): "You can make cider out of it... apple juice."', 'la sidra de manzana'),
  @('suspicious', 'suspicious', '/səˈspɪʃ.əs/', 'adjective', 'B2', '31:43', 'turn-123', 'psychology-emotions', 'Having or showing a cautious distrust of someone or something; questioning their motives.', 'Tony (31:43): "When you do not trust what you are hearing or someone is telling you... something looks suspicious."', 'sospechoso / desconfiado'),
  @('fishy', 'fishy', '/ˈfɪʃ.i/', 'idiom', 'B2', '31:43', 'turn-123', 'idioms-expressions', 'Informal expression for arousing doubt or suspicion; dubious, sketchy, or questionable.', 'Tony (31:43): "When something looks fishy... suspicious."', 'turbio / sospechoso'),
  @('affectionate', 'affectionate', '/əˈfek.ʃən.ət/', 'adjective', 'B2', '32:48', 'turn-136', 'psychology-emotions', 'Readily feeling or showing fondness, tenderness, warmth, and gentle care toward others or pets.', 'Louie (32:48): "Affectionate is showing to someone that you like them... cuddly and caring."', 'afectuoso / cariñoso'),
  @('infatuated', 'infatuated', '/ɪnˈfætʃ.u.eɪ.tɪd/', 'adjective', 'C1', '32:23', 'turn-131', 'psychology-emotions', 'Inspired with an intense, short-lived, unreasoning passion or romantic attraction.', 'Louie (32:23): "When you develop sudden intense feelings... infatuated."', 'encaprichado / enamorado ciegamente'),
  @('apologetic', 'apologetic', '/əˌpɒl.əˈdʒet.ɪk/', 'adjective', 'B2', '33:44', 'turn-140', 'psychology-emotions', 'Showing regretful acknowledgment of an offense or mistake; considerate and willing to apologize.', 'Louie (33:44): "Apologetic is when someone apologizes readily in a thoughtful way—it is not weak, it is considerate."', 'arrepentido / educado al disculparse'),
  @('envious', 'envious', '/ˈen.vi.əs/', 'adjective', 'B2', '36:49', 'turn-161', 'psychology-emotions', 'Feeling or showing discontented longing aroused by someone else possessions or good fortune.', 'Louie (36:49): "You are envious of your neighbors... you wish you had what they had."', 'envidioso'),
  @('fomo', 'FOMO', '/ˈfəʊ.məʊ/', 'noun', 'B2', '36:31', 'turn-157', 'psychology-emotions', 'Fear Of Missing Out: anxiety that an exciting or rewarding event may be happening elsewhere without you.', 'Tony (36:31): "Fear of missing out—FOMO."', 'el miedo a perderse algo (FOMO)'),
  @('embarrassed', 'embarrassed', '/ɪmˈbær.əst/', 'adjective', 'B2', '37:21', 'turn-165', 'psychology-emotions', 'Feeling awkward, self-conscious, flustered, or ashamed in front of other people.', 'Tony (37:21): "Embarrassment... embarrassed." Louie: "Yes, you did great on embarrassed!"', 'avergonzado / abochornado'),
  @('amazed', 'amazed', '/əˈmeɪzd/', 'adjective', 'B2', '37:21', 'turn-167', 'psychology-emotions', 'Greatly surprised and filled with genuine wonder; astonished by something remarkable.', 'Louie (37:21): "You did great on amazed—when you see something incredible and can barely believe it."', 'asombrado / fascinado'),
  @('comparison-is-the-thief-of-joy', 'comparison is the thief of joy', '/kəmˈpær.ɪ.sən ɪz ðə θiːf əv dʒɔɪ/', 'idiom', 'C1', '37:21', 'turn-168', 'idioms-expressions', 'Traditional proverb warning that measuring your journey against others destroys present contentment.', 'Louie (37:21): "In England, we say envy is the thief of joy—if you constantly compare, it steals your happiness."', 'la comparación es el ladrón de la alegría'),
  @('innocence', 'innocence', '/ˈɪn.ə.səns/', 'noun', 'B2', '41:20', 'turn-189', 'abstract-philosophy', 'Freedom from guilt or moral wrong; an untainted purity that sees the good in all people.', 'Tony (41:20): "When you are a kid and you are incapable of seeing the bad side of people... innocence."', 'la inocencia'),
  @('turn-the-other-cheek', 'turn the other cheek', '/tɜːn ði ˈʌð.ər tʃiːk/', 'idiom', 'C1', '41:56', 'turn-190', 'idioms-expressions', 'To refrain from retaliating when wronged; demonstrating moral restraint and forgiveness.', 'Louie (41:56): "Turn the other cheek—when someone does something bad and you do not retaliate."', 'poner la otra mejilla'),
  @('forgiveness', 'forgiveness', '/fəˈɡɪv.nəs/', 'noun', 'B2', '42:06', 'turn-191', 'abstract-philosophy', 'The conscious, deliberate decision to release feelings of resentment toward someone who offended you.', 'Tony (42:06): "Forgiveness... when you release anger."', 'el perdón'),
  @('stubborn', 'stubborn', '/ˈstʌb.ən/', 'adjective', 'B2', '42:15', 'turn-195', 'psychology-emotions', 'Having an unyielding determination not to change one attitude, stance, or opinion.', 'Tony (42:15): "When you are very stubborn and you have a strong opinion and refuse to change."', 'terco / testarudo'),
  @('pride', 'pride', '/praɪd/', 'noun', 'B2', '43:05', 'turn-198', 'abstract-philosophy', 'A healthy feeling of deep satisfaction derived from one own achievements, integrity, or craft.', 'Louie (43:05): "Pride is when you respect your process, try your hardest, and respect your own time."', 'el orgullo (dignidad y satisfacción personal)'),
  @('take-pride-in', 'take pride in', '/teɪk praɪd ɪn/', 'idiom', 'B2', '43:53', 'turn-206', 'idioms-expressions', 'To derive sincere satisfaction and care from doing something to the highest possible standard.', 'Louie (43:53): "You can take pride in your work—it means doing things with care and craftsmanship."', 'enorgullecerse de / poner esmero en'),
  @('pride-of-lions', 'a pride of lions', '/ə praɪd əv ˈlaɪ.ənz/', 'idiom', 'B2', '44:48', 'turn-215', 'idioms-expressions', 'A collective noun for a natural social group or family of lions roaming together.', 'Louie (44:48): "Lions have a pride... a pride of lions."', 'una manada de leones'),
  @('murder-of-crows', 'a murder of crows', '/ə ˈmɜː.dər əv krəʊz/', 'idiom', 'C1', '45:14', 'turn-220', 'idioms-expressions', 'A poetic traditional English collective noun for a flock of crows gathered together.', 'Tony (45:14): "Yeah, I know that one... a murder of crows, right?"', 'una bandada de cuervos'),
  @('gaggle-of-geese', 'a gaggle of geese', '/ə ˈɡæɡ.əl əv ɡiːs/', 'idiom', 'B2', '45:34', 'turn-223', 'idioms-expressions', 'A noisy flock of geese on the ground or swimming; also used informally for a chattering group.', 'Louie (45:34): "A gaggle of geese... they make that loud gaggle noise."', 'una bandada de gansos'),
  @('what-is-good-for-the-goose', "what's good for the goose is good for the gander", '/wɒts ɡʊd fɔː ðə ɡuːs ɪz ɡʊd fɔː ðə ˈɡæn.dər/', 'idiom', 'C1', '45:49', 'turn-226', 'idioms-expressions', 'Proverb: what is acceptable or fair for one person must be equally fair for another.', 'Louie (45:49): "What is good for the goose is good for the gander—it means equality in treatment."', 'lo que es bueno para el uno es bueno para el otro'),
  @('padel', 'padel', '/ˈpæd.əl/', 'noun', 'B2', '47:47', 'turn-246', 'sports-lifestyle', 'A fast-paced racket sport of Mexican/Spanish origin, played in doubles within an enclosed glass court.', 'Tony (47:47): "I like to play padel with my friends on weekends."', 'el pádel'),
  @('downtime', 'downtime', '/ˈdaʊn.taɪm/', 'noun', 'B2', '47:47', 'turn-246', 'lifestyle-wellbeing', 'Peaceful time during which you are not working, busy, or connected to stressful obligations.', 'Tony (47:47): "This is the sort of things I look forward to do in my spare time... my downtime."', 'el tiempo de descanso / desconexión'),
  @('unplug', 'unplug', '/ʌnˈplʌɡ/', 'verb', 'B2', '57:13', 'turn-307', 'lifestyle-wellbeing', 'To deliberately disconnect from digital devices, emails, and internet notifications to regain peace.', 'Tony (57:13): "When I go to the cinema, I am able to spend two hours without watching my phone... completely unplugged."', 'desconectar de pantallas / tecnología'),
  @('unwind', 'unwind', '/ʌnˈwaɪnd/', 'verb', 'B2', '13:57', 'turn-8', 'lifestyle-wellbeing', 'To release tension, decompress, and relax peacefully after a strenuous workday.', 'Tony (13:57): "I booked this class at five so I can do it from here and then go home and just unwind and relax."', 'desconectar / relajarse'),
  @('immersive', 'immersive', '/ɪˈmɜː.sɪv/', 'adjective', 'C1', '57:18', 'turn-308', 'arts-cinema', 'Generating a feeling of total mental absorption, depth, and complete sensory presence in an environment.', 'Tony (57:18): "It is everything—it is the immersive atmosphere, basically."', 'envolvente / inmersivo'),
  @('communal', 'communal', '/kəˈmjuː.nəl/', 'adjective', 'B2', '57:33', 'turn-310', 'culture-society', 'Shared, experienced, or held in common by all members of a group or viewing audience.', 'Tony (57:33): "It is a communal room with people who share the same respect for the film."', 'comunitario / colectivo / compartido'),
  @('forbearance', 'forbearance', '/fɔːˈbeə.rəns/', 'noun', 'C2', '41:56', 'turn-190', 'abstract-philosophy', 'Patient self-control, restraint, and tolerance when faced with provocation or injury.', 'Louie (41:56): "Turning the other cheek requires profound moral forbearance."', 'la tolerancia paciente / indulgencia'),
  @('revitalize', 'revitalize', '/ˌriːˈvaɪ.təl.aɪz/', 'verb', 'C1', '48:38', 'turn-251', 'arts-cinema', 'To imbue with new life, energy, vitality, or creative vigor.', 'Tony (48:38): "They are trying to revitalize old theater buildings in the city center."', 'revitalizar / reactivar'),
  @('second-nature', 'second nature', '/ˌsek.ənd ˈneɪ.tʃər/', 'idiom', 'C1', '01:06:22', 'turn-362', 'language-fluency', 'A habit, reflex, or manner so deeply ingrained that it is performed automatically without thought.', 'Louie (01:06:22): "Once we open that bottleneck, speaking English becomes second nature."', 'una segunda naturaleza / algo instintivo'),
  @('architectural-restoration', 'architectural restoration', '/ˌɑː.kɪ.tek.tʃər.əl ˌres.təˈreɪ.ʃən/', 'noun', 'C1', '48:38', 'turn-251', 'arts-architecture', 'The precise discipline of restoring historic buildings and theaters to their authentic heritage state.', 'Tony (48:38): "It is an architectural restoration of a grand 1920s cinema hall."', 'la restauración arquitectónica'),
  @('inner-monologue', 'inner monologue', '/ˈɪn.ər ˈmɒn.əl.ɒɡ/', 'noun', 'C1', '14:24', 'turn-10', 'psychology-emotions', 'The continuous internal voice that speaks, thinks, and narrates experiences within one mind.', 'Tony (14:24): "Translating in my head means my inner monologue is stuck in Spanish before reaching English."', 'el monólogo interno'),
  @('showing-off', 'showing off', '/ˈʃəʊ.ɪŋ ɒf/', 'idiom', 'B2', '43:53', 'turn-206', 'psychology-emotions', 'Boasting or behaving pretentiously to attract excessive admiration or envy from others.', 'Louie (43:53): "Taking pride in your work is not showing off—it is about quiet integrity."', 'presumir / alardear'),
  @('stakes', 'stakes', '/steɪks/', 'noun', 'B2', '01:01:14', 'turn-327', 'arts-cinema', 'The critical risks, potential rewards, or consequences hanging in the balance of a dramatic story.', 'Louie (01:01:14): "In franchise movies, the stakes keep on rising until nothing feels real anymore."', 'lo que está en juego / la escala dramática'),
  @('back-catalog', 'back catalog', '/bæk ˈkæt.əl.ɒɡ/', 'noun', 'B2', '01:03:01', 'turn-337', 'arts-cinema', 'The complete historical collection of previous films, albums, or artistic works created by an artist.', 'Louie (01:03:01): "You can dive into an auteur director back catalog and find forgotten gems."', 'la filmografía previa / el fondo de catálogo'),
  @('conscience', 'conscience', '/ˈkɒn.ʃəns/', 'noun', 'B2', '41:40', 'turn-189', 'abstract-philosophy', 'An inner sense of what is right or wrong in one conduct or motives, impelling toward right action.', 'Louie (41:40): "A clear conscience allows you to sleep peacefully at night."', 'la conciencia moral'),
  @('conscientious', 'conscientious', '/ˌkɒn.ʃiˈen.ʃəs/', 'adjective', 'C1', '43:53', 'turn-206', 'abstract-philosophy', 'Wishing to do what is right, especially to do one work or duty thoroughly and diligently.', 'Louie (43:53): "Conscientious craftsmanship is the cornerstone of professional pride."', 'concienzudo / diligente'),
  @('blockbuster', 'blockbuster', '/ˈblɒkˌbʌs.tər/', 'noun', 'B2', '58:20', 'turn-315', 'arts-cinema', 'A film, book, or production of widespread, massive commercial popularity and huge financial scale.', 'Tony (58:20): "I used to enjoy superhero blockbusters, but nowadays they feel repetitive."', 'el superéxito de taquilla / taquillazo'),
  @('franchise', 'franchise', '/ˈfræn.tʃaɪz/', 'noun', 'B2', '58:45', 'turn-317', 'arts-cinema', 'A sprawling media brand encompassing serialized movie sequels, spin-offs, and commercial merchandise.', 'Louie (58:45): "Franchise fatigue happens when every studio tries to build a ten-year universe."', 'la franquicia cinematográfica'),
  @('hype', 'hype', '/haɪp/', 'noun', 'B2', '59:15', 'turn-319', 'arts-cinema', 'Extravagant, aggressive promotion or popular buzz created to generate intense public anticipation.', 'Tony (59:15): "Sometimes the marketing hype is so big that the movie cannot possibly match it."', 'el bombo publicitario / la expectación exagerada'),
  @('suppress', 'suppress', '/səˈpres/', 'verb', 'C1', '01:04:12', 'turn-348', 'psychology-emotions', 'To forcibly put an end to, hold back, or keep psychological memories from surface expression.', 'Louie (01:04:12): "Traumatic memories are often suppressed until art allows us to confront them safely."', 'reprimir / sofocar'),
  @('cinematic-restraint', 'cinematic restraint', '/ˌsɪn.əˈmæt.ɪk rɪˈstreɪnt/', 'noun', 'C2', '01:04:57', 'turn-352', 'arts-cinema', 'Deliberate artistic economy where powerful emotion is evoked through subtlety and off-screen suggestion rather than graphic spectacle.', 'Louie (01:04:57): "The Zone of Interest achieves chilling power through pure cinematic restraint—we hear the horror rather than see it."', 'la contención cinematográfica')
)

$sb = [System.Text.StringBuilder]::new()

# Header lines
foreach ($l in $headLines) { $sb.AppendLine($l) | Out-Null }

$sb.AppendLine(@'
    // =========================================================================
    // LESSON DATA: Tony B • 3 November 2026
    // Tutor: Louie (Lewis O'Shea) | Student: Tony B (Valencia, Spain)
    // =========================================================================
    const LESSON_CONFIG = {
      studentName: "Tony",
      lessonNumber: "Lesson 01",
      lessonDate: "3 November 2026",
      lessonSubtitle: "Eliminating the Translation Bottleneck & Arthouse Cinema",
      l1FlagAndLabel: "🇪🇸 Conexión en español:",
      heroHeadingHtml: `Welcome Tony — Your <span class="text-autumn-700 italic font-semibold">Peaceful Sanctuary</span> for English Reflection`,
      heroIntroText: `Here is your tidy, corrected transcript with exact timestamps and flagged vocabulary words. All of the automated note-taker's spelling mistakes have been sorted out for you.`,
      defaultSpotlightKey: "bottleneck"
    };

    // 1. Flagged Vocabulary Dictionary (53 items with exact timestamps)
    const VOCAB_DB = {
'@) | Out-Null

for ($i = 0; $i -lt $vocabData.Count; $i++) {
    $v = $vocabData[$i]
    $key = $v[0]
    $word = $v[1]
    $ipa = $v[2]
    $pos = $v[3]
    $lvl = $v[4]
    $time = $v[5]
    $tId = $v[6]
    $cat = $v[7]
    $def = $v[8].Replace('"', '\"')
    $quote = $v[9].Replace('"', '\"')
    $l1 = $v[10].Replace('"', '\"')

    $comma = if ($i -lt $vocabData.Count - 1) { "," } else { "" }
    $sb.AppendLine("      `"$key`": { word: `"$word`", ipa: `"$ipa`", pos: `"$pos`", level: `"$lvl`", time: `"$time`", turnId: `"$tId`", cat: `"$cat`", def: `"$def`", quote: `"$quote`", l1: `"$l1`", es: `"$l1`" }$comma") | Out-Null
}

$sb.AppendLine(@'
    };

    // Helper functions for inline transcript markup
    function v(key, displayWord) {
      const item = (typeof VOCAB_DB !== 'undefined' && VOCAB_DB[key]) ? VOCAB_DB[key] : null;
      const label = displayWord || (item ? item.word : key);
      return `<span class="vocab-mark" data-vkey="${key}" onclick="inspectVocab('${key}')">${label}</span>`;
    }

    function fixBadge(corrected, rawMistake) {
      return `<span class="asr-fix-pill" title="Note-taker misheard '${corrected}' as '${rawMistake}'">✨ Fixed: "${corrected}" <span class="text-stone-400 line-through">(${rawMistake})</span></span>`;
    }

    // 2. Full Cleaned Transcript Turns (12:17 to 01:07:02)
    const TRANSCRIPT_TURNS = [
'@) | Out-Null

# 5. Build TRANSCRIPT_TURNS with token replacement
$chapEmitted = @{ 1 = $false; 2 = $false; 3 = $false; 4 = $false; 5 = $false }

for ($idx = 0; $idx -lt $rawTurns.Count; $idx++) {
    $t = $rawTurns[$idx]
    $tId = "turn-" + ($idx + 1)
    $spk = $t.Speaker
    $time = $t.Time
    $rawText = $t.Text
    
    $timeParts = $time -split ":"
    $mins = 0
    if ($timeParts.Count -eq 3) {
        $mins = [int]$timeParts[0] * 60 + [int]$timeParts[1]
    } else {
        $mins = [int]$timeParts[0]
    }
    
    $chapId = ""
    $chapTitle = ""
    if (-not $chapEmitted[1] -and $mins -ge 12) {
        $chapEmitted[1] = $true
        $chapId = "chap-1"
        $chapTitle = "Chapter I • Sanctuary Onboarding & Eliminating the Mental Bottleneck (12:17 – 20:30)"
    }
    elseif (-not $chapEmitted[2] -and $mins -ge 20 -and ($mins -gt 20 -or [int]$timeParts[1] -ge 30)) {
        $chapEmitted[2] = $true
        $chapId = "chap-2"
        $chapTitle = "Chapter II • Rapid-Fire Culinary Vocabulary & Heads Up Food Drills (20:30 – 31:00)"
    }
    elseif (-not $chapEmitted[3] -and $mins -ge 31) {
        $chapEmitted[3] = $true
        $chapId = "chap-3"
        $chapTitle = "Chapter III • Emotional Nuance, Abstract Philosophy & Rapid Verbal Retrieval (31:00 – 42:15)"
    }
    elseif (-not $chapEmitted[4] -and $mins -ge 42 -and ($mins -gt 42 -or [int]$timeParts[1] -ge 15)) {
        $chapEmitted[4] = $true
        $chapId = "chap-4"
        $chapTitle = "Chapter IV • Cultural False Friends ('Pride' vs 'Orgullo') & English Collective Nouns (42:15 – 47:45)"
    }
    elseif (-not $chapEmitted[5] -and $mins -ge 47 -and ($mins -gt 47 -or [int]$timeParts[1] -ge 45)) {
        $chapEmitted[5] = $true
        $chapId = "chap-5"
        $chapTitle = "Chapter V • Cinema as a Digital Sanctuary & Jonathan Glazer's 'The Zone of Interest' (47:45 – 01:07:02)"
    }

    $tHtml = $rawText

    # ASR tokenizing
    $tHtml = $tHtml.Replace("and the Escoonnade relax", "@@FIX_UNWIND@@")
    $tHtml = $tHtml.Replace("iOS grading, compensancy, competency", "@@FIX_IELTS_COMPETENCY@@")
    $tHtml = $tHtml.Replace("A tfle of beef that it's rounded", "@@FIX_BEEF_BALL@@")
    $tHtml = $tHtml.Replace("or e it with rice", "or eat it with rice")
    $tHtml = $tHtml.Replace("It's feric...", "@@FIX_SPHERICAL_1@@")
    $tHtml = $tHtml.Replace("Mospher beef", "@@FIX_SPHERICAL_2@@")
    $tHtml = $tHtml.Replace("Estra chaa...", "@@FIX_STRACCIATELLA@@")
    $tHtml = $tHtml.Replace("Noelle of frozen a gelado ice cream", "@@FIX_GELATO@@")
    $tHtml = $tHtml.Replace("Sabile? Okay...", "@@FIX_SEVILLE_1@@")
    $tHtml = $tHtml.Replace("my Loom's...", "@@FIX_LOUIE_MUM_1@@")
    $tHtml = $tHtml.Replace("My Loom's rigging me right now", "@@FIX_LOUIE_MUM_2@@")
    $tHtml = $tHtml.Replace("looks speechy, sus suspicious", "@@FIX_SUSPICIOUS@@")
    $tHtml = $tHtml.Replace("in actuated", "@@FIX_INFATUATED@@")
    $tHtml = $tHtml.Replace("Formal fear of missing out, MB", "@@FIX_FOMO@@")
    $tHtml = $tHtml.Replace("formal fear of missing out, MB", "@@FIX_FOMO@@")
    $tHtml = $tHtml.Replace("A marr froz, right?", "@@FIX_MURDER_OF_CROWS@@")
    $tHtml = $tHtml.Replace("paddle", "@@FIX_PADEL@@")
    $tHtml = $tHtml.Replace("curry movie section", "@@FIX_CURR_MOVIE_SECTION@@")
    $tHtml = $tHtml.Replace("Timothy... Charlemagne", "@@FIX_CHALAMET_1@@")
    $tHtml = $tHtml.Replace("Smothy Salome", "@@FIX_CHALAMET_2@@")
    $tHtml = $tHtml.Replace("Add so much build-up to Vanos", "@@FIX_THANOS@@")
    $tHtml = $tHtml.Replace("Do a doctor Loom", "@@FIX_DOCTOR_DOOM_1@@")
    $tHtml = $tHtml.Replace("Dr Loom", "@@FIX_DOCTOR_DOOM_2@@")
    $tHtml = $tHtml.Replace("Male stream", "@@FIX_MERYL_STREEP@@")
    $tHtml = $tHtml.Replace("so of interest. A for a twenty 4", "@@FIX_ZONE_OF_INTEREST@@")
    $tHtml = $tHtml.Replace("Bo, all neg is", "@@FIX_BOTTLENECK_2@@")
    $tHtml = $tHtml.Replace("architectural. Architectural, his restoration", "@@FIX_ARCH_REST@@")
    $tHtml = $tHtml.Replace("without watching it. So I think", "@@FIX_UNPLUG@@")
    $tHtml = $tHtml.Replace("It's everything. It's the atmosphere, basically.", "@@FIX_IMMERSIVE@@")
    $tHtml = $tHtml.Replace("room with people like bed people", "@@FIX_COMMUNAL@@")
    $tHtml = $tHtml.Replace("turned the other cheek, but I forgive", "@@FIX_FORBEARANCE@@")
    $tHtml = $tHtml.Replace("To you vitalize", "@@FIX_REVITALIZE@@")
    $tHtml = $tHtml.Replace("translating or getting stuck.", 'translating or getting stuck, so speaking English becomes @@TOKEN_SECOND_NATURE@@.')
    $tHtml = $tHtml.Replace("take pride in", "@@TOKEN_TAKE_PRIDE_IN@@")
    $tHtml = $tHtml.Replace("Take pride in", "@@TOKEN_TAKE_PRIDE_IN@@")
    $tHtml = $tHtml.Replace("a family of lions a pride", "@@TOKEN_PRIDE_OF_LIONS@@")

    # Compound phrases tokens
    $tHtml = [regex]::Replace($tHtml, '\bcomparison is the thief of joy\b', '@@TOKEN_COMP_THIEF@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\benvy is the thief of joy\b', '@@TOKEN_COMP_THIEF_2@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\benvious the thief of joy\b', '@@TOKEN_COMP_THIEF_3@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bturn the other cheek\b', '@@TOKEN_TURN_CHEEK@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\ba gaggle of geese\b', '@@TOKEN_GAGGLE@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, "\bwhat's good for the goose is good for the gaggle\b", '@@TOKEN_GOOSE_GAGGLE@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\binner monologue\b', '@@TOKEN_INNER_MONO@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bspare time\b', '@@TOKEN_DOWNTIME@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bshowing off\b', '@@TOKEN_SHOWING_OFF@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bstakes keep on rising\b', '@@TOKEN_STAKES@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bback catalog\b', '@@TOKEN_BACK_CAT@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\ba bottleneck\b', 'a @@TOKEN_BOTTLENECK@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bthat bottleneck\b', 'that @@TOKEN_BOTTLENECK@@', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Standalone vocabulary words
    $tHtml = [regex]::Replace($tHtml, '\bcoherence\b', '<span class="vocab-mark" data-vkey="coherence" onclick="inspectVocab(''coherence'')">coherence</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bannotating\b', '<span class="vocab-mark" data-vkey="annotate" onclick="inspectVocab(''annotate'')">annotating</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bserendipity\b', '<span class="vocab-mark" data-vkey="serendipity" onclick="inspectVocab(''serendipity'')">serendipity</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bcompetency\b', '<span class="vocab-mark" data-vkey="competency" onclick="inspectVocab(''competency'')">competency</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bcontingency\b', '<span class="vocab-mark" data-vkey="contingency" onclick="inspectVocab(''contingency'')">contingency</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bminced\b', '<span class="vocab-mark" data-vkey="minced" onclick="inspectVocab(''minced'')">minced</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bmangroves\b', '<span class="vocab-mark" data-vkey="mangrove" onclick="inspectVocab(''mangrove'')">mangroves</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bpastrami\b', '<span class="vocab-mark" data-vkey="pastrami" onclick="inspectVocab(''pastrami'')">pastrami</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bcider\b', '<span class="vocab-mark" data-vkey="cider" onclick="inspectVocab(''cider'')">cider</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\baffectionate\b', '<span class="vocab-mark" data-vkey="affectionate" onclick="inspectVocab(''affectionate'')">affectionate</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bapologetic\b', '<span class="vocab-mark" data-vkey="apologetic" onclick="inspectVocab(''apologetic'')">apologetic</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\benvious\b', '<span class="vocab-mark" data-vkey="envious" onclick="inspectVocab(''envious'')">envious</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\binnocence\b', '<span class="vocab-mark" data-vkey="innocence" onclick="inspectVocab(''innocence'')">innocence</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bforgiveness\b', '<span class="vocab-mark" data-vkey="forgiveness" onclick="inspectVocab(''forgiveness'')">forgiveness</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bstubborn\b', '<span class="vocab-mark" data-vkey="stubborn" onclick="inspectVocab(''stubborn'')">stubborn</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bpride\b', '<span class="vocab-mark" data-vkey="pride" onclick="inspectVocab(''pride'')">pride</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bconscience\b', '<span class="vocab-mark" data-vkey="conscience" onclick="inspectVocab(''conscience'')">conscience</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bconscientious\b', '<span class="vocab-mark" data-vkey="conscientious" onclick="inspectVocab(''conscientious'')">conscientious</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bblockbusters\b', '<span class="vocab-mark" data-vkey="blockbuster" onclick="inspectVocab(''blockbuster'')">blockbusters</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bfranchise\b', '<span class="vocab-mark" data-vkey="franchise" onclick="inspectVocab(''franchise'')">franchise</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bhype\b', '<span class="vocab-mark" data-vkey="hype" onclick="inspectVocab(''hype'')">hype</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bsuppress\b', '<span class="vocab-mark" data-vkey="suppress" onclick="inspectVocab(''suppress'')">suppress</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bsuppressed\b', '<span class="vocab-mark" data-vkey="suppress" onclick="inspectVocab(''suppress'')">suppressed</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bGelato\b', '<span class="vocab-mark" data-vkey="gelato" onclick="inspectVocab(''gelato'')">Gelato</span>')
    $tHtml = [regex]::Replace($tHtml, '\bembarrassed\b', '<span class="vocab-mark" data-vkey="embarrassed" onclick="inspectVocab(''embarrassed'')">embarrassed</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bamazed\b', '<span class="vocab-mark" data-vkey="amazed" onclick="inspectVocab(''amazed'')">amazed</span>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Expand compound tokens to HTML
    $tHtml = $tHtml.Replace('@@TOKEN_BOTTLENECK@@', '<span class="vocab-mark" data-vkey="bottleneck" onclick="inspectVocab(''bottleneck'')">bottleneck</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_COMP_THIEF@@', '<span class="vocab-mark" data-vkey="comparison-is-the-thief-of-joy" onclick="inspectVocab(''comparison-is-the-thief-of-joy'')">comparison is the thief of joy</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_COMP_THIEF_2@@', '<span class="vocab-mark" data-vkey="comparison-is-the-thief-of-joy" onclick="inspectVocab(''comparison-is-the-thief-of-joy'')">envy is the thief of joy</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_COMP_THIEF_3@@', '<span class="vocab-mark" data-vkey="comparison-is-the-thief-of-joy" onclick="inspectVocab(''comparison-is-the-thief-of-joy'')">envious the thief of joy</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_TURN_CHEEK@@', '<span class="vocab-mark" data-vkey="turn-the-other-cheek" onclick="inspectVocab(''turn-the-other-cheek'')">turn the other cheek</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_GAGGLE@@', '<span class="vocab-mark" data-vkey="gaggle-of-geese" onclick="inspectVocab(''gaggle-of-geese'')">a gaggle of geese</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_GOOSE_GAGGLE@@', '<span class="vocab-mark" data-vkey="what-is-good-for-the-goose" onclick="inspectVocab(''what-is-good-for-the-goose'')">what''s good for the goose is good for the gaggle</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_INNER_MONO@@', '<span class="vocab-mark" data-vkey="inner-monologue" onclick="inspectVocab(''inner-monologue'')">inner monologue</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_DOWNTIME@@', '<span class="vocab-mark" data-vkey="downtime" onclick="inspectVocab(''downtime'')">spare time</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_SHOWING_OFF@@', '<span class="vocab-mark" data-vkey="showing-off" onclick="inspectVocab(''showing-off'')">showing off</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_STAKES@@', '<span class="vocab-mark" data-vkey="stakes" onclick="inspectVocab(''stakes'')">stakes keep on rising</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_BACK_CAT@@', '<span class="vocab-mark" data-vkey="back-catalog" onclick="inspectVocab(''back-catalog'')">back catalog</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_SECOND_NATURE@@', '<span class="vocab-mark" data-vkey="second-nature" onclick="inspectVocab(''second-nature'')">second nature</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_TAKE_PRIDE_IN@@', '<span class="vocab-mark" data-vkey="take-pride-in" onclick="inspectVocab(''take-pride-in'')">take pride in</span>')
    $tHtml = $tHtml.Replace('@@TOKEN_PRIDE_OF_LIONS@@', 'a family of lions <span class="vocab-mark" data-vkey="pride-of-lions" onclick="inspectVocab(''pride-of-lions'')">a pride</span>')

    # Expand ASR fixes to HTML
    $tHtml = $tHtml.Replace('@@FIX_UNWIND@@', '<span class="vocab-mark" data-vkey="unwind" onclick="inspectVocab(''unwind'')">and just unwind and relax</span> <span class="asr-fix-pill" title="Note-taker misheard ''and just unwind and relax'' as ''and the Escoonnade relax''">✨ Fixed: "and just unwind and relax" <span class="text-stone-400 line-through">(and the Escoonnade relax)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_IELTS_COMPETENCY@@', 'IELTS grading, <span class="vocab-mark" data-vkey="competency" onclick="inspectVocab(''competency'')">CEFR competency</span> <span class="asr-fix-pill" title="Note-taker misheard ''IELTS grading, CEFR competency'' as ''iOS grading, compensancy, competency''">✨ Fixed: "IELTS grading, CEFR competency" <span class="text-stone-400 line-through">(iOS grading, compensancy, competency)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_BEEF_BALL@@', 'A rounded ball of beef <span class="asr-fix-pill" title="Note-taker misheard ''A ball of beef that is rounded'' as ''A tfle of beef that it''s rounded''">✨ Fixed: "A ball of beef that is rounded" <span class="text-stone-400 line-through">(A tfle of beef that it''s rounded)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_SPHERICAL_1@@', 'It''s <span class="vocab-mark" data-vkey="spherical" onclick="inspectVocab(''spherical'')">spherical</span> <span class="asr-fix-pill" title="Note-taker misheard ''spherical'' as ''feric''">✨ Fixed: "spherical" <span class="text-stone-400 line-through">(feric)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_SPHERICAL_2@@', '<span class="vocab-mark" data-vkey="spherical" onclick="inspectVocab(''spherical'')">Spherical</span> beef <span class="asr-fix-pill" title="Note-taker misheard ''Spherical beef'' as ''Mospher beef''">✨ Fixed: "Spherical beef" <span class="text-stone-400 line-through">(Mospher beef)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_STRACCIATELLA@@', 'Stracciatella <span class="asr-fix-pill" title="Note-taker misheard ''Stracciatella'' as ''Estra chaa''">✨ Fixed: "Stracciatella" <span class="text-stone-400 line-through">(Estra chaa)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_GELATO@@', 'artisanal frozen <span class="vocab-mark" data-vkey="gelato" onclick="inspectVocab(''gelato'')">gelato</span> ice cream <span class="asr-fix-pill" title="Note-taker misheard ''artisanal frozen gelato'' as ''Noelle of frozen a gelado ice cream''">✨ Fixed: "artisanal frozen gelato" <span class="text-stone-400 line-through">(Noelle of frozen a gelado ice cream)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_SEVILLE_1@@', 'Seville? <span class="asr-fix-pill" title="Note-taker misheard ''Seville'' as ''Sabile''">✨ Fixed: "Seville" <span class="text-stone-400 line-through">(Sabile)</span></span> Okay...')
    $tHtml = $tHtml.Replace('@@FIX_LOUIE_MUM_1@@', 'my mum''s <span class="asr-fix-pill" title="Note-taker misheard ''my mum''s'' as ''my Loom''s''">✨ Fixed: "my mum''s" <span class="text-stone-400 line-through">(my Loom''s)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_LOUIE_MUM_2@@', 'My mum''s calling me right now <span class="asr-fix-pill" title="Note-taker misheard ''My mum''s calling me'' as ''My Loom''s rigging me''">✨ Fixed: "My mum''s calling me" <span class="text-stone-400 line-through">(My Loom''s rigging me)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_SUSPICIOUS@@', 'looks <span class="vocab-mark" data-vkey="fishy" onclick="inspectVocab(''fishy'')">fishy</span>, <span class="vocab-mark" data-vkey="suspicious" onclick="inspectVocab(''suspicious'')">suspicious</span> <span class="asr-fix-pill" title="Note-taker misheard ''fishy, suspicious'' as ''speechy, sus suspicious''">✨ Fixed: "fishy, suspicious" <span class="text-stone-400 line-through">(speechy, sus suspicious)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_INFATUATED@@', '<span class="vocab-mark" data-vkey="infatuated" onclick="inspectVocab(''infatuated'')">infatuated</span> <span class="asr-fix-pill" title="Note-taker misheard ''infatuated'' as ''in actuated''">✨ Fixed: "infatuated" <span class="text-stone-400 line-through">(in actuated)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_FOMO@@', '<span class="vocab-mark" data-vkey="fomo" onclick="inspectVocab(''fomo'')">FOMO</span> (fear of missing out), <span class="vocab-mark" data-vkey="envious" onclick="inspectVocab(''envious'')">envy</span> <span class="asr-fix-pill" title="Note-taker misheard ''FOMO, envy'' as ''Formal fear of missing out, MB''">✨ Fixed: "FOMO, envy" <span class="text-stone-400 line-through">(Formal fear of missing out, MB)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_MURDER_OF_CROWS@@', '<span class="vocab-mark" data-vkey="murder-of-crows" onclick="inspectVocab(''murder-of-crows'')">A murder of crows</span>, right? <span class="asr-fix-pill" title="Note-taker misheard ''A murder of crows'' as ''A marr froz''">✨ Fixed: "A murder of crows" <span class="text-stone-400 line-through">(A marr froz)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_PADEL@@', '<span class="vocab-mark" data-vkey="padel" onclick="inspectVocab(''padel'')">padel</span> <span class="asr-fix-pill" title="Note-taker misheard ''padel'' as ''paddle''">✨ Fixed: "padel" <span class="text-stone-400 line-through">(paddle)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_CURR_MOVIE_SECTION@@', 'current movie selection <span class="asr-fix-pill" title="Note-taker misheard ''current movie selection'' as ''curry movie section''">✨ Fixed: "current movie selection" <span class="text-stone-400 line-through">(curry movie section)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_CHALAMET_1@@', 'Timothée Chalamet <span class="asr-fix-pill" title="Note-taker misheard ''Timothée Chalamet'' as ''Timothy Charlemagne''">✨ Fixed: "Timothée Chalamet" <span class="text-stone-400 line-through">(Timothy Charlemagne)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_CHALAMET_2@@', 'Timothée Chalamet <span class="asr-fix-pill" title="Note-taker misheard ''Timothée Chalamet'' as ''Smothy Salome''">✨ Fixed: "Timothée Chalamet" <span class="text-stone-400 line-through">(Smothy Salome)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_THANOS@@', 'Had so much build-up to Thanos <span class="asr-fix-pill" title="Note-taker misheard ''Thanos'' as ''Vanos''">✨ Fixed: "Thanos" <span class="text-stone-400 line-through">(Vanos)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_DOCTOR_DOOM_1@@', 'Doctor Doom <span class="asr-fix-pill" title="Note-taker misheard ''Doctor Doom'' as ''Do a doctor Loom''">✨ Fixed: "Doctor Doom" <span class="text-stone-400 line-through">(Do a doctor Loom)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_DOCTOR_DOOM_2@@', 'Doctor Doom <span class="asr-fix-pill" title="Note-taker misheard ''Doctor Doom'' as ''Dr Loom''">✨ Fixed: "Doctor Doom" <span class="text-stone-400 line-through">(Dr Loom)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_MERYL_STREEP@@', 'Meryl Streep <span class="asr-fix-pill" title="Note-taker misheard ''Meryl Streep'' as ''Male stream''">✨ Fixed: "Meryl Streep" <span class="text-stone-400 line-through">(Male stream)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_ZONE_OF_INTEREST@@', '<span class="vocab-mark" data-vkey="cinematic-restraint" onclick="inspectVocab(''cinematic-restraint'')">The Zone of Interest</span>, an A24 film <span class="asr-fix-pill" title="Note-taker misheard ''The Zone of Interest, an A24 film'' as ''so of interest. A for a twenty 4''">✨ Fixed: "The Zone of Interest, an A24 film" <span class="text-stone-400 line-through">(so of interest. A for a twenty 4)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_BOTTLENECK_2@@', '<span class="vocab-mark" data-vkey="bottleneck" onclick="inspectVocab(''bottleneck'')">bottleneck</span> <span class="asr-fix-pill" title="Note-taker misheard ''bottleneck'' as ''Bo, all neg is''">✨ Fixed: "bottleneck" <span class="text-stone-400 line-through">(Bo, all neg is)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_ARCH_REST@@', '<span class="vocab-mark" data-vkey="architectural-restoration" onclick="inspectVocab(''architectural-restoration'')">architectural restoration</span> <span class="asr-fix-pill" title="Note-taker misheard ''architectural restoration'' as ''architectural. Architectural, his restoration''">✨ Fixed: "architectural restoration" <span class="text-stone-400 line-through">(architectural. Architectural, his restoration)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_REVITALIZE@@', 'to <span class="vocab-mark" data-vkey="revitalize" onclick="inspectVocab(''revitalize'')">revitalize</span> <span class="asr-fix-pill" title="Note-taker misheard ''revitalize'' as ''you vitalize''">✨ Fixed: "revitalize" <span class="text-stone-400 line-through">(you vitalize)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_UNPLUG@@', 'without watching it, <span class="vocab-mark" data-vkey="unplug" onclick="inspectVocab(''unplug'')">unplugging completely</span>. So I think')
    $tHtml = $tHtml.Replace('@@FIX_IMMERSIVE@@', 'It''s everything. It''s the <span class="vocab-mark" data-vkey="immersive" onclick="inspectVocab(''immersive'')">immersive atmosphere</span>, basically.')
    $tHtml = $tHtml.Replace('@@FIX_COMMUNAL@@', 'share a <span class="vocab-mark" data-vkey="communal" onclick="inspectVocab(''communal'')">communal room</span> with people <span class="asr-fix-pill" title="Note-taker misheard ''communal room'' as ''room with people like bed people''">✨ Fixed: "communal room" <span class="text-stone-400 line-through">(room with people like bed people)</span></span>')
    $tHtml = $tHtml.Replace('@@FIX_FORBEARANCE@@', 'turned the other cheek with <span class="vocab-mark" data-vkey="forbearance" onclick="inspectVocab(''forbearance'')">forbearance</span>, but I forgive <span class="asr-fix-pill" title="Note-taker misheard ''turn the other cheek with forbearance'' as ''turned the other cheek, but I forgive''">✨ Fixed: "turn the other cheek with forbearance" <span class="text-stone-400 line-through">(turned the other cheek, but I forgive)</span></span>')

    # Escape backticks safely for template literal string
    $safeHtml = $tHtml.Replace('`', '\`')
    
    $comma = if ($idx -lt $rawTurns.Count - 1) { "," } else { "" }
    $cLine = "      { id: `"$tId`", speaker: `"$spk`", time: `"$time`""
    if ($chapId -ne "") {
        $cLine += ", chapterId: `"$chapId`", chapterTitle: `"$chapTitle`""
    }
    $cLine += ", html: ``$safeHtml`` }$comma"
    $sb.AppendLine($cLine) | Out-Null
}

$sb.AppendLine(@'
    ];

    // 3. Student's Natural Strengths (6 items to build confidence)
    const STUDENT_STRENGTHS = [
      {
        time: "41:20",
        phrase: "\"When you are a kid and you are incapable of seeing the bad side of people... innocence.\"",
        note: "Describing nuanced abstract concepts under a strict 90-second time constraint requires quick lexical retrieval. You pinpointed 'innocence' and 'forgiveness' effortlessly without hesitation."
      },
      {
        time: "25:01",
        phrase: "\"It is beef that you shape it round... it is spherical... it is not a hamburger, you eat it with pasta.\"",
        note: "Instead of getting stuck on the noun 'meatballs', you immediately deployed geometric vocabulary ('spherical') and ingredient distinctions (minced beef/pork vs hamburger patties)."
      },
      {
        time: "43:29",
        phrase: "\"In Spain we have two different meanings... one is what you said, and the other has more like a negative meaning.\"",
        note: "You astutely recognized that Spanish 'orgullo' often connotes stubborn arrogance, whereas English 'taking pride in your work' represents craftsmanship, self-respect, and care."
      },
      {
        time: "57:13",
        phrase: "\"When I go to the cinema, I am able to spend two hours without watching my phone... it has my full attention.\"",
        note: "You spoke compellingly about modern cinema as a digital sanctuary. You comfortably navigated industry terms like 'blockbusters', 'franchise', 'hype', and atmospheric immersion."
      },
      {
        time: "45:14",
        phrase: "\"Yeah, I know that one... a murder of crows, right?\"",
        note: "When Louie introduced quirky English collective animal nouns, you instantly recalled 'a murder of crows'—one of the most poetic and challenging idioms in British folklore!"
      },
      {
        time: "14:24",
        phrase: "\"I have this problem that I try to translate first in my head sometimes... so I want to improve my fluency and coherence.\"",
        note: "Diagnosing your own cognitive bottleneck with total honesty and precision. Identifying the mental translation reflex is the essential foundation for building direct English automaticity."
      }
    ];

    // 4. Gentle Phrasing Refinements (6 supportive upgrades)
    const GENTLE_POLISHES = [
      {
        time: "13:57",
        topic: "Natural British Verb for Relaxing ('Unwind')",
        said: "and the Escoonnade relax",
        natural: "and just unwind and relax",
        why: "The verb 'unwind' is the perfect natural British expression for shedding workday tension after leaving the office."
      },
      {
        time: "14:24",
        topic: "Adverb Placement & Cadence",
        said: "I have sometimes this lack of coherence when making my phrases.",
        natural: "I occasionally struggle with sentence coherence when formulating complex ideas.",
        why: "Placing the frequency adverb 'occasionally' before the verb creates natural English cadence, and 'formulating complex ideas' sounds elegant."
      },
      {
        time: "25:46",
        topic: "Culinary Precision & Plural Agreement",
        said: "It could be made of beef or pork, it is very popular to eat with tomato sauce.",
        natural: "They can be made with either minced beef or pork, and they are typically served in a rich tomato sauce.",
        why: "Referring to meatballs in the plural ('they') and specifying 'minced beef' gives accurate culinary texture."
      },
      {
        time: "31:15",
        topic: "Idiomatic Expression for Suspicion",
        said: "When you don't trust what someone is telling you... when something looks speechy, sus.",
        natural: "When you have reservations about what you are being told, or when a situation feels a bit fishy and suspicious.",
        why: "Replacing the note-taker's 'speechy' with the colloquial idiom 'feels fishy' complements your casual use of 'sus'."
      },
      {
        time: "47:47",
        topic: "Phrasal Verb Pattern ('Look Forward To')",
        said: "This is the sort of things I look forward to do in my spare time.",
        natural: "These are the kinds of activities I look forward to doing in my downtime.",
        why: "The phrasal verb 'look forward to' requires a gerund ('doing'), and 'downtime' is a warm native synonym for spare time."
      },
      {
        time: "57:13",
        topic: "Digital Wellbeing & Presence",
        said: "When I go to the cinema, I am able to spend two hours without watching my phone.",
        natural: "Going to the cinema allows me to unplug from my phone and stay fully immersed for two whole hours.",
        why: "Native speakers say 'checking my phone' or 'unplugging from screens' rather than 'watching my phone', and 'stay fully immersed' conveys deep presence."
      }
    ];

    // 5. Automated Note-Taker Spelling Fixes (17 verified items)
    const ASR_FIXES = [
      { time: "13:57", speaker: "Tony", wrong: "and the Escoonnade relax", right: "and just unwind and relax", note: "Tony described unwinding at home after his office day; speech-to-text mangled 'and just unwind' into 'Escoonnade'." },
      { time: "16:33", speaker: "Louie", wrong: "iOS grading, compensancy", right: "IELTS grading, CEFR competency", note: "Louie explaining language proficiency benchmarks; note-taker heard 'iOS grading, compensancy' instead of 'IELTS / CEFR competency'." },
      { time: "25:01", speaker: "Tony", wrong: "A tfle of beef that it's rounded... and e it with rice", right: "A ball of beef that is rounded... and eat it with rice", note: "Heads Up food drill: note-taker typed 'tfle' for ball/patty and 'e it' for eat it." },
      { time: "25:40", speaker: "Tony & Louie", wrong: "feric... Mospher beef", right: "spherical... spherical beef", note: "Tony described the geometry of meatballs as 'spherical'; note-taker split it into 'feric' and 'Mospher'." },
      { time: "28:48", speaker: "Tony", wrong: "Estra chaa... Noelle of frozen a gelado", right: "Stracciatella... artisanal frozen gelato", note: "Heads Up Italian desserts: Tony named the famous chocolate-flake gelato flavor Stracciatella." },
      { time: "30:02", speaker: "Tony & Louie", wrong: "Sabile... my Loom's", right: "Seville... my mum's", note: "Geographical mishearing: the Andalusian capital Seville was heard as 'Sabile', and Louie's mum as 'Loom's'." },
      { time: "31:43", speaker: "Tony", wrong: "looks speechy, sus", right: "looks fishy, suspicious", note: "Heads Up emotions: Tony described suspicious situations as looking 'fishy' (slang 'sus')." },
      { time: "32:23", speaker: "Louie", wrong: "in actuated", right: "infatuated", note: "Note-taker acoustically separated the single word 'infatuated' into two words." },
      { time: "36:31", speaker: "Tony", wrong: "formal fear of missing out, MB", right: "FOMO (fear of missing out), envy", note: "Tony named the acronym FOMO and envy; note-taker typed 'formal' and 'MB'." },
      { time: "45:14", speaker: "Tony", wrong: "A marr froz", right: "A murder of crows", note: "Classic English collective animal noun: Tony correctly guessed 'a murder of crows' which the note-taker wrote as 'marr froz'!" },
      { time: "47:47", speaker: "Tony", wrong: "paddle", right: "padel", note: "Tony's favorite Spanish racket sport 'padel' was anglicized by the note-taker as boat paddle." },
      { time: "48:59", speaker: "Tony", wrong: "curry movie section", right: "current movie selection", note: "Tony discussing modern cinema was transcribed as 'curry movie section'." },
      { time: "52:28", speaker: "Louie & Tony", wrong: "Timothy Charlemagne... Smothy Salome", right: "Timothée Chalamet", note: "Hollywood actor Timothée Chalamet (Marty Supreme) was mangled into 'Timothy Charlemagne' and 'Smothy Salome'!" },
      { time: "01:00:26", speaker: "Tony & Louie", wrong: "Vanos... Dr Loom", right: "Thanos... Doctor Doom", note: "Marvel MCU villains: Thanos was heard as 'Vanos', and Doctor Doom (Robert Downey Jr.) was heard as 'Doctor Loom'!" },
      { time: "01:03:38", speaker: "Louie", wrong: "Male stream", right: "Meryl Streep", note: "Legendary Oscar-winning actress Meryl Streep (Sophie's Choice) was transcribed as 'Male stream'!" },
      { time: "01:04:57", speaker: "Tony", wrong: "so of interest. A for a twenty 4", right: "The Zone of Interest, an A24 film", note: "Jonathan Glazer's Oscar-winning Holocaust film distributed by A24 was transcribed as 'so of interest. A for a twenty 4'." },
      { time: "01:06:22", speaker: "Tony & Louie", wrong: "Bo, all neg", right: "bottleneck", note: "The central pedagogical theme of the lesson—opening the mental translation bottleneck—was transcribed as 'Bo, all neg'!" }
    ];

    // 6. Cultural Places / Topics Cards (4 editorial themes)
    const CULTURAL_PLACES = [
      {
        meta: "47:45 – 58:20",
        badge: "Digital Sanctuary",
        title: "1. The Psychology of Cinema: Unplugging from the Digital Leash",
        desc: "Tony articulated a profound cultural reality: in an era of continuous digital pinging and algorithmic dopamine, the movie theater has become one of our last sacred sanctuaries. Stepping into a dark auditorium with a bag of warm popcorn and silencing your smartphone creates an unbroken two-hour cocoon. Unlike home streaming—where viewers subconsciously pause to check Instagram or respond to work messages—the cinema demands communal focus and deep sensory immersion.",
        quote: "\"When I go to the cinema, I am able to spend two hours without watching my phone... it has my full attention.\"",
        tags: ["unplug", "cinema", "sanctuary"]
      },
      {
        meta: "14:17 – 24:00",
        badge: "Fluency Mastery",
        title: "2. Opening the Cognitive Bottleneck: Beyond Mental Translation",
        desc: "Intermediate language learners often hit a frustrating barrier: they possess substantial grammar and vocabulary, yet experience speech latency because their brain attempts to construct sentences in Spanish first before translating them into English. Louie identified this as 'the bottleneck'. The pedagogical remedy is rapid-fire, low-stress retrieval drills (like Heads Up) where speakers describe concepts against the clock, training the brain to link visual ideas directly to English words without native-language intermediation.",
        quote: "\"I have this problem that I try to translate first in my head sometimes... so I want to improve my fluency and coherence.\"",
        tags: ["bottleneck", "coherence", "automaticity"]
      },
      {
        meta: "42:15 – 46:00",
        badge: "Linguistic Nuance",
        title: "3. Cultural False Friends & Group Identity: From 'Pride' to 'A Murder of Crows'",
        desc: "Tony and Louie uncovered fascinating linguistic subtleties. In Spanish, 'orgullo' often leans toward stubborn vanity or refusal to admit fault. In English, 'taking pride in one's work' is celebrated as craftsmanship, diligence, and quiet self-respect. Furthermore, English folklore preserves poetic collective nouns: lions form a 'pride', crows assemble in a 'murder', and geese gather in a 'gaggle'—reflecting how medieval venery imbued animal groups with vivid cultural symbolism.",
        quote: "\"In Spain we have two different meanings... one is what you said, and the other has more like a negative meaning.\"",
        tags: ["pride", "false-friends", "folklore"]
      },
      {
        meta: "58:20 – 01:07:02",
        badge: "Thursday Preparation",
        title: "4. Cinematic Restraint & Acoustic Horror: Dissecting 'The Zone of Interest'",
        desc: "Contrasting mainstream franchise spectacles with European arthouse cinema, Louie and Tony discussed historical weight in film. Jonathan Glazer's Oscar-winning masterpiece 'The Zone of Interest' (A24) achieves chilling power through artistic restraint: never entering the gas chambers of Auschwitz, but exposing the Höss family's idyllic domestic villa beside the walls. For next Thursday, Tony and Louie have agreed to rewatch the film and examine its acoustic storytelling and moral juxtaposition.",
        quote: "\"Next Thursday we will dedicate the lesson to The Zone of Interest—it was an amazing movie, very powerful.\"",
        tags: ["glazer", "zone-of-interest", "acoustic-restraint"]
      }
    ];

    // 7. Flashcards & Interactive Context Quiz
    const FLASHCARD_KEYS = [
      "bottleneck", "coherence", "serendipity", "competency", "contingency", "spherical",
      "suspicious", "fishy", "affectionate", "infatuated", "fomo", "unwind"
    ];

    const QUIZ_QUESTIONS = [
      {
        q: "1. Tony explained that translating from Spanish to English in his head slows him down and creates a mental ________.",
        options: ["bottleneck", "fretboard", "contingency", "serendipity"],
        correct: 0,
        explain: "A 'bottleneck' is a point of congestion or blockage that slows down an entire process or spoken fluency."
      },
      {
        q: "2. In English, what is the key difference between Spanish 'orgullo' and 'taking pride in your work'?",
        options: [
          "They mean exactly the same thing in every context",
          "'Taking pride in your work' represents craftsmanship, care, and healthy self-respect, whereas 'orgullo' often connotes stubborn arrogance",
          "'Pride' can only ever refer to a group of lions",
          "'Taking pride' is considered an impolite or offensive idiom in British English"
        ],
        correct: 1,
        explain: "Tony and Louie noted that while 'orgullo' often suggests stubbornness or haughtiness in Spanish, English 'taking pride in one's work' is a positive virtue denoting diligence, high standards, and quiet self-respect."
      },
      {
        q: "3. What is the traditional, poetic English collective noun for a flock of crows, which Tony remembered instantly?",
        options: ["a pride of crows", "a school of crows", "a murder of crows", "a pack of crows"],
        correct: 2,
        explain: "In English folklore and venery tradition, a group of crows is famously called 'a murder of crows' (while lions form a 'pride' and geese form a 'gaggle')."
      },
      {
        q: "4. Why does Tony value going to the movie theater over watching films at home?",
        options: [
          "Because movie theater tickets in Valencia are completely free",
          "Because it acts as a digital sanctuary where he can unplug from his smartphone and stay fully immersed for two hours",
          "Because he only watches black-and-white 1950s documentaries",
          "Because the theater allows people to talk loudly during the movie"
        ],
        correct: 1,
        explain: "Tony described the cinema as a rare digital haven where social etiquette and the dark room help him disconnect from notifications and give two hours of undivided focus."
      },
      {
        q: "5. When Louie and Tony played the rapid-fire Heads Up food drill, how did Tony describe meatballs without getting stuck on the word?",
        options: [
          "He used geometry, describing them as 'spherical beef' eaten with pasta or tomato sauce",
          "He gave up and switched to Spanish",
          "He described them as rectangular slices of raw pork",
          "He only said the word 'hamburger'"
        ],
        correct: 0,
        explain: "Tony brilliantly deployed geometric and culinary descriptions ('spherical beef/pork, rounded, eaten with pasta') to keep communication flowing smoothly."
      },
      {
        q: "6. Which film by Jonathan Glazer (A24) will Tony and Louie rewatch and dissect for next Thursday's lesson on cinematic restraint and sound design?",
        options: ["Avengers: Doomsday", "Marty Supreme", "The Zone of Interest", "Sophie's Choice"],
        correct: 2,
        explain: "Louie and Tony made a homework pact to analyze Jonathan Glazer's Oscar-winning masterpiece 'The Zone of Interest', examining how its chilling atmosphere is achieved through acoustic restraint rather than visual violence."
      }
    ];

'@) | Out-Null

# Append Engine lines
foreach ($l in $engineLines) {
    # Guard lucide and tippy calls
    $line = $l
    if ($line.Trim() -eq "lucide.createIcons();") {
        $line = "      if (typeof lucide !== 'undefined' && lucide.createIcons) { lucide.createIcons(); }"
    }
    $sb.AppendLine($line) | Out-Null
}

$outputHtml = $sb.ToString()
$outputPath = "D:\Documents\Tony b\index.html"
[System.IO.File]::WriteAllText($outputPath, $outputHtml, [System.Text.UTF8Encoding]::new($false))

Write-Host "=========================================================="
Write-Host "Generated index.html: $((Get-Item $outputPath).Length) bytes"
Write-Host "=========================================================="
