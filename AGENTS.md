# AGNotes — project instructions for OpenCode

Repo: https://github.com/ddbzdnql/lean_ag_notes
GitHub Pages: https://ddbzdnql.github.io/lean_ag_notes/

## Build commands

```bash
lake build                  # Build Lean project
```

```bash
cd blueprint/src && latexmk # Build PDF (uses xelatex via latexmkrc)
```

```bash
leanblueprint web           # Build web version of the blueprint
leanblueprint checkdecls    # Verify all \lean{} names exist in Lean project
leanblueprint all           # Run pdf + web + checkdecls
```

## Lean project

- Lean version: `leanprover/lean4:v4.29.1` (pinned in `lean-toolchain`)
- Dependencies: `mathlib` `v4.29.1`, `checkdecls`, `doc-gen4`
- Source files live under `AGNotes/`, all under `namespace CategoryPrimer`
- Root import file: `AGNotes.lean`

## Blueprint (LaTeX + leanblueprint/plasTeX)

- Shared content: `blueprint/src/content.tex` → inputs chapter files from `blueprint/src/chapters/`
- PDF root: `blueprint/src/print.tex` (xelatex)
- Web root: `blueprint/src/web.tex` (plasTeX)
- Shared macros: `blueprint/src/macros/common.tex`
- PDF-only dummy macros: `blueprint/src/macros/print.tex`

## Critical `\lean{}` rules

**`\lean{}` associates ONE Lean declaration with the enclosing theorem environment.**  
Getting this wrong silently breaks the web blueprint—the dependency graph and Lean status icons will be wrong.

- **One `\lean{}` per environment.** If you put two `\lean{}` calls in the same proposition, only the last one survives in plasTeX's DOM. Split multi-claim propositions into separate environments instead.
- **`\lean{}` inside `enumerate` items is silently ignored.** It must be a direct child of the theorem environment.
- When adding a new `\lean{}`, also add the Lean declaration name to `blueprint/lean_decls`.

## Proof-writing rules

- **Do NOT fill in proofs the user hasn't written.** When editing `.tex` or `.lean` files, only modify what the user explicitly asks for. Leave `proof` environments empty or with the user's existing placeholder text—do not write the proof body.

## CI

- `blueprint.yml` triggers on push to `main`: builds Lean → generates blueprint + doc-gen4 API docs → deploys to GitHub Pages.
- Deployed docs let you click Lean declarations in the web blueprint to jump to doc-gen4 source documentation.

## URL configuration

- `blueprint/src/web.tex`: `\home{...}`, `\github{...}`, `\dochome{...}` — controls blueprint navigation and Lean decl link targets
- `home_page/_config.yml`: `url`, `repository`, `github_username` — Jekyll homepage config
- If repo URL changes, update all three: `web.tex`, `_config.yml`, and this file's header
