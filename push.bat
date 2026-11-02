@echo off
set "PATH=C:\Program Files\Git\cmd;C:\Users\Administrator\.gemini\antigravity\bin\git\cmd;%PATH%"
cd /d "D:\Documents\Tony b"
echo ========================================================
echo Pushing Tony B's English Sanctuary to GitHub Pages
echo ========================================================
echo.
git add -A
git commit -m "Add Lesson Notes (3 Nov 2026), interactive sanctuary, and practice test"
git push -u origin main
git push origin main:gh-pages
echo.
echo ========================================================
echo Done! Both main and gh-pages branches updated on GitHub.
echo ========================================================
