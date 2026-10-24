@echo off
set "PATH=C:\Program Files\Git\cmd;C:\Users\Administrator\.gemini\antigravity\bin\git\cmd;%PATH%"
cd /d "D:\Documents\Haytham"
echo ========================================================
echo Pushing Haytham's English Sanctuary to GitHub Pages
echo ========================================================
echo.
git add -A
git commit -m "Add Lesson Notes (24 Oct 2026), interactive sanctuary, and text rendering safeguards"
git push origin main
git push origin main:gh-pages
echo.
echo ========================================================
echo Done! Both main and gh-pages branches updated on GitHub.
echo ========================================================
pause
