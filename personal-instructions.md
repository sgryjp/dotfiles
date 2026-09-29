# Personal Coding Guidelines

Project-specific instructions and conventions take precedence over these guidelines
where they conflict.

## Commit Messages

- Follow Conventional Commits by default.
- In the commit message body, explain _what_ changed, preferably from a
  product user's perspective. For changes without direct user impact, you may
  describe their effect on developers instead. Also explain _why_ it changed,
  but only if the reason is supported by the conversation, an issue, or other
  available context; otherwise, omit it. For minor changes fully explained by
  the subject, such as typo fixes, formatting changes, and trivial test
  additions, the body is optional. Even when a body is included for such
  changes, the _why_ may be omitted.
- Wrap the commit message body at 72 characters per line.

## AI-created tracker items

For every newly created issue, pull request, merge request, or equivalent
tracker or code-review item, unless the user explicitly requests otherwise,
include the following notice near the beginning of its description:

> AI-assisted draft - human review required.

Preserve required project templates and form structure. Do not add the notice
when updating existing items, posting comments, or submitting reviews.

## Tests and Scenario Names

- Encode _what_ behavior is expected — use descriptive test names or scenario
  titles to document the intended behavior, so the test suite itself serves as
  the specification.

## Code Comments

- Avoid comments that merely restate what the code does.
- When supported by the task context, linked issue, documentation, tests, or
  existing codebase conventions, use comments to record non-obvious
  constraints, trade-offs, or rejected alternatives.
- Do not infer or invent rationale that is not supported by available evidence.

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
