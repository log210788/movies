# verify_portal.ps1
# Automated Verification Script for Tony B's English Sanctuary Portal
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$filePath = "D:\Documents\Tony b\index.html"
if (-not (Test-Path $filePath)) {
    throw "Target file $filePath does not exist!"
}

$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

Write-Host "================================================="
Write-Host "AUTOMATED VERIFICATION AUDIT: Tony B Sanctuary"
Write-Host "================================================="

$totalFailures = 0

# 1. Testing for Mojibake
Write-Host "`n--- 1. Testing for Mojibake ---"
if ($content.Contains([char]0x00E2) -or $content.Contains("ðŸ") -or $content.Contains("Ã¤") -or $content.Contains("Ã¼") -or $content.Contains("Ã¶") -or $content.Contains("Ã©") -or $content.Contains("Ã¡")) {
    Write-Host "FAIL: Potential mojibake characters detected!" -ForegroundColor Red
    $totalFailures++
} else {
    Write-Host "PASSED: Zero mojibake characters detected." -ForegroundColor Green
}

# 2. Checking Spanish Linguistic Terms Integrity
Write-Host "`n--- 2. Checking Spanish Text Integrity ---"
$spanishTerms = @("cuello de botella", "serendipia", "manada de leones", "bandada de cuervos", "contención cinematográfica", "el pádel", "desconexión de la tecnología", "la comparación es el ladrón de la alegría", "poner la otra mejilla", "el monólogo interior")
$allSpanishFound = $true
foreach ($t in $spanishTerms) {
    if (-not $content.Contains($t)) {
        Write-Host "WARNING: Spanish term '$t' not found!" -ForegroundColor Yellow
        $allSpanishFound = $false
        $totalFailures++
    }
}
if ($allSpanishFound) {
    Write-Host "PASSED: All Spanish linguistic terms present and uncorrupted." -ForegroundColor Green
}

# 3. Testing getElementById String Quoting (Rule 1)
Write-Host "`n--- 3. Testing getElementById String Quoting ---"
$lines = $content -split "`n"
$lineNum = 0
$errors = 0
foreach ($line in $lines) {
    $lineNum++
    if ($line -match "getElementById\(\s*[a-zA-Z0-9_]+-|\+\s*-[a-zA-Z0-9_]+") {
        Write-Host "Line $lineNum has unquoted concatenation in getElementById: $line" -ForegroundColor Red
        $errors++
    }
}
if ($errors -eq 0) {
    Write-Host "PASSED: All getElementById concatenations are safely and explicitly quoted." -ForegroundColor Green
} else {
    Write-Host "FAIL: Found $errors unquoted getElementById concatenations!" -ForegroundColor Red
    $totalFailures++
}

# 4. Checking Closing Tags
Write-Host "`n--- 4. Checking Closing Tags ---"
if ($content.Contains("</html>") -and $content.Contains("</body>") -and $content.Contains("</script>")) {
    Write-Host "PASSED: Closing tags (</html>, </body>, </script>) are intact." -ForegroundColor Green
} else {
    Write-Host "FAIL: Missing closing tags!" -ForegroundColor Red
    $totalFailures++
}

# 5. Checking Data Blocks
Write-Host "`n--- 5. Checking Core Data Blocks ---"
$blocks = @("VOCAB_DB", "ASR_FIXES", "NATURAL_STRENGTHS", "PHRASING_POLISHES", "EDITORIAL_TOPICS", "FLASHCARDS", "IDIOM_CHALLENGES", "QUIZ_QUESTIONS", "REFLECTION_PROMPTS", "TRANSCRIPT_TURNS")
$allBlocksFound = $true
foreach ($b in $blocks) {
    if (-not $content.Contains("const $b =")) {
        Write-Host "FAIL: Missing data block $b" -ForegroundColor Red
        $allBlocksFound = $false
        $totalFailures++
    }
}
if ($allBlocksFound) {
    Write-Host "PASSED: All 10 core data blocks are present." -ForegroundColor Green
}

# 6. Checking Vocabulary Key Match
Write-Host "`n--- 6. Checking Vocabulary Key Match ---"
$vocabKeys = [regex]::Matches($content, '^\s*"([^"]+)":\s*\{', [System.Text.RegularExpressions.RegexOptions]::Multiline) | ForEach-Object { $_.Groups[1].Value }
$usedKeys = [regex]::Matches($content, '\$\{v\("([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique

$missing = @()
foreach ($k in $usedKeys) {
    if (-not ($vocabKeys -contains $k)) {
        $missing += $k
    }
}
if ($missing.Count -eq 0) {
    Write-Host "PASSED: 100% of referenced vocabulary keys ($($usedKeys.Count)) exist in VOCAB_DB ($($vocabKeys.Count) total)!" -ForegroundColor Green
} else {
    Write-Host "FAIL: Missing keys in VOCAB_DB: $($missing -join ', ')" -ForegroundColor Red
    $totalFailures++
}

# 7. Rigorous Test / Quiz Integrity Verification
Write-Host "`n--- 7. Rigorous Test & Quiz Integrity Audit ---"
$quizMatch = [regex]::Match($content, 'const QUIZ_QUESTIONS = (\[[\s\S]*?\n\];)')
if (-not $quizMatch.Success) {
    Write-Host "FAIL: Cannot locate QUIZ_QUESTIONS array!" -ForegroundColor Red
    $totalFailures++
} else {
    $qCount = [regex]::Matches($quizMatch.Value, 'question:').Count
    $cIdxMatches = [regex]::Matches($quizMatch.Value, 'correctIndex:\s*(\d+)')
    Write-Host "Verified Quiz Questions Count: $qCount"
    if ($qCount -ge 6) {
        Write-Host "PASSED: Quiz contains $qCount questions (minimum 6 required)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Quiz only has $qCount questions!" -ForegroundColor Red
        $totalFailures++
    }

    # Verify each question has valid correctIndex
    $validIndices = $true
    foreach ($m in $cIdxMatches) {
        $val = [int]$m.Groups[1].Value
        if ($val -lt 0 -or $val -gt 3) {
            Write-Host "FAIL: Invalid correctIndex: $val" -ForegroundColor Red
            $validIndices = $false
            $totalFailures++
        }
    }
    if ($validIndices) {
        Write-Host "PASSED: All $($cIdxMatches.Count) correctIndex values are valid (0-3 range)." -ForegroundColor Green
    }
}

# Check Idiom Gym Challenges
$idiomMatch = [regex]::Match($content, 'const IDIOM_CHALLENGES = (\[[\s\S]*?\n\];)')
if ($idiomMatch.Success) {
    $iCount = [regex]::Matches($idiomMatch.Value, 'title:').Count
    Write-Host "Verified Idiom Challenges Count: $iCount"
    if ($iCount -ge 5) {
        Write-Host "PASSED: Idiom Gym contains $iCount challenges (minimum 5 required)." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Idiom Gym only has $iCount challenges!" -ForegroundColor Red
        $totalFailures++
    }
} else {
    Write-Host "FAIL: Cannot locate IDIOM_CHALLENGES array!" -ForegroundColor Red
    $totalFailures++
}

# Check Flashcards Deck
$fcMatch = [regex]::Match($content, 'const FLASHCARDS = (\[[\s\S]*?\n\];)')
if ($fcMatch.Success) {
    $fcCount = [regex]::Matches($fcMatch.Value, 'vocabKey:').Count
    Write-Host "Verified Flashcard Deck Count: $fcCount"
    if ($fcCount -ge 10) {
        Write-Host "PASSED: Flashcard deck contains $fcCount cards." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Flashcard deck only has $fcCount cards!" -ForegroundColor Red
        $totalFailures++
    }
} else {
    Write-Host "FAIL: Cannot locate FLASHCARDS array!" -ForegroundColor Red
    $totalFailures++
}

# Check DOM test elements
$domElements = @("quiz-container", "quiz-score-badge", "idiom-gym-container", "fc-counter", "fc-front-title", "fc-back-details", "reflections-container")
$allDomFound = $true
foreach ($el in $domElements) {
    if (-not $content.Contains("id=`"$el`"")) {
        Write-Host "FAIL: Missing DOM container element id='$el'!" -ForegroundColor Red
        $allDomFound = $false
        $totalFailures++
    }
}
if ($allDomFound) {
    Write-Host "PASSED: All interactive test DOM containers are present in HTML." -ForegroundColor Green
}

Write-Host "`n================================================="
if ($totalFailures -eq 0) {
    Write-Host "AUDIT RESULT: 100% PASSED! All systems, tests, and vocab verified cleanly." -ForegroundColor Green
} else {
    Write-Host "AUDIT RESULT: FAILED with $totalFailures error(s)!" -ForegroundColor Red
    exit 1
}
Write-Host "================================================="
