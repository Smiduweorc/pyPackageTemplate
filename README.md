# mypackage

A typed Python library template, set up for testing, linting and CI.

> Publishing is handled manually (custom settings), so there's no publish
> workflow here, just a `release.sh` that bumps the version, regenerates the
> changelog, and tags.

## What's inside

- **Packaging**: [hatchling](https://hatch.pypa.io) build backend, a `src`-less
  package layout (`mypackage/`), a `py.typed` marker so downstreams get the
  types, and a thin `__init__.py` barrel that re-exports the public API.
- **Type checking**: [mypy](https://mypy-lang.org) in `strict` mode, configured
  in `pyproject.toml` to check the whole package.
- **Linting & formatting**: [ruff](https://docs.astral.sh/ruff) for both lint
  and format (tab indentation, 88-col, `E/F/I/UP/ANN/B/SIM` rule sets, with
  type-hint enforcement relaxed for tests).
- **Testing**: the standard library's [`unittest`](https://docs.python.org/3/library/unittest.html)
  runner. No extra framework, no compile step. Test modules live under `tests/`
  and are named after the area they cover.
- **Conventional Commits**: a commit-msg hook validates the
  [Conventional Commits](https://www.conventionalcommits.org) format with a
  regex (no Node toolchain), and [git-cliff](https://git-cliff.org) turns that
  history into a `CHANGELOG.md`.
- **Git hooks**: [lefthook](https://lefthook.dev) (installed as a dev
  dependency) runs ruff + mypy on staged files before commit and lints the
  commit message.
- **CI**: `.github/workflows/` runs lint + type-check on one job and the test
  suite across Linux/macOS/Windows on Python 3.12 & 3.13.
- **Editor config**: `.vscode/` recommends the Ruff + Python + mypy extensions
  and wires up format-on-save and import sorting via Ruff.
- **Dependabot**: daily pip + GitHub Actions update PRs.

## Getting started

1. Copy this directory, then rename the package to your project's name:
   - rename the `mypackage/` directory,
   - update `name`, `description`, `[project.urls]`, `[tool.hatch...packages]`,
     `[tool.mypy] files`, and `[tool.ruff.lint.isort] known-first-party` in
     `pyproject.toml`,
   - update the import in `tests/greet.py`.
2. Create a virtual environment and install the dev dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate        # Windows: .venv\Scripts\activate
   pip install -e ".[dev]"
   ```
3. `git init` (if needed) and install the git hooks: `lefthook install`.
4. Replace `mypackage/greet.py` with your implementation and update the
   re-exports in `mypackage/__init__.py`.
5. Add tests under `tests/` (any `*.py` module; see the layout note below).

## Commands

| Command | What it does |
| --- | --- |
| `python -m unittest discover -s tests -p "*.py"` | Run the test suite. |
| `python -m unittest tests.greet` | Run a single test module. |
| `mypy` | Type-check the package (strict). |
| `ruff check .` | Lint. |
| `ruff check . --fix` | Lint and auto-fix what it can. |
| `ruff format .` | Format with tabs. |
| `git-cliff -o CHANGELOG.md` | Regenerate the changelog from the commit history. |
| `./release.sh v[X.Y.Z]` | Bump version, regenerate changelog, commit, tag. |

> Test files are named after the area they cover (e.g. `greet.py`) rather than
> `test_*.py`, so discovery needs the explicit `-p "*.py"` pattern.

## Conventional commits & git hooks

Commits follow [Conventional Commits](https://www.conventionalcommits.org)
(`feat:`, `fix:`, `chore:`, etc.). After installing the dev dependencies, run
`lefthook install` once (inside a git repo) to wire up the hooks:

- **pre-commit**: runs `ruff check`, `ruff format --check` on staged Python
  files and `mypy` on the package.
- **commit-msg**: validates the message format with a regex (the rule lives in
  `lefthook.yml`; no Node/commitlint dependency).

Because the history is conventional, `git-cliff` can regenerate `CHANGELOG.md`
automatically.

## Project layout

```
.
├── mypackage/              # implementation
│   ├── __init__.py         # public barrel, re-export your API here
│   ├── greet.py            # example module (replace with your code)
│   └── py.typed            # ships type information to consumers
├── tests/                  # unittest modules, run via discovery
│   ├── __init__.py
│   └── greet.py
├── pyproject.toml          # packaging + mypy + ruff config
├── cliff.toml              # git-cliff changelog config
├── lefthook.yml            # git hooks (ruff + mypy + commit-msg check)
├── release.sh              # version bump + changelog + annotated tag
├── LICENSE
├── .vscode/                # recommended extensions + editor settings
└── .github/
    ├── ISSUE_TEMPLATE/     # bug report + feature request
    ├── workflows/          # lint.yml + test.yml
    └── dependabot.yml
```

## Releasing

`./release.sh v[X.Y.Z]` bumps the `version` in `pyproject.toml`, regenerates
`CHANGELOG.md`, commits the result as `chore(release): prepare for v[X.Y.Z]`,
and creates an annotated tag whose message is the changelog for the new
version. Then push with `git push && git push --tags`.

Publishing is intentionally left manual. Build with `python -m build` (or
`hatch build`) and upload with whatever registry/auth settings you use.

## License

ISC
