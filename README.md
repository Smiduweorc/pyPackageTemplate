# mypackage

A template for a typed Python library: hatchling, mypy in strict mode, ruff
for lint and format, stdlib `unittest`, git-cliff and lefthook. Python 3.12 or
later; CI tests 3.12 and 3.13 on Linux, macOS and Windows.

## Starting from it

1. Copy the directory and rename the package: the `mypackage/` directory,
   then `name`, `description`, `[project.urls]`, `packages` under
   `[tool.hatch.build.targets.wheel]`, `[tool.mypy] files` and
   `[tool.ruff.lint.isort] known-first-party` in `pyproject.toml`, and the
   import in `tests/greet.py`.
2. Make a virtual environment and install the dev dependencies:
   ```bash
   python -m venv .venv
   source .venv/bin/activate        # Windows: .venv\Scripts\activate
   pip install -e ".[dev]"
   ```
3. `git init`, then `lefthook install`.
4. Replace `mypackage/greet.py` and its re-export in `mypackage/__init__.py`.

There is no publish workflow. Build with `python -m build` or `hatch build`
(neither is in the dev dependencies) and upload with your own registry
settings.

Commits follow Conventional Commits and `./release.sh v1.2.0` cuts a release;
[black-garden-ants](https://github.com/Smiduweorc/black-garden-ants) explains
both. Here the commit-msg hook is a regex in `lefthook.yml`, and this
`release.sh` is an older one that takes only an explicit version.

## Known quirks

- Test modules are named after the area they cover (`greet.py`), not
  `test_*.py`, so discovery needs the pattern:
  `python -m unittest discover -s tests -p "*.py"`.

## License

ISC
