<p align="center">
  <img src="assets/banner.svg" alt="GEO-SEO Boost — Claude Code Skill" width="900"/>
</p>

<p align="center">
  <strong>GEO-first, SEO-supported, GSC-powered.</strong><br/>
  Unified skill for Claude Code — AI search optimization + real Google Search Console data.
</p>

<p align="center">
  AI search is eating traditional search. This tool optimizes for where traffic is going, not where it was.<br/>
  <strong>The difference:</strong> real GSC data integrated into every audit.
</p>

---

## What's Different From the Original?

This is a **boosted fork** of [geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) with major additions:

| Feature | Original | **geo-seo-boost** |
|---------|----------|--------------------|
| GEO Analysis | Yes | Yes |
| Google Search Console data | No | **Yes — full GSC integration** |
| Keyword gap analysis | No | **Yes — GSC queries vs page content** |
| Indexation inspection | No | **Yes — batch URL inspection** |
| Sitemap audit | No | **Yes — coverage analysis** |
| Period comparison | No | **Yes — 28d vs previous 28d** |
| Cross-analysis GEO+GSC | No | **Yes — citability x keyword gaps** |
| `/geo gsc` command | No | **Yes — standalone GSC report** |
| French output by default | No | **Yes** |
| Unified single `/geo` command | Partial | **Yes — 13 sub-commands** |

---

## Why GEO Matters (2026)

| Metric | Value |
|--------|-------|
| GEO services market | $850M+ (projected $7.3B by 2031) |
| AI-referred traffic growth | +527% year-over-year |
| AI traffic converts vs organic | 4.4x higher |
| Gartner: search traffic drop by 2028 | -50% |
| Brand mentions vs backlinks for AI | 3x stronger correlation |
| Google AI Overviews | 1.5B users/month |
| ChatGPT weekly active users | 900M+ |

---

## Prerequisites

- **Claude Code** CLI installed
- **Python 3.8+**
- **Git**
- **MCP GSC Server** configured in Claude Code (for `/geo gsc` and `/geo audit` GSC integration)

### Setting Up GSC MCP Server

To use the Google Search Console features, you need the GSC MCP server configured. Without it, GEO-only commands (`/geo citability`, `/geo crawlers`, etc.) still work perfectly. Only `/geo gsc` and the GSC integration in `/geo audit` require it.

---

## Quick Start

### Install

```bash
git clone https://github.com/mandaniainarandriambinintsoa/geo-seo-boost.git
cd geo-seo-boost
./install.sh
```

### Python Dependencies

```bash
pip install beautifulsoup4 requests lxml reportlab Pillow validators
```

---

## Commands

| Command | What It Does |
|---------|-------------|
| `/geo audit <url>` | **Full GEO + SEO + GSC audit** (the big one) |
| `/geo gsc` | Google Search Console report (8 phases) |
| `/geo quick <url>` | 60-second GEO visibility snapshot |
| `/geo citability <url>` | Score content for AI citation readiness |
| `/geo crawlers <url>` | Check AI crawler access (robots.txt) |
| `/geo llmstxt <url>` | Analyze or generate llms.txt |
| `/geo brands <url>` | Scan brand mentions (YouTube, Reddit, Wikipedia...) |
| `/geo platforms <url>` | Platform-specific optimization |
| `/geo schema <url>` | Structured data analysis and generation |
| `/geo technical <url>` | Technical SEO audit |
| `/geo content <url>` | Content quality and E-E-A-T |
| `/geo report <url>` | Client-ready markdown report |
| `/geo report-pdf <url>` | Professional PDF report with charts |

---

## How `/geo audit` Works

The full audit combines **GEO analysis** with **real GSC data** in 4 phases:

### Phase 1: Discovery
- Fetch homepage, detect business type (SaaS, Local, E-commerce, Publisher, Agency)
- Crawl sitemap for page inventory

### Phase 2: Parallel Analysis (6 tracks)
All running simultaneously:

| Track | Analysis |
|-------|----------|
| AI Visibility | Citability, crawler access, llms.txt, brand mentions |
| Platform Analysis | ChatGPT, Perplexity, Google AIO readiness |
| Technical SEO | Core Web Vitals, SSR, security, mobile |
| Content E-E-A-T | Quality, author, sources, freshness |
| Schema Markup | Detection, validation, JSON-LD generation |
| **GSC Data** | **Performance, indexation, sitemaps, top queries** |

### Phase 3: Cross-Analysis
- GSC keyword gaps crossed with GEO citability scores
- Pages with high GSC potential + low citability = top priority

### Phase 4: Synthesis
- **GEO Score** (0-100) with 6 weighted categories
- **SEO Health Score** (0/10) from real GSC data
- Prioritized action plan with quick wins

---

## Dual Scoring System

### GEO Score (0-100)

| Category | Weight |
|----------|--------|
| AI Citability and Visibility | 25% |
| Brand Authority Signals | 20% |
| Content Quality and E-E-A-T | 20% |
| Technical Foundations | 15% |
| Structured Data | 10% |
| Platform Optimization | 10% |

### SEO Health Score (0/10) — from GSC

Based on real data: clicks, impressions, CTR, position, indexation rate, sitemap coverage, trends.

---

## Architecture

```
geo-seo-boost/
├── geo/                          # Main unified skill (GEO + GSC)
│   └── SKILL.md                  # Orchestrator with 13 sub-commands
├── skills/                       # 11 specialized sub-skills
│   ├── geo-audit/                # Full audit orchestration
│   ├── geo-citability/           # AI citation scoring
│   ├── geo-crawlers/             # AI crawler analysis
│   ├── geo-llmstxt/              # llms.txt analysis
│   ├── geo-brand-mentions/       # Brand presence scanning
│   ├── geo-platform-optimizer/   # Platform optimization
│   ├── geo-schema/               # Structured data
│   ├── geo-technical/            # Technical SEO
│   ├── geo-content/              # Content and E-E-A-T
│   ├── geo-report/               # Markdown report
│   └── geo-report-pdf/           # PDF report
├── agents/                       # 5 parallel subagents
├── scripts/                      # Python utilities
│   ├── fetch_page.py             # Page fetching and parsing
│   ├── citability_scorer.py      # Citability scoring engine
│   ├── brand_scanner.py          # Brand mention detection
│   ├── llmstxt_generator.py      # llms.txt generator
│   └── generate_pdf_report.py    # PDF report (ReportLab)
├── schema/                       # JSON-LD templates
├── install.sh                    # Installer
├── uninstall.sh                  # Uninstaller
└── requirements.txt              # Python dependencies
```

---

## Uninstall

```bash
./uninstall.sh
```

---

## Credits

- Forked from [zubair-trabzada/geo-seo-claude](https://github.com/zubair-trabzada/geo-seo-claude) (MIT License)
- GSC integration and boost by [Mandaniaina Randriambinintsoa](https://github.com/mandaniainarandriambinintsoa)

---

## License

MIT License — see [LICENSE](LICENSE)
