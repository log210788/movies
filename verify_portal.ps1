# verify_portal.ps1
# Automated Verification Script for Tony B's English Sanctuary Portal (Canonical Template)
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
$spanishTerms = @("cuello de botella", "serendipia", "manada de leones", "bandada de cuervos", "contención cinematográfica", "el pádel", "la comparación es el ladrón de la alegría", "poner la otra mejilla", "el monólogo interno")
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
Write-Host "`n--- 5. Checking Core Data Blocks (Canonical Template) ---"
$blocks = @("LESSON_CONFIG", "VOCAB_DB", "TRANSCRIPT_TURNS", "STUDENT_STRENGTHS", "GENTLE_POLISHES", "ASR_FIXES", "CULTURAL_PLACES", "FLASHCARD_KEYS", "QUIZ_QUESTIONS")
$allBlocksFound = $true
foreach ($b in $blocks) {
    if (-not $content.Contains("const $b =")) {
        Write-Host "FAIL: Missing data block $b" -ForegroundColor Red
        $allBlocksFound = $false
        $totalFailures++
    }
}
if ($allBlocksFound) {
    Write-Host "PASSED: All 9 core data blocks are present." -ForegroundColor Green
}

# 6. Checking Vocabulary Key Match
Write-Host "`n--- 6. Checking Vocabulary Key Match ---"
$vocabKeys = [regex]::Matches($content, '^\s*"([^"]+)":\s*\{', [System.Text.RegularExpressions.RegexOptions]::Multiline) | ForEach-Object { $_.Groups[1].Value }
$usedKeys = [regex]::Matches($content, 'data-vkey="([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Where-Object { $_ -ne '${key}' } | Select-Object -Unique

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

# 7. Checking Quiz (The Test) Integrity
Write-Host "`n--- 7. Checking Quiz (Test) Generation Integrity ---"
if ($content -match 'const QUIZ_QUESTIONS = \[\s*([\s\S]*?)\s*\];') {
    $quizRaw = $matches[1]
    $qMatches = [regex]::Matches($quizRaw, '\{\s*q:\s*"([^"]+)"[\s\S]*?options:\s*\[([\s\S]*?)\][\s\S]*?correct:\s*(\d+)[\s\S]*?explain:\s*"([^"]+)"\s*\}')
    if ($qMatches.Count -ge 6) {
        Write-Host "PASSED: Found $($qMatches.Count) fully formed quiz questions." -ForegroundColor Green
        for ($qi = 0; $qi -lt $qMatches.Count; $qi++) {
            $qm = $qMatches[$qi]
            $qPrompt = $qm.Groups[1].Value
            $optsRaw = $qm.Groups[2].Value
            $correctIdx = [int]$qm.Groups[3].Value
            $explain = $qm.Groups[4].Value
            
            $optCount = ([regex]::Matches($optsRaw, '"[^"]+"')).Count
            if ($optCount -ne 4) {
                Write-Host "FAIL Question $($qi+1): expected 4 options, found $optCount" -ForegroundColor Red
                $totalFailures++
            }
            if ($correctIdx -lt 0 -or $correctIdx -ge $optCount) {
                Write-Host "FAIL Question $($qi+1): correct index $correctIdx out of range [0..$($optCount-1)]" -ForegroundColor Red
                $totalFailures++
            }
        }
    } else {
        Write-Host "FAIL: Found only $($qMatches.Count) quiz questions (expected >= 6)!" -ForegroundColor Red
        $totalFailures++
    }
} else {
    Write-Host "FAIL: Could not locate QUIZ_QUESTIONS block!" -ForegroundColor Red
    $totalFailures++
}

# 8. Flashcard Keys Validation
Write-Host "`n--- 8. Checking Flashcard Keys Integrity ---"
if ($content -match 'const FLASHCARD_KEYS = \[\s*([\s\S]*?)\s*\];') {
    $fcRaw = $matches[1]
    $fcKeys = [regex]::Matches($fcRaw, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
    $fcMissing = @()
    foreach ($k in $fcKeys) {
        if (-not ($vocabKeys -contains $k)) { $fcMissing += $k }
    }
    if ($fcMissing.Count -eq 0 -and $fcKeys.Count -ge 12) {
        Write-Host "PASSED: All $($fcKeys.Count) flashcard keys exist in VOCAB_DB." -ForegroundColor Green
    } else {
        Write-Host "FAIL: Invalid flashcard keys: $($fcMissing -join ', ')" -ForegroundColor Red
        $totalFailures++
    }
}

# 9. Headless Edge DOM Render Audit
Write-Host "`n--- 9. Headless Edge Full DOM Render Audit ---"
$edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
if (Test-Path $edge) {
    $domOut = "D:\Documents\Tony b\verify_dom.txt"
    $url = "file:///D:/Documents/Tony%20b/index.html"
    $proc = Start-Process -FilePath $edge -ArgumentList @("--headless", "--dump-dom", $url) -RedirectStandardOutput $domOut -NoNewWindow -PassThru -Wait
    if ($proc.ExitCode -eq 0 -and (Test-Path $domOut)) {
        $dom = [System.IO.File]::ReadAllText($domOut, [System.Text.Encoding]::UTF8)
        Remove-Item $domOut -Force -ErrorAction SilentlyContinue
        
        $turnsRendered = ([regex]::Matches($dom, '<article id="turn-\d+"')).Count
        $quizBtns = ([regex]::Matches($dom, 'id="qbtn-\d+-\d+"')).Count
        $brandInitial = [regex]::Match($dom, 'id="brand-initial"[^>]*>([^<]+)<').Groups[1].Value
        
        if ($turnsRendered -eq 369) {
            Write-Host "PASSED: All 369 transcript turns rendered into DOM." -ForegroundColor Green
        } else {
            Write-Host "FAIL: Rendered turns count: $turnsRendered (expected 369)" -ForegroundColor Red
            $totalFailures++
        }
        
        if ($quizBtns -eq 24) {
            Write-Host "PASSED: All 24 quiz option buttons rendered into DOM." -ForegroundColor Green
        } else {
            Write-Host "FAIL: Rendered quiz buttons: $quizBtns (expected 24)" -ForegroundColor Red
            $totalFailures++
        }
        
        if ($brandInitial.Trim() -eq "T") {
            Write-Host "PASSED: Student initial rendered as 'T' for Tony." -ForegroundColor Green
        } else {
            Write-Host "FAIL: Brand initial was '$brandInitial' (expected 'T')" -ForegroundColor Red
            $totalFailures++
        }
    }
}

Write-Host "`n================================================="
if ($totalFailures -eq 0) {
    Write-Host "FINAL AUDIT RESULT: 100% PASSED (0 ERRORS)" -ForegroundColor Green
} else {
    Write-Host "FINAL AUDIT RESULT: FAILED ($totalFailures ERRORS)" -ForegroundColor Red
}
Write-Host "================================================="
exit $totalFailures
