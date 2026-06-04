---
description: Update CV content in both LaTeX and HTML, using the project content map
---

# Update CV

Apply the user's change request to **both** output formats. Never update only one side unless the user explicitly asks for LaTeX-only or HTML-only.

## User request

The text after `/update-cv` is the change request. Parse it for: what to add/edit/remove, which section, which role or bullet, dates, metrics, tone (shorter/longer), and whether order matters.

If anything is ambiguous (which role, which bullet, wording preference), ask one short clarifying question before editing.

## Golden rules

1. **Dual sync** — Every content change must land in **LaTeX and HTML** (see map below).
2. **Same facts** — Names, dates, titles, metrics, and bullet meaning must match across formats (wording may differ slightly for length/ATS).
3. **Do not edit PDFs** — PDFs are build artefacts (`cv-html.pdf`, `cv-tex.pdf`). Regenerate with `make html` and/or `make tex` after edits.
4. **Do not change layout/CSS** unless the user asks for visual or structural changes.
5. **Minimal scope** — Only touch files and sections required by the request.

## Content map (where to edit)

| Content | LaTeX | HTML (`cv.html`) |
|--------|-------|------------------|
| Name, job title, phone, email, location, homepage, LinkedIn, GitHub | `cv.tex` — `\name`, `\title`, `\address`, `\phone`, `\email`, `\homepage`, `\social` | `<header>` — `.name`, `.subtitle`; `<section class="contact">` |
| Highlights (5 bullets with bold labels) | `sections/summary.tex` — `\section{Highlights}` | `<!-- Highlights -->` — `ul.highlights` |
| Work experience (all roles) | `sections/experience.tex` — `\cventry{dates}{title}{company}{location}{}{...}` | `<!-- Work Experience -->` — each `div.row.entry` with `<!-- Company -->` comment |
| Skills | `sections/skills.tex` — `\cvitem{category}{...}` | **Not in HTML today** — add a matching section if user enables skills in both |
| Education (degree, GPA, thesis) | `sections/education.tex` — first `\cventry` | `<!-- Education -->` — `div.row.entry` |
| Honors & awards | `sections/education.tex` — `\section{Honours \& Awards}` | `<!-- Honors and Awards -->` |
| Projects (Pytopia, ApplyLink) | `sections/projects.tex` (include via `\input` in `cv.tex` if section should appear) | **Not in HTML today** — add if user wants projects in both |
| Languages | `sections/languages.tex` (include via `\input` in `cv.tex` if needed) | **Not in HTML today** — add if needed |
| Global LaTeX style / section order | `cv.tex` — preamble, `\input{sections/...}` order | N/A (HTML section order in `<main>`) |
| HTML-only styling | N/A | `<style>` block in `<head>` — only when asked |

### LaTeX `\cventry` shape

```latex
\cventry{dates}{job title}{company}{location}{}{%
  Optional intro paragraph.
  \begin{itemize}
    \item Bullet one.
  \end{itemize}}
```

### HTML experience entry shape

```html
<!-- CompanyName -->
<div class="row entry">
  <div class="meta"><div class="org">Company</div><div>Dates</div></div>
  <div>
    <p class="role">Job Title</p>
    <p>Optional intro.</p>
    <p class="lead">Subheading</p>   <!-- optional -->
    <ul><li>...</li></ul>
  </div>
</div>
```

### Section title placement (HTML — match existing layout)

| Section | Title class | Column |
|---------|-------------|--------|
| Highlights | `sec-title` | Left |
| Work Experience | `sec-title-main` | Right (empty left cell in title row) |
| Education | `sec-title-main` | Right |
| Honors and Awards | `sec-title` | Left |

LaTeX section names: Highlights, Experience, Skills, Education, Honours & Awards (British spelling in `.tex`).

### Current roles (quick index)

**LaTeX order** (`sections/experience.tex`): Vendoroo → Dippy.ai → Antler → Pytopia → Affinity.co → AltaML

**HTML order** (`cv.html`): Vendoroo → Pytopia → Dippy.ai → Antler → Affinity.co → AltaML

When the user changes **order**, update both files to the same order unless they specify format-specific ordering.

**HTML-only detail:** Vendoroo uses extra `p.lead` blocks ("What I Do:", "Technical Leadership:") and longer copy than LaTeX. **LaTeX** uses shorter bullets. On edits, keep HTML and LaTeX consistent in *facts*; you may keep HTML slightly more verbose if already that way, or align length if the user asks.

**Known metric mismatch to preserve unless user fixes:** Highlights "Business Results" — HTML says **38%**, LaTeX says **40%** (Dippy). Sync to one number when touching that bullet.

## Workflow

### 1. Plan

State briefly (in your reply):

- Which sections/files you will change
- Whether `cv.tex` needs a new `\input` (e.g. enabling `projects` or `languages`)

### 2. Edit LaTeX

- Section content → `sections/*.tex`
- Header / includes → `cv.tex`
- Use `20{,}000` for thousands in LaTeX; `\textbf{}` for bold labels; `40\,\%` for percentages

### 3. Edit HTML

- Mirror the same content in the matching `cv.html` region
- Escape `&` as `&amp;` in HTML
- Highlights: `<span class="k">Label:</span>` before text
- Contact links: `mailto:`, `https://github.com/...`, `https://linkedin.com/in/...`

### 4. Build (optional but recommended)

```bash
make html    # → cv-html.pdf
make tex     # → cv-tex.pdf
```

Run the target(s) for formats you changed. If Chrome or LaTeX is missing, say so and list what the user should run.

### 5. Summarize

Reply with:

- Bullet list of what changed (both formats)
- Files touched
- Build commands run (or skipped)
- Any follow-ups (e.g. "Skills still only in LaTeX — add HTML section?")

## Common operations

| Request type | LaTeX | HTML |
|--------------|-------|------|
| New job | Add `\cventry` in `experience.tex` | Add `div.row.entry` under Work Experience |
| Edit bullet | Find `\item` in that `\cventry` | Find `<li>` in that entry |
| New highlight | Add `\item` in `summary.tex` | Add `<li>` in `ul.highlights` |
| Change phone/email | `cv.tex` macros | `.contact` items |
| New skill line | `skills.tex` | Add Skills section block if syncing |
| Remove role | Delete `\cventry` block | Delete entire `div.row.entry` |
| Reorder jobs | Reorder `\cventry` blocks | Reorder `div.row.entry` blocks |

## Do not

- Commit or push unless the user asks
- Edit `old.pdf`, `canva.pdf`, or generated `*.pdf` by hand
- Split content across formats differently without telling the user
