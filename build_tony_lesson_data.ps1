# build_tony_lesson_data.ps1
# Generates lesson_data.js for Tony B (Lesson: 3 November 2026)
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Compiling curated lesson data for Tony B..."

$rawLines = [System.IO.File]::ReadAllLines("D:\Documents\Tony b\Transcripts\11-03-2026.txt", [System.Text.Encoding]::UTF8)

# 1. Parse raw turns starting at 12:17 (when Louie and Tony connect)
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

Write-Host "Parsed $($rawTurns.Count) lesson turns from 12:17 onward."

$sb = [System.Text.StringBuilder]::new()

$sb.AppendLine(@"
// =============================================================================
// LESSON DATA: Tony B • 3 November 2026
// Tutor: Louie (Lewis O'Shea) | Student: Tony B (Valencia, Spain)
// Topics: Eliminating the Translation Bottleneck, Rapid Verbal Drills,
// Cinema as Digital Sanctuary, Cultural False Friends, and 'The Zone of Interest'
// =============================================================================
"@) | Out-Null

# 2. VOCAB_DB
$sb.AppendLine("const VOCAB_DB = {") | Out-Null

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
  @('showing-off', 'showing off', '/ˈʃəʊ.ɪŋ ɒf/', 'idiom', 'B2', '43:53', 'turn-206', 'idioms-expressions', 'Boastfully displaying one abilities, possessions, or status to impress onlookers.', 'Louie (43:53): "Pride is a good thing; it is not like ''look at me''—it is not showing off."', 'presumir / alardear'),
  @('pride-of-lions', 'pride of lions', '/praɪd əv ˈlaɪ.ənz/', 'noun', 'C1', '44:54', 'turn-208', 'culinary-lifestyle', 'The traditional English collective noun for a family group or social pack of lions.', 'Louie (44:54): "In English, we call a family of lions a pride—a pride of lions."', 'una manada de leones'),
  @('murder-of-crows', 'murder of crows', '/ˈmɜː.dər əv krəʊz/', 'noun', 'C1', '45:14', 'turn-212', 'idioms-expressions', 'The traditional poetic collective noun for a flock of crows in English venery and folklore.', 'Tony (45:14): "Yeah, I know that one... a murder of crows, right?" Louie: "Exactly!"', 'una bandada de cuervos'),
  @('gaggle-of-geese', 'gaggle of geese', '/ˈɡæɡ.əl əv ɡiːs/', 'noun', 'C1', '45:40', 'turn-216', 'idioms-expressions', 'The traditional collective noun for a flock of geese gathered together on ground or water.', 'Louie (45:40): "A gaggle of geese—gaggle is like a group of geese."', 'una bandada de gansos'),
  @('what-is-good-for-the-goose', 'what is good for the goose', '/wɒt ɪz ɡʊd fə ðə ɡuːs/', 'idiom', 'C1', '45:40', 'turn-216', 'idioms-expressions', 'What is acceptable or beneficial for one person is equally fair and acceptable for another.', 'Louie (45:40): "What is good for the goose is good for the gander—an old English idiom."', 'lo que es bueno para uno, es bueno para todos'),
  @('conscience', 'conscience', '/ˈkɒn.ʃəns/', 'noun', 'B2', '46:08', 'turn-220', 'abstract-philosophy', 'An inner moral sense that acts as a guide to the ethical rightness or wrongness of one behavior.', 'Louie (46:08): "Conscience—what does your conscience tell you? Is it a good thing or a bad thing?"', 'la conciencia moral'),
  @('inner-monologue', 'inner monologue', '/ˈɪn.ər ˈmɒn.ə.lɒɡ/', 'noun', 'C1', '46:08', 'turn-220', 'psychology-emotions', 'The ongoing internal vocalization of thoughts, questions, and narratives within one mind.', 'Louie (46:08): "In your head, we call it the inner monologue—your internal stream of thoughts."', 'el monólogo interior'),
  @('conscientious', 'conscientious', '/ˌkɒn.ʃiˈen.ʃəs/', 'adjective', 'C1', '46:42', 'turn-222', 'psychology-emotions', 'Wishing to do what is right; thorough, diligent, and meticulous in one duties or studies.', 'Louie (46:42): "Conscientious—someone who is thoughtful and careful about doing things right."', 'concienzudo / diligente'),
  @('padel', 'padel', '/ˈpæd.əl/', 'noun', 'B2', '47:47', 'turn-231', 'culinary-lifestyle', 'A dynamic racket sport of Spanish and Mexican origin, played in doubles inside an enclosed glass court.', 'Tony (47:47): "I really enjoy doing sports—I do cycling, I play padel, and keep active."', 'el pádel'),
  @('downtime', 'downtime', '/ˈdaʊn.taɪm/', 'noun', 'B2', '48:00', 'turn-233', 'culinary-lifestyle', 'Quiet personal time spent relaxing, recharging, and resting away from professional work.', 'Tony (48:00): "That is basically how I like to spend my downtime—outdoors and going to the cinema."', 'el tiempo libre / descanso'),
  @('unwind', 'unwind', '/ʌnˈwaɪnd/', 'verb', 'B2', '13:57', 'turn-6', 'culinary-lifestyle', 'To relax, release stress, and let go of tension after intensive work or busy days.', 'Tony (13:57): "I booked this class at five... so I can go home and completely unwind."', 'desconectar / relajarse'),
  @('unplug', 'unplug', '/ʌnˈplʌɡ/', 'verb', 'B2', '56:40', 'turn-260', 'cinema-culture', 'To disconnect temporarily from digital screens, smartphone notifications, and constant connectivity.', 'Tony (56:40): "When I go to the cinema, I unplug from my phone for two hours without looking at it."', 'desconexión de la tecnología / pantallas'),
  @('immersive', 'immersive', '/ɪˈmɜː.sɪv/', 'adjective', 'C1', '56:40', 'turn-260', 'cinema-culture', 'Generating an atmosphere that deeply absorbs one senses and completely captures total attention.', 'Tony (56:40): "The environment, the smell of popcorn, the big screen... it is totally immersive."', 'inmersivo / envolvente'),
  @('communal', 'communal', '/ˈkɒm.jə.nəl/', 'adjective', 'C1', '57:12', 'turn-262', 'cinema-culture', 'Shared by all members of an audience or community; experienced collectively.', 'Louie (57:12): "You share a room with people who made an effort to be there—it is a communal experience."', 'comunitario / compartido'),
  @('blockbuster', 'blockbuster', '/ˈblɒkˌbʌs.tər/', 'noun', 'B2', '59:04', 'turn-274', 'cinema-culture', 'A major motion picture produced on a large budget with immense commercial success and popular appeal.', 'Tony (59:04): "I think those are the three big blockbusters of this quarter of the year."', 'el taquillazo / éxito de taquilla'),
  @('franchise', 'franchise', '/ˈfræn.tʃaɪz/', 'noun', 'B2', '59:38', 'turn-278', 'cinema-culture', 'A media property or film series sharing continuous characters, fictional lore, and recurring sequels.', 'Tony (59:38): "They are bringing back one of the most famous actors in this franchise—Robert Downey Jr."', 'la franquicia cinematográfica'),
  @('hype', 'hype', '/haɪp/', 'noun', 'B2', '59:52', 'turn-281', 'cinema-culture', 'Extensive, energetic publicity, buzz, and eager anticipation generated around a movie or event.', 'Tony (59:52): "Bringing him back as Doctor Doom is creating an enormous amount of hype."', 'el bombo publicitario / la gran expectación'),
  @('stakes', 'stakes', '/steɪks/', 'noun', 'C1', '53:19', 'turn-249', 'cinema-culture', 'The critical risks, emotional costs, or vital rewards hanging in the balance of a drama.', 'Louie (53:19): "In Marty Supreme, it does not stop—the stakes keep on rising every minute."', 'lo que está en juego / la tensión dramática'),
  @('cinematic-restraint', 'cinematic restraint', '/ˌsɪn.əˈmæt.ɪk rɪˈstreɪnt/', 'noun', 'C1', '01:04:43', 'turn-310', 'cinema-culture', 'The artistic discipline of evoking powerful emotions through subtlety rather than sensational melodrama.', 'Louie & Tony (01:04:43): "The Zone of Interest is chilling because of its cinematic restraint—the camera never enters the camp."', 'la contención cinematográfica'),
  @('back-catalog', 'back catalog', '/bæk ˈkæt.əl.ɒɡ/', 'noun', 'C1', '01:01:31', 'turn-296', 'cinema-culture', 'All the past works, older movies, or historic releases in a filmmaker or cinema archive.', 'Louie (01:01:31): "Is there something from your back catalog—films from the past you want to rewatch?"', 'la filmoteca histórica / catálogo previo'),
  @('suppress', 'suppress', '/səˈpres/', 'verb', 'C1', '01:03:29', 'turn-303', 'psychology-emotions', 'To deliberately or subconsciously push down and conceal painful, traumatic memories or feelings.', 'Louie (01:03:29): "In Sophie Choice, she suppressed her memories—suppress means to push down and hide."', 'reprimir / sofocar recuerdos'),
  @('architectural-restoration', 'architectural restoration', '/ˌɑː.kɪˈtek.tʃər.əl ˌres.tərˈeɪ.ʃən/', 'noun', 'C1', '50:03', 'turn-242', 'culinary-lifestyle', 'The skilled preservation and technical rebuilding of historic stone buildings and heritage structures.', 'Louie (50:03): "I used to work in architectural restoration—rebuilding 700-year-old historic stone buildings in Oxfordshire."', 'la restauración arquitectónica'),
  @('revitalize', 'revitalize', '/ˌriːˈvaɪ.təl.aɪz/', 'verb', 'C1', '50:03', 'turn-242', 'culinary-lifestyle', 'To give new life, cultural energy, vitality, or economic activity to an old area or high street.', 'Louie (50:03): "We would rebuild them and put businesses in them to revitalize the whole historic street."', 'revitalizar / reactivar'),
  @('second-nature', 'second nature', '/ˌsek.ənd ˈneɪ.tʃər/', 'idiom', 'C1', '01:06:27', 'turn-316', 'language-fluency', 'A skill or spoken habit that has become so instinctive that it requires no conscious effort.', 'Louie (01:06:27): "With regular practice, direct English thinking becomes second nature—no translation needed."', 'una segunda naturaleza / instintivo'),
  @('forbearance', 'forbearance', '/fɔːˈbeə.rəns/', 'noun', 'C2', '41:56', 'turn-190', 'abstract-philosophy', 'Patient self-control, restraint, and tolerance when faced with provocation or injury.', 'Louie (41:56): "Turning the other cheek requires profound moral forbearance."', 'la tolerancia paciente / indulgencia')
)

foreach ($row in $vocabData) {
    $k = $row[0]
    $w = $row[1]
    $ipa = $row[2]
    $pos = $row[3]
    $lvl = $row[4]
    $time = $row[5]
    $tId = $row[6]
    $cat = $row[7]
    $def = $row[8] -replace '"', '\"'
    $q = $row[9] -replace '"', '\"'
    $es = $row[10] -replace '"', '\"'
    $sb.AppendLine("  `"$k`": { word: `"$w`", ipa: `"$ipa`", pos: `"$pos`", level: `"$lvl`", time: `"$time`", turnId: `"$tId`", cat: `"$cat`", def: `"$def`", quote: `"$q`", es: `"$es`" },") | Out-Null
}
$sb.AppendLine("};`n") | Out-Null

# 3. ASR_FIXES
$sb.AppendLine("const ASR_FIXES = [") | Out-Null
$fixesData = @(
  @('13:57', 'Tony', 'and the Escoonnade relax', 'and just unwind and relax', 'Tony described unwinding at home after his office day; speech-to-text mangled ''and just unwind'' into ''Escoonnade''.'),
  @('16:33', 'Louie', 'iOS grading, compensancy', 'IELTS grading, CEFR competency', 'Louie explaining language proficiency benchmarks; note-taker heard ''iOS grading, compensancy'' instead of ''IELTS / CEFR competency''.'),
  @('25:01', 'Tony', 'A tfle of beef that it''s rounded... and e it with rice', 'A ball of beef that is rounded... and eat it with rice', 'Heads Up food drill: note-taker typed ''tfle'' for ball/patty and ''e it'' for eat it.'),
  @('25:40', 'Tony & Louie', 'feric... Mospher beef', 'spherical... spherical beef', 'Tony described the geometry of meatballs as ''spherical''; note-taker split it into ''feric'' and ''Mospher''.'),
  @('28:48', 'Tony', 'Estra chaa... Noelle of frozen a gelado', 'Stracciatella... artisanal frozen gelato', 'Heads Up Italian desserts: Tony named the famous chocolate-flake gelato flavor Stracciatella.'),
  @('30:02', 'Tony & Louie', 'Sabile... my Loom''s', 'Seville... my mum''s', 'Geographical mishearing: the Andalusian capital Seville was heard as ''Sabile'', and Louie''s mum as ''Loom''s''.'),
  @('31:43', 'Tony', 'looks speechy, sus', 'looks fishy, suspicious', 'Heads Up emotions: Tony described suspicious situations as looking ''fishy'' (slang ''sus'').'),
  @('32:23', 'Louie', 'in actuated', 'infatuated', 'Note-taker acoustically separated the single word ''infatuated'' into two words.'),
  @('36:31', 'Tony', 'formal fear of missing out, MB', 'FOMO (fear of missing out), envy', 'Tony named the acronym FOMO and envy; note-taker typed ''formal'' and ''MB''.'),
  @('45:14', 'Tony', 'A marr froz', 'A murder of crows', 'Classic English collective animal noun: Tony correctly guessed ''a murder of crows'' which the note-taker wrote as ''marr froz''!'),
  @('47:47', 'Tony', 'paddle', 'padel', 'Tony''s favorite Spanish racket sport ''padel'' was anglicized by the note-taker as boat paddle.'),
  @('48:59', 'Tony', 'curry movie section', 'current movie selection', 'Tony discussing modern cinema was transcribed as ''curry movie section''.'),
  @('52:28', 'Louie & Tony', 'Timothy Charlemagne... Smothy Salome', 'Timothée Chalamet', 'Hollywood actor Timothée Chalamet (Marty Supreme) was mangled into ''Timothy Charlemagne'' and ''Smothy Salome''!'),
  @('01:00:26', 'Tony & Louie', 'Vanos... Dr Loom', 'Thanos... Doctor Doom', 'Marvel MCU villains: Thanos was heard as ''Vanos'', and Doctor Doom (Robert Downey Jr.) was heard as ''Doctor Loom''!'),
  @('01:03:38', 'Louie', 'Male stream', 'Meryl Streep', 'Legendary Oscar-winning actress Meryl Streep (Sophie''s Choice) was transcribed as ''Male stream''!'),
  @('01:04:57', 'Tony', 'so of interest. A for a twenty 4', 'The Zone of Interest, an A24 film', 'Jonathan Glazer''s Oscar-winning Holocaust film distributed by A24 was transcribed as ''so of interest. A for a twenty 4''.'),
  @('01:06:22', 'Tony & Louie', 'Bo, all neg', 'bottleneck', 'The central pedagogical theme of the lesson—opening the mental translation bottleneck—was transcribed as ''Bo, all neg''!')
)
foreach ($f in $fixesData) {
    $time = $f[0]
    $spk = $f[1]
    $wrong = $f[2] -replace '"', '\"'
    $right = $f[3] -replace '"', '\"'
    $note = $f[4] -replace '"', '\"'
    $sb.AppendLine("  { time: `"$time`", speaker: `"$spk`", wrong: `"$wrong`", right: `"$right`", note: `"$note`" },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 4. NATURAL_STRENGTHS
$sb.AppendLine("const NATURAL_STRENGTHS = [") | Out-Null
$strengthsData = @(
  @('Intuitive Abstract Conceptualization', 'When you are a kid and you are incapable of seeing the bad side of people... innocence.', '41:20', 'Describing nuanced abstract concepts under a strict 90-second time constraint requires quick lexical retrieval. You pinpointed ''innocence'' and ''forgiveness'' effortlessly without hesitation.'),
  @('Geometric & Culinary Precision', 'It is beef that you shape it round... it is spherical... it is not a hamburger, you eat it with pasta.', '25:01', 'Instead of getting stuck on the noun ''meatballs'', you immediately deployed geometric vocabulary (''spherical'') and ingredient distinctions (minced beef/pork vs hamburger patties).'),
  @('Cultural & Semantic Discernment (Pride vs Orgullo)', 'In Spain we have two different meanings... one is what you said, and the other has more like a negative meaning.', '43:29', 'You astutely recognized that Spanish ''orgullo'' often connotes stubborn arrogance, whereas English ''taking pride in your work'' represents craftsmanship, self-respect, and care.'),
  @('Rich Cinematic Fluency & Insight', 'When I go to the cinema, I am able to spend two hours without watching my phone... it has my full attention.', '57:13', 'You spoke compellingly about modern cinema as a digital sanctuary. You comfortably navigated industry terms like ''blockbusters'', ''franchise'', ''hype'', and atmospheric immersion.'),
  @('Spontaneous Idiomatic Recall (A Murder of Crows)', 'Yeah, I know that one... a murder of crows, right?', '45:14', 'When Louie introduced quirky English collective animal nouns, you instantly recalled ''a murder of crows''—one of the most poetic and challenging idioms in British folklore!'),
  @('Accurate Meta-Linguistic Self-Awareness', 'I have this problem that I try to translate first in my head sometimes... so I want to improve my fluency and coherence.', '14:24', 'Diagnosing your own cognitive bottleneck with total honesty and precision. Identifying the mental translation reflex is the essential foundation for building direct English automaticity.')
)
foreach ($s in $strengthsData) {
    $t = $s[0]
    $q = $s[1] -replace '"', '\"'
    $tm = $s[2]
    $an = $s[3] -replace '"', '\"'
    $sb.AppendLine("  { title: `"$t`", quote: `"$q`", time: `"$tm`", analysis: `"$an`" },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 5. PHRASING_POLISHES
$sb.AppendLine("const PHRASING_POLISHES = [") | Out-Null
$polishesData = @(
  @('I booked this class at five so I can do it from here and then go home and the Escoonnade relax.', '13:57', 'I booked this class at 5:00 so I could take it from the office, head home, and completely unwind.', 'The verb ''unwind'' is the perfect British phrase for shedding workday stress, while ''so I could take it'' maintains past-conditional harmony.'),
  @('I have sometimes this lack of coherence when making my phrases.', '14:24', 'I occasionally struggle with sentence coherence when formulating complex ideas.', 'Placing the frequency adverb ''occasionally'' before the verb creates natural English cadence, and ''formulating complex ideas'' sounds elegant.'),
  @('It could be made of beef or pork, it is very popular to eat with tomato sauce.', '25:46', 'They can be made with either minced beef or pork, and they are typically served in a rich tomato sauce.', 'Referring to meatballs in the plural (''they'') and specifying ''minced beef'' gives accurate culinary texture.'),
  @('When you don''t trust what someone is telling you... when something looks speechy, sus.', '31:15', 'When you have reservations about what you are being told, or when a situation feels a bit fishy and suspicious.', 'Replacing the note-taker''s ''speechy'' with the colloquial idiom ''feels fishy'' complements your casual use of ''sus''.'),
  @('This is the sort of things I look forward to do in my spare time.', '47:47', 'These are the kinds of activities I look forward to doing in my downtime.', 'The phrasal verb ''look forward to'' requires the gerund (''doing''), and ''downtime'' is a warm native synonym for spare time.'),
  @('When I go to the cinema, I am able to spend two hours without watching my phone.', '57:13', 'Going to the cinema allows me to unplug from my phone and stay fully immersed for two whole hours.', 'Native speakers say ''checking my phone'' or ''unplugging from screens'' rather than ''watching my phone'', and ''stay fully immersed'' conveys deep presence.')
)
foreach ($p in $polishesData) {
    $orig = $p[0] -replace '"', '\"'
    $tm = $p[1]
    $pol = $p[2] -replace '"', '\"'
    $an = $p[3] -replace '"', '\"'
    $sb.AppendLine("  { original: `"$orig`", time: `"$tm`", polished: `"$pol`", analysis: `"$an`" },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 6. EDITORIAL_TOPICS
$sb.AppendLine("const EDITORIAL_TOPICS = [") | Out-Null
$topicsData = @(
  @('The Psychology of Cinema: Unplugging from the Digital Leash', 'Culture & Well-being', '47:45 – 58:20', 'Digital Sanctuary', 'Tony articulated a profound cultural reality: in an era of continuous digital pinging and algorithmic dopamine, the movie theater has become one of our last sacred sanctuaries. Stepping into a dark auditorium with a bag of warm popcorn and silencing your smartphone creates an unbroken two-hour cocoon. Unlike home streaming—where viewers subconsciously pause to check Instagram or respond to work messages—the cinema demands communal focus and deep sensory immersion.', @('unplug', 'immersive', 'communal', 'downtime')),
  @('Opening the Cognitive Bottleneck: Beyond Mental Translation', 'Linguistic Acquisition', '14:17 – 24:00', 'Fluency Mastery', 'Intermediate language learners often hit a frustrating barrier: they possess substantial grammar and vocabulary, yet experience speech latency because their brain attempts to construct sentences in Spanish first before translating them into English. Louie identified this as ''the bottleneck''. The pedagogical remedy is rapid-fire, low-stress retrieval drills (like Heads Up) where speakers describe concepts against the clock, training the brain to link visual ideas directly to English words without native-language intermediation.', @('bottleneck', 'coherence', 'second-nature', 'contingency')),
  @('Cultural False Friends & Group Identity: From ''Pride'' to ''A Murder of Crows''', 'Pragmatics & Folklore', '42:15 – 46:00', 'Linguistic Nuance', 'Tony and Louie uncovered fascinating linguistic subtleties. In Spanish, ''orgullo'' often leans toward stubborn vanity or refusal to admit fault. In English, ''taking pride in one''s work'' is celebrated as craftsmanship, diligence, and quiet self-respect. Furthermore, English folklore preserves poetic collective nouns: lions form a ''pride'', crows assemble in a ''murder'', and geese gather in a ''gaggle''—reflecting how medieval venery imbued animal groups with vivid cultural symbolism.', @('pride', 'take-pride-in', 'murder-of-crows', 'gaggle-of-geese')),
  @('Cinematic Restraint & Memory: From San Sebastián to ''The Zone of Interest''', 'Film Analysis & Homework', '58:20 – 01:07:02', 'Thursday Preparation', 'Contrasting mainstream franchise spectacles (like Avengers: Doomsday) with European arthouse cinema, Louie and Tony discussed historical weight in film. Jonathan Glazer''s Oscar-winning masterpiece ''The Zone of Interest'' (A24) achieves chilling power through artistic restraint: never entering the gas chambers of Auschwitz, but exposing the Höss family''s idyllic domestic villa beside the walls. For next Thursday, Tony and Louie have agreed to rewatch the film and examine its acoustic storytelling and moral juxtaposition.', @('cinematic-restraint', 'suppress', 'back-catalog', 'stakes'))
)
foreach ($td in $topicsData) {
    $t = $td[0]
    $tag = $td[1]
    $tm = $td[2]
    $b = $td[3]
    $desc = $td[4] -replace '"', '\"'
    $kw = ($td[5] | ForEach-Object { "`"$_`"" }) -join ", "
    $sb.AppendLine("  { title: `"$t`", tag: `"$tag`", time: `"$tm`", badge: `"$b`", desc: `"$desc`", keywords: [$kw] },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 7. FLASHCARDS
$sb.AppendLine("const FLASHCARDS = [") | Out-Null
$cardsData = @(
  @('bottleneck', 'bottleneck', '/ˈbɒt.əl.nek/', 'B2', 'A point of congestion or blockage that slows down an entire process or spoken fluency.', 'Louie: ''We want to open that mental bottleneck so you speak without translating.''', 'el cuello de botella / atasco'),
  @('coherence', 'coherence', '/kəʊˈhɪə.rəns/', 'B2', 'The quality of being clear, logical, and readily understood by the listener.', 'Tony: ''I want to build my coherence when constructing complex sentences.''', 'la coherencia / claridad lógica'),
  @('spherical', 'spherical', '/ˈsfer.ɪ.kəl/', 'B2', 'Shaped like a sphere, ball, or round globe.', 'Tony: ''It is made of beef, shaped round and spherical—meatballs!''', 'esférico / redondeado'),
  @('apologetic', 'apologetic', '/əˌpɒl.əˈdʒet.ɪk/', 'B2', 'Showing genuine regret for an accidental mistake; polite and considerate.', 'Louie: ''Being apologetic is considerate and polite—showing emotional maturity.''', 'arrepentido / educado al disculparse'),
  @('affectionate', 'affectionate', '/əˈfek.ʃən.ət/', 'B2', 'Readily feeling or displaying warmth, tenderness, and gentle care.', 'Louie: ''Animals and children can be deeply affectionate without it being romantic.''', 'afectuoso / cariñoso'),
  @('innocence', 'innocence', '/ˈɪn.ə.səns/', 'B2', 'Freedom from guilt or moral wrong; inability to see malice in others.', 'Tony: ''When you are a child and incapable of seeing bad in people—innocence.''', 'la inocencia'),
  @('turn-the-other-cheek', 'turn the other cheek', '/tɜːn ði ˈʌð.ər tʃiːk/', 'C1', 'To refrain from retaliating when wronged; practicing peaceful forbearance.', 'Louie: ''Turn the other cheek—refusing to retaliate with anger.''', 'poner la otra mejilla'),
  @('take-pride-in', 'take pride in', '/teɪk praɪd ɪn/', 'B2', 'To derive deep satisfaction from craftsmanship and doing things properly.', 'Louie: ''Taking pride in your work means respecting your own time and craft.''', 'enorgullecerse de / poner esmero en'),
  @('murder-of-crows', 'murder of crows', '/ˈmɜː.dər əv krəʊz/', 'C1', 'The traditional poetic collective noun for a flock of crows.', 'Tony: ''A murder of crows—I know that English animal idiom!''', 'una bandada de cuervos'),
  @('cinematic-restraint', 'cinematic restraint', '/ˌsɪn.əˈmæt.ɪk rɪˈstreɪnt/', 'C1', 'The artistic power of subtle realism and off-screen suggestion rather than melodrama.', 'Louie: ''The Zone of Interest relies on eerie cinematic restraint.''', 'la contención cinematográfica'),
  @('unplug', 'unplug', '/ʌnˈplʌɡ/', 'B2', 'To disconnect temporarily from digital screens and mobile notifications.', 'Tony: ''At the cinema, I unplug from my phone for two uninterrupted hours.''', 'desconectar de la tecnología'),
  @('second-nature', 'second nature', '/ˌsek.ənd ˈneɪ.tʃər/', 'C1', 'An automatic habit or reflex mastered through consistent practice.', 'Louie: ''With enough low-stress practice, speaking English becomes second nature.''', 'una segunda naturaleza')
)
foreach ($cd in $cardsData) {
    $vk = $cd[0]
    $fr = $cd[1]
    $ipa = $cd[2]
    $lvl = $cd[3]
    $bdef = $cd[4] -replace '"', '\"'
    $ex = $cd[5] -replace '"', '\"'
    $es = $cd[6] -replace '"', '\"'
    $sb.AppendLine("  { vocabKey: `"$vk`", front: `"$fr`", ipa: `"$ipa`", level: `"$lvl`", backDef: `"$bdef`", exampleQuote: `"$ex`", es: `"$es`" },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 8. IDIOM_CHALLENGES
$sb.AppendLine("const IDIOM_CHALLENGES = [") | Out-Null
$idiomsData = @(
  @{
    title = "The Hesitation at the Dinner Party"
    scenario = "You are at an international dinner in Valencia. You have a sharp observation to share, but by the time you mentally translate every sentence from Spanish to English, the conversation has moved on. What concept describes this barrier, and what is the best strategy?"
    options = @(
      "A linguistic bottleneck — practice rapid, uninhibited speech drills to bypass native-language translation",
      "A lack of vocabulary — memorize 500 more irregular verbs before speaking again",
      "Social understatement — remain silent to show British politeness",
      "A Freudian slip — apologize profusely to everyone at the table"
    )
    correctIndex = 0
    explanation = "This is the classic ''mental translation bottleneck''. The solution is not cramming grammar, but training direct verbal reflexes through communicative exercises."
    es = "superar el cuello de botella mental"
  },
  @{
    title = "The Two-Hour Screen Detox"
    scenario = "Your phone buzzes constantly with notifications. You buy a ticket for an evening screening at the cinema, silence your phone, and place it in your coat pocket for the entire film. Which phrase best describes this conscious act?"
    options = @(
      "Taking French leave",
      "Unplugging from the digital leash to immerse in the moment",
      "Turning the other cheek",
      "Feeding into the hype"
    )
    correctIndex = 1
    explanation = "To ''unplug'' means to intentionally disconnect from electronic communications to regain presence, mental peace, and sensory focus."
    es = "desconectar de la tecnología"
  },
  @{
    title = "The Artisan's Dedication"
    scenario = "An artisan spends twelve hours meticulously hand-carving a wooden violin bridge, checking every millimeter until it resonates cleanly. When complimented, they say they simply believe in doing things properly. Which English phrase captures this attitude?"
    options = @(
      "Showing off their status",
      "Taking genuine pride in their work",
      "Suffering from destructive FOMO",
      "Being overly apologetic"
    )
    correctIndex = 1
    explanation = "''Taking pride in one''s work'' is the English ideal of quiet craftsmanship and personal integrity—completely distinct from arrogant boasting."
    es = "enorgullecerse del propio oficio"
  },
  @{
    title = "The Spilled Cider & The Courteous Reaction"
    scenario = "At a busy terrace cafe, someone accidentally bumps your table and knocks over your glass of apple cider. They immediately help you clean up, offer to buy a replacement, and express sincere regret with a warm smile. How would you describe their manner?"
    options = @(
      "Cold and suspicious",
      "Genuinely apologetic and courteous",
      "Deeply envious of your table",
      "Stubborn and defensive"
    )
    correctIndex = 1
    explanation = "Being ''apologetic'' in this conversational sense is a mark of social grace and emotional maturity—apologizing readily without drama."
    es = "disculparse con cortesía y madurez"
  },
  @{
    title = "The Neighbor's New Sports Car"
    scenario = "Your neighbor pulls into the driveway with a gleaming new convertible. For a moment, you feel a twinge of discontent with your own car, until you remember your mountain bike rides and quiet lifestyle. Which proverb captures this insight?"
    options = @(
      "What is good for the goose is good for the gander",
      "Comparison is the thief of joy",
      "A bird in the hand is worth two in the bush",
      "Turn the other cheek"
    )
    correctIndex = 1
    explanation = "''Comparison is the thief of joy'' (as Louie cited) reminds us that measuring our personal journey against others erodes present happiness."
    es = "la comparación es el ladrón de la alegría"
  }
)
foreach ($im in $idiomsData) {
    $t = $im.title
    $sc = $im.scenario -replace '"', '\"'
    $opts = ($im.options | ForEach-Object { "`"$($_ -replace '"', '\"')`"" }) -join ", "
    $ci = $im.correctIndex
    $exp = $im.explanation -replace '"', '\"'
    $es = $im.es
    $sb.AppendLine("  { title: `"$t`", scenario: `"$sc`", options: [$opts], correctIndex: $ci, explanation: `"$exp`", es: `"$es`" },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 9. QUIZ_QUESTIONS
$sb.AppendLine("const QUIZ_QUESTIONS = [") | Out-Null
$quizData = @(
  @{
    question = "Why did Louie suggest that intermediate language learners experience a ''bottleneck'' when speaking?"
    options = @(
      "Because they lack sufficient grammar books",
      "Because they formulate thoughts in their native language first and try to translate in real-time, creating latency",
      "Because native English speakers speak twice as fast as Mediterranean speakers",
      "Because English vocabulary has too many Latin cognates"
    )
    correctIndex = 1
    explanation = "When learners construct thoughts in Spanish first and translate word-for-word, working memory bottlenecks. Rapid drills train direct conceptual-to-English reflexes."
    esHint = "el cuello de botella cognitivo"
  },
  @{
    question = "How does the English expression ''taking pride in your work'' differ from the negative connotation of Spanish ''orgullo'' discussed in class?"
    options = @(
      "In English, pride always signifies arrogant boasting and showing off",
      "In English, taking pride in your work represents craftsmanship, diligence, and healthy self-respect, rather than stubborn vanity",
      "There is no difference; both languages treat pride strictly as a flaw",
      "English only uses ''pride'' when discussing wild animals in Africa"
    )
    correctIndex = 1
    explanation = "While Spanish ''orgullo'' can imply stubbornness or conceit, English ''taking pride in one''s work'' is a respected virtue denoting craftsmanship and care."
    esHint = "el orgullo como esmero y dignidad"
  },
  @{
    question = "Which of the following is the traditional English poetic collective noun for a flock of crows, which Tony correctly recalled during the drill?"
    options = @(
      "A pride of crows",
      "A gaggle of crows",
      "A murder of crows",
      "A school of crows"
    )
    correctIndex = 2
    explanation = "In English folklore and traditional venery, a group of crows is famously called ''a murder of crows'' (while lions form a ''pride'' and geese form a ''gaggle'')."
    esHint = "sustantivos colectivos poéticos"
  },
  @{
    question = "What unique benefit of going to the cinema did Tony highlight compared to watching movies on streaming platforms at home?"
    options = @(
      "Movie theaters have louder speakers and cheaper snacks",
      "The cinema creates an immersive environment where one can unplug from smartphone notifications for two whole hours",
      "Cinema tickets in Valencia are subsidized by the local government",
      "Home televisions cannot display 4K resolution"
    )
    correctIndex = 1
    explanation = "Tony noted that at home he constantly checks notifications and Instagram, whereas the movie theater provides two hours of uninterrupted, phone-free immersion."
    esHint = "desconexión digital en la sala de cine"
  },
  @{
    question = "What distinguishes the Hanoi International Film Festival experience that Louie described from traditional European red-carpet festivals like San Sebastián?"
    options = @(
      "Hanoi only screens black-and-white silent movies from the 1920s",
      "In Hanoi and Da Nang, screenings across city cinemas are free to the public, with live Q&As with the director and cast",
      "Only accredited journalists and Hollywood actors are allowed inside the theaters",
      "Audience members must submit a movie review before being admitted"
    )
    correctIndex = 1
    explanation = "Louie shared that during festival season in Vietnam, cinemas in Hanoi and Da Nang offer free admission to the public, paired with engaging open Q&A sessions with the film crews and student creators."
    esHint = "festivales de cine comunitarios en Hanói"
  },
  @{
    question = "Why did Louie and Tony agree to both rewatch and discuss Jonathan Glazer''s Oscar-winning film ''The Zone of Interest'' for their next lesson?"
    options = @(
      "It is a fast-paced Hollywood action blockbuster with superhero cameos",
      "It provides a profound study in cinematic restraint and sound design, depicting historical atrocity through everyday domestic banality",
      "It is a lighthearted comedy about German gardening",
      "It was filmed entirely on location in Valencia, Spain"
    )
    correctIndex = 1
    explanation = "Distributed by A24, ''The Zone of Interest'' is renowned for its chilling artistic restraint—never showing the horrors inside Auschwitz directly, but capturing them entirely through brilliant off-screen sound design and domestic juxtaposition."
    esHint = "contención cinematográfica y diseño sonoro"
  }
)
foreach ($qd in $quizData) {
    $q = $qd.question -replace '"', '\"'
    $opts = ($qd.options | ForEach-Object { "`"$($_ -replace '"', '\"')`"" }) -join ", "
    $ci = $qd.correctIndex
    $exp = $qd.explanation -replace '"', '\"'
    $es = $qd.esHint
    $sb.AppendLine("  { question: `"$q`", options: [$opts], correctIndex: $ci, explanation: `"$exp`", esHint: `"$es`" },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 10. REFLECTION_PROMPTS
$sb.AppendLine("const REFLECTION_PROMPTS = [") | Out-Null
$reflectionsData = @(
  @{
    title = "The Architecture of Restraint in ''The Zone of Interest''"
    category = "Film Analysis & Homework Pact"
    prompt = "Ahead of our discussion next Thursday, rewatch ''The Zone of Interest''. Observe how director Jonathan Glazer chooses *not* to show the horrors of Auschwitz visually, but makes them inescapable through ambient sound design (furnaces, distant trains, shouts). How does this acoustic restraint compare to traditional historical dramas?"
    prepAdvice = "Jot down 2-3 specific acoustic moments that stood out to you. Practice explaining your impressions using vocabulary like ''restraint'', ''juxtaposition'', and ''immersive''."
  },
  @{
    title = "Deconstructing the Mental Translation Reflex"
    category = "Linguistic Fluency & Cognitive Habits"
    prompt = "Over the next four days, identify the moments during your workday or downtime when you catch yourself translating from Spanish into English in your head before speaking. What triggers the bottleneck: grammar anxiety, vocabulary search, or speed pressure?"
    prepAdvice = "Try describing 3 everyday objects or office tasks in English using simple, spontaneous descriptions under 30 seconds (just like our Heads Up game)."
  },
  @{
    title = "The Communal Sanctuary of the Movie Theater"
    category = "Lifestyle & Cultural Observation"
    prompt = "Consider the modern epidemic of digital distraction. Why has the cinema become one of the last remaining public spaces where people willingly surrender their smartphones for two hours? Is it the ticket cost, the collective social contract, or the sheer sensory power of the big screen?"
    prepAdvice = "Prepare a 60-second spoken commentary on whether home streaming can ever truly replace the theatrical experience."
  }
)
foreach ($r in $reflectionsData) {
    $t = $r.title -replace '"', '\"'
    $cat = $r.category
    $p = $r.prompt -replace '"', '\"'
    $pa = $r.prepAdvice -replace '"', '\"'
    $sb.AppendLine("  { title: `"$t`", category: `"$cat`", prompt: `"$p`", prepAdvice: `"$pa`" },") | Out-Null
}
$sb.AppendLine("];`n") | Out-Null

# 11. Process and emit TRANSCRIPT_TURNS with 3-Phase Token Replacement
$sb.AppendLine("const TRANSCRIPT_TURNS = [") | Out-Null

$chapEmitted = @{ 1=$false; 2=$false; 3=$false; 4=$false; 5=$false; 6=$false }

for ($i = 0; $i -lt $rawTurns.Count; $i++) {
    $turn = $rawTurns[$i]
    $tId = "turn-" + ($i + 1)
    $spk = $turn.Speaker
    $time = $turn.Time
    $rawText = $turn.Text
    
    $timeParts = $time -split ":"
    $mins = 0
    if ($timeParts.Count -eq 3) {
        $mins = ([int]$timeParts[0] * 60) + [int]$timeParts[1]
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
        $chapTitle = "Chapter II • Rapid-Fire Verbal Drills — Culinary Geometry & Mediterranean Roots (20:30 – 30:30)"
    }
    elseif (-not $chapEmitted[3] -and $mins -ge 30 -and ($mins -gt 30 -or [int]$timeParts[1] -ge 30)) {
        $chapEmitted[3] = $true
        $chapId = "chap-3"
        $chapTitle = "Chapter III • Emotional Granularity & Psychological Nuance (30:30 – 39:30)"
    }
    elseif (-not $chapEmitted[4] -and $mins -ge 39 -and ($mins -gt 39 -or [int]$timeParts[1] -ge 30)) {
        $chapEmitted[4] = $true
        $chapId = "chap-4"
        $chapTitle = "Chapter IV • Abstract Concepts, Cultural False Friends & Collective Animal Nouns (39:30 – 47:45)"
    }
    elseif (-not $chapEmitted[5] -and $mins -ge 47 -and ($mins -gt 47 -or [int]$timeParts[1] -ge 45)) {
        $chapEmitted[5] = $true
        $chapId = "chap-5"
        $chapTitle = "Chapter V • Cinema as a Sanctuary — Unplugging from the Digital Leash (47:45 – 58:20)"
    }
    elseif (-not $chapEmitted[6] -and $mins -ge 58 -and ($mins -gt 58 -or [int]$timeParts[1] -ge 20)) {
        $chapEmitted[6] = $true
        $chapId = "chap-6"
        $chapTitle = "Chapter VI • Modern Blockbusters, Suppressed Memory & 'The Zone of Interest' (58:20 – 01:07:02)"
    }
    
    # Process text with 3-Phase Token Replacement
    $tHtml = $rawText
    
    # Phase 1: Tokenize known ASR errors
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
    $tHtml = $tHtml.Replace("translating or getting stuck.", 'translating or getting stuck, so speaking English becomes ${v("second-nature", "second nature")}.')
    $tHtml = $tHtml.Replace("take pride in", "@@TOKEN_TAKE_PRIDE_IN@@")
    $tHtml = $tHtml.Replace("Take pride in", "@@TOKEN_TAKE_PRIDE_IN@@")
    $tHtml = $tHtml.Replace("a family of lions a pride", "@@TOKEN_PRIDE_OF_LIONS@@")
    
    # Phase 2: Wrap Vocabulary (case-insensitive)
    $tHtml = [regex]::Replace($tHtml, '\bcomparison is the thief of joy\b', '${v("comparison-is-the-thief-of-joy", "comparison is the thief of joy")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\benvy is the thief of joy\b', '${v("comparison-is-the-thief-of-joy", "envy is the thief of joy")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\benvious the thief of joy\b', '${v("comparison-is-the-thief-of-joy", "envious the thief of joy")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bturn the other cheek\b', '${v("turn-the-other-cheek", "turn the other cheek")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\ba gaggle of geese\b', '${v("gaggle-of-geese", "a gaggle of geese")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, "\bwhat's good for the goose is good for the gaggle\b", '${v("what-is-good-for-the-goose", "what''s good for the goose is good for the gaggle")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\binner monologue\b', '${v("inner-monologue", "inner monologue")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bspare time\b', '${v("downtime", "spare time")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bshowing off\b', '${v("showing-off", "showing off")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bstakes keep on rising\b', '${v("stakes", "stakes keep on rising")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bback catalog\b', '${v("back-catalog", "back catalog")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\ba bottleneck\b', 'a ${v("bottleneck", "bottleneck")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bthat bottleneck\b', 'that ${v("bottleneck", "bottleneck")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    # Standalone vocabulary words
    $tHtml = [regex]::Replace($tHtml, '\bcoherence\b', '${v("coherence", "coherence")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bannotating\b', '${v("annotate", "annotating")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bserendipity\b', '${v("serendipity", "serendipity")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bcompetency\b', '${v("competency", "competency")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bcontingency\b', '${v("contingency", "contingency")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bminced\b', '${v("minced", "minced")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bmangroves\b', '${v("mangrove", "mangroves")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bpastrami\b', '${v("pastrami", "pastrami")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bcider\b', '${v("cider", "cider")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\baffectionate\b', '${v("affectionate", "affectionate")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bapologetic\b', '${v("apologetic", "apologetic")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\benvious\b', '${v("envious", "envious")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\binnocence\b', '${v("innocence", "innocence")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bforgiveness\b', '${v("forgiveness", "forgiveness")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bstubborn\b', '${v("stubborn", "stubborn")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bpride\b', '${v("pride", "pride")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bconscience\b', '${v("conscience", "conscience")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bconscientious\b', '${v("conscientious", "conscientious")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bblockbusters\b', '${v("blockbuster", "blockbusters")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bfranchise\b', '${v("franchise", "franchise")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bhype\b', '${v("hype", "hype")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bsuppress\b', '${v("suppress", "suppress")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bsuppressed\b', '${v("suppress", "suppressed")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bGelato\b', '${v("gelato", "Gelato")}')
    $tHtml = [regex]::Replace($tHtml, '\bembarrassed\b', '${v("embarrassed", "embarrassed")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $tHtml = [regex]::Replace($tHtml, '\bamazed\b', '${v("amazed", "amazed")}', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    
    # Phase 3: Expand Tokens using single-quoted strings
    $tHtml = $tHtml.Replace('@@FIX_UNWIND@@', '${v("unwind", "and just unwind and relax")} ${fixBadge("and just unwind and relax", "and the Escoonnade relax")}')
    $tHtml = $tHtml.Replace('@@FIX_IELTS_COMPETENCY@@', 'IELTS grading, ${v("competency", "CEFR competency")} ${fixBadge("IELTS grading, CEFR competency", "iOS grading, compensancy, competency")}')
    $tHtml = $tHtml.Replace('@@FIX_BEEF_BALL@@', 'A rounded ball of beef ${fixBadge("A ball of beef that is rounded", "A tfle of beef that it''s rounded")}')
    $tHtml = $tHtml.Replace('@@FIX_SPHERICAL_1@@', 'It''s ${v("spherical", "spherical")} ${fixBadge("spherical", "feric")}')
    $tHtml = $tHtml.Replace('@@FIX_SPHERICAL_2@@', '${v("spherical", "Spherical")} beef ${fixBadge("Spherical beef", "Mospher beef")}')
    $tHtml = $tHtml.Replace('@@FIX_STRACCIATELLA@@', 'Stracciatella ${fixBadge("Stracciatella", "Estra chaa")}')
    $tHtml = $tHtml.Replace('@@FIX_GELATO@@', 'artisanal frozen ${v("gelato", "gelato")} ice cream ${fixBadge("artisanal frozen gelato", "Noelle of frozen a gelado ice cream")}')
    $tHtml = $tHtml.Replace('@@FIX_SEVILLE_1@@', 'Seville? ${fixBadge("Seville", "Sabile")} Okay...')
    $tHtml = $tHtml.Replace('@@FIX_LOUIE_MUM_1@@', 'my mum''s ${fixBadge("my mum''s", "my Loom''s")}')
    $tHtml = $tHtml.Replace('@@FIX_LOUIE_MUM_2@@', 'My mum''s calling me right now ${fixBadge("My mum''s calling me", "My Loom''s rigging me")}')
    $tHtml = $tHtml.Replace('@@FIX_SUSPICIOUS@@', 'looks ${v("fishy", "fishy")}, ${v("suspicious", "suspicious")} ${fixBadge("fishy, suspicious", "speechy, sus suspicious")}')
    $tHtml = $tHtml.Replace('@@FIX_INFATUATED@@', '${v("infatuated", "infatuated")} ${fixBadge("infatuated", "in actuated")}')
    $tHtml = $tHtml.Replace('@@FIX_FOMO@@', '${v("fomo", "FOMO")} (fear of missing out), ${v("envious", "envy")} ${fixBadge("FOMO, envy", "Formal fear of missing out, MB")}')
    $tHtml = $tHtml.Replace('@@FIX_MURDER_OF_CROWS@@', '${v("murder-of-crows", "A murder of crows")}, right? ${fixBadge("A murder of crows", "A marr froz")}')
    $tHtml = $tHtml.Replace('@@FIX_PADEL@@', '${v("padel", "padel")} ${fixBadge("padel", "paddle")}')
    $tHtml = $tHtml.Replace('@@FIX_CURR_MOVIE_SECTION@@', 'current movie selection ${fixBadge("current movie selection", "curry movie section")}')
    $tHtml = $tHtml.Replace('@@FIX_CHALAMET_1@@', 'Timothée Chalamet ${fixBadge("Timothée Chalamet", "Timothy Charlemagne")}')
    $tHtml = $tHtml.Replace('@@FIX_CHALAMET_2@@', 'Timothée Chalamet ${fixBadge("Timothée Chalamet", "Smothy Salome")}')
    $tHtml = $tHtml.Replace('@@FIX_THANOS@@', 'Had so much build-up to Thanos ${fixBadge("Thanos", "Vanos")}')
    $tHtml = $tHtml.Replace('@@FIX_DOCTOR_DOOM_1@@', 'Doctor Doom ${fixBadge("Doctor Doom", "Do a doctor Loom")}')
    $tHtml = $tHtml.Replace('@@FIX_DOCTOR_DOOM_2@@', 'Doctor Doom ${fixBadge("Doctor Doom", "Dr Loom")}')
    $tHtml = $tHtml.Replace('@@FIX_MERYL_STREEP@@', 'Meryl Streep ${fixBadge("Meryl Streep", "Male stream")}')
    $tHtml = $tHtml.Replace('@@FIX_ZONE_OF_INTEREST@@', '${v("cinematic-restraint", "The Zone of Interest")}, an A24 film ${fixBadge("The Zone of Interest, an A24 film", "so of interest. A for a twenty 4")}')
    $tHtml = $tHtml.Replace('@@FIX_BOTTLENECK_2@@', '${v("bottleneck", "bottleneck")} ${fixBadge("bottleneck", "Bo, all neg is")}')
    $tHtml = $tHtml.Replace('@@FIX_ARCH_REST@@', '${v("architectural-restoration", "architectural restoration")} ${fixBadge("architectural restoration", "architectural. Architectural, his restoration")}')
    $tHtml = $tHtml.Replace('@@FIX_REVITALIZE@@', 'to ${v("revitalize", "revitalize")} ${fixBadge("revitalize", "you vitalize")}')
    $tHtml = $tHtml.Replace('@@TOKEN_TAKE_PRIDE_IN@@', '${v("take-pride-in", "take pride in")}')
    $tHtml = $tHtml.Replace('@@TOKEN_PRIDE_OF_LIONS@@', 'a family of lions ${v("pride-of-lions", "a pride")}')
    $tHtml = $tHtml.Replace('@@FIX_UNPLUG@@', 'without watching it, ${v("unplug", "unplugging completely")}. So I think')
    $tHtml = $tHtml.Replace('@@FIX_IMMERSIVE@@', 'It''s everything. It''s the ${v("immersive", "immersive atmosphere")}, basically.')
    $tHtml = $tHtml.Replace('@@FIX_COMMUNAL@@', 'share a ${v("communal", "communal room")} with people ${fixBadge("communal room", "room with people like bed people")}')
    $tHtml = $tHtml.Replace('@@FIX_FORBEARANCE@@', 'turned the other cheek with ${v("forbearance", "forbearance")}, but I forgive ${fixBadge("turn the other cheek with forbearance", "turned the other cheek, but I forgive")}')

    
    
    # Escape backticks in text
    $safeHtml = $tHtml -replace '`', '\`'
    
    $cLine = "  { id: `"$tId`", speaker: `"$spk`", time: `"$time`""
    if ($chapId -ne "") {
        $cLine += ", chapterId: `"$chapId`", chapterTitle: `"$chapTitle`""
    }
    $cLine += ", html: ``$safeHtml`` },"
    $sb.AppendLine($cLine) | Out-Null
}

$sb.AppendLine("];`n") | Out-Null

$outDataPath = "D:\Documents\Tony b\lesson_data.js"
[System.IO.File]::WriteAllText($outDataPath, $sb.ToString(), [System.Text.UTF8Encoding]::new($false))
Write-Host "SUCCESS: Curated lesson data written to $outDataPath"
