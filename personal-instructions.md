# Personal Coding Guidelines

## Commit Messages

- Project-specific commit-message conventions take precedence over these
  guidelines.
- Subject: `scope: description` (scope = directory/module/service unit; do not
  use class names). Name the changed object. For a shared/cross-cutting module
  (high fan-in), name affected feature(s) in the first body line. Infer high
  fan-in from project-provided structural information when available (e.g.
  sources in a `Utilities` module). Target 50 characters; treat it as a soft
  limit, not a cap to truncate or overcompress for.
- Body: include the _why_ — the rationale for the change — only when derivable
  from session context, an issue, or recent conversation; otherwise omit it.
  Typo fixes, formatting, and trivial test additions may omit the _why_. If a
  high-fan-in or externally observable change has no derivable _why_, ask the
  user once before committing. Wrap at 72 characters per line.
- When a change spans multiple scopes: split into separate commits by default.
  If splitting is impractical, use `scopeA, scopeB: description` for changes
  bridging two closely-related scopes (e.g. moving code between modules; order
  reflects direction), or `treewide: description` for mechanical changes
  applied uniformly across the tree (the _why_ may be omitted). Otherwise,
  use the scope central to the change.

## AI-created tracker items

For every issue, pull request, merge request, or equivalent tracker or
code-review item you create, unless the user explicitly requests otherwise,
begin its description with:

> AI-assisted draft - human review required.

Retain this notice unless the user explicitly instructs you to remove it.

If project-specific instructions define a policy for AI-created tracker or
code-review items, follow that policy in preference to this global default.

## Tests and Scenario Names

- Encode _what_ behavior is expected — use descriptive test names or scenario
  titles to document the intended behavior, so the test suite itself serves as
  the specification.

## Code Comments

- Focus on _why not_ — why the obvious alternatives weren't chosen, if such
  alternatives exist. Don't just describe what the code does.

## Web Search and Scrape

<!-- https://chain.sh/ketch/guide/agent-integration -->

Use `ketch` CLI for web search and page fetching.

- Search: `ketch search "query"` — returns titles, URLs, and snippets
- Search + full content: `ketch search "query" --scrape` — fetches and extracts each result
- Federated search: `ketch search "query" --multi` — queries every usable backend and rank-fuses the results (`--random` picks one at random with fallback instead)
- Scrape: `ketch scrape <url>` — fetches a URL and returns clean markdown
- Batch scrape: `ketch scrape <url1> <url2> ...` — concurrent fetch
- Extract: `curl -L <url> | ketch extract` — pipe already-fetched HTML to clean markdown (no fetch)
- Code search: `ketch code "query" --lang go` — real OSS code snippets
- Library docs: `ketch docs "query" --library /org/repo` — library documentation
- Crawl: `ketch crawl <url> --sitemap --background` — crawl a site, poll with `ketch crawl status`
- JS-rendered pages are handled automatically — if a page returns a loading shell, ketch re-fetches it with a headless browser.
- All commands support `--json` for structured output.
- Discovery: `ketch config` — returns effective config plus available search, code, and docs backends as JSON.
- The operator has already configured the backends and browser. Do not override unless you have a specific reason.
