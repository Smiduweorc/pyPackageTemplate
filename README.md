# mypackage

A typed Python library template: hatchling packaging, mypy in strict mode, ruff
for lint and format, stdlib `unittest`, conventional commits with git-cliff
changelogs, lefthook git hooks, and GitHub Actions for lint and tests.

Publishing is left manual (custom registry settings), so there's no publish
workflow here, only a `release.sh` that bumps the version, regenerates the
changelog, and tags.

## Getting started

1. Copy this directory, then rename the package:
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
3. `git init` (if needed), then `lefthook install` to enable the hooks.
4. Replace `mypackage/greet.py` with your code and update the re-exports in
   `mypackage/__init__.py`.

## Commands

| Command | What it does |
| --- | --- |
| `python -m unittest discover -s tests -p "*.py"` | Run the test suite. |
| `python -m unittest tests.greet` | Run a single test module. |
| `mypy` | Type-check the package (strict). |
| `ruff check .` | Lint. |
| `ruff format .` | Format with tabs. |
| `git-cliff -o CHANGELOG.md` | Regenerate the changelog. |
| `./release.sh v[X.Y.Z]` | Bump version, regenerate changelog, commit, tag. |

Test modules are named after the area they cover (e.g. `greet.py`) rather than
`test_*.py`, so discovery needs the explicit `-p "*.py"` pattern.

## Commits

Commits follow [Conventional Commits](https://www.conventionalcommits.org)
(`feat:`, `fix:`, `chore:`, ...). The commit-msg hook checks the format with a
regex, so there's no Node toolchain involved. Pre-commit runs `ruff check`,
`ruff format --check` on staged Python files and `mypy` on the package.

## Releasing

`./release.sh v[X.Y.Z]` bumps the `version` in `pyproject.toml`, regenerates
`CHANGELOG.md`, commits as `chore(release): prepare for v[X.Y.Z]`, and creates
an annotated tag whose message is the changelog for the new version. Then run
`git push && git push --tags`.

Build with `python -m build` (or `hatch build`) and upload with whatever
registry settings you use.

## License

ISC
