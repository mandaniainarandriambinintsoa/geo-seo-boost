---
name: geo
description: >
  Audit GEO+SEO+GSC unifie pour Claude Code — optimisation pour moteurs IA
  (ChatGPT, Claude, Perplexity, Gemini, Google AI Overviews) avec donnees
  reelles Google Search Console. Citabilite IA, crawlers, llms.txt, brand
  mentions, schema, technique, contenu E-E-A-T, keyword gap, et rapports PDF.
  Utiliser quand l'utilisateur dit "geo", "seo", "gsc", "audit", "AI search",
  "citabilite", "llms.txt", "schema", "brand mentions", ou toute URL a analyser.
allowed-tools: Read, Grep, Glob, Bash, WebFetch, Write
---

# GEO-SEO-GSC — Skill Unifie pour Claude Code

> **Philosophie:** GEO-first, SEO-supported, GSC-powered.
> L'IA devore la recherche traditionnelle. Cet outil optimise pour ou le trafic va, pas ou il etait.
> La difference avec l'original : **donnees reelles GSC** integrees a chaque audit.

---

## Reference Rapide

| Commande | Description |
|----------|-------------|
| `/geo audit <url>` | Audit complet GEO + SEO + GSC (tout) |
| `/geo gsc` | Rapport Google Search Console seul (8 phases) |
| `/geo quick <url>` | Snapshot GEO en 60 secondes |
| `/geo citability <url>` | Score de citabilite IA par passage |
| `/geo crawlers <url>` | Analyse robots.txt pour crawlers IA |
| `/geo llmstxt <url>` | Analyse/generation llms.txt |
| `/geo brands <url>` | Scan mentions de marque (YouTube, Reddit, Wikipedia...) |
| `/geo platforms <url>` | Optimisation par plateforme (ChatGPT, Perplexity, Google AIO) |
| `/geo schema <url>` | Audit donnees structurees + generation JSON-LD |
| `/geo technical <url>` | Audit technique SEO |
| `/geo content <url>` | Qualite contenu + E-E-A-T |
| `/geo report <url>` | Rapport client markdown |
| `/geo report-pdf <url>` | Rapport PDF professionnel avec graphiques |

---

## Contexte Marche (Pourquoi GEO)

| Metrique | Valeur | Source |
|----------|--------|--------|
| Marche GEO (2025) | $850M+ | Yahoo Finance |
| Projection 2031 | $7.3B (34% CAGR) | Analystes |
| Croissance trafic IA | +527% (Jan-Mai 2025) | SparkToro |
| Conversion IA vs organique | 4.4x plus eleve | Donnees industrie |
| Google AI Overviews | 1.5B users/mois, 200+ pays | Google |
| ChatGPT users actifs | 900M+/semaine | OpenAI |
| Perplexity requetes | 500M+/mois | Perplexity |
| Gartner: baisse search 2028 | -50% | Gartner |
| Brand mentions vs backlinks | 3x plus fort pour IA | Ahrefs (Dec 2025) |

---

# SECTION 1 — `/geo gsc` : Rapport Google Search Console

Quand l'utilisateur tape `/geo gsc`, executer les 8 phases ci-dessous.
Prerequis : MCP GSC Server configure dans Claude Code.

## Phase 0 — Identification du site

1. Lister les proprietes GSC disponibles via `mcp__gsc__list_properties`
2. Si une seule propriete : l'utiliser automatiquement
3. Si plusieurs proprietes : demander au user laquelle analyser via `AskUserQuestion`
4. Stocker le `site_url` pour toutes les etapes suivantes

## Phase 1 — Vue d'ensemble performance (28 derniers jours)

1. Appeler `mcp__gsc__get_performance_overview` (days=28)
2. Afficher un resume formate :
   ```
   === PERFORMANCE (28 derniers jours) ===
   Clics totaux      : X
   Impressions        : X
   CTR moyen          : X%
   Position moyenne   : X
   ```

## Phase 2 — Comparaison de periodes

1. Comparer les 28 derniers jours vs les 28 jours precedents via `mcp__gsc__compare_search_periods`
   - Dimensions : `query`
   - Limit : 20
2. Afficher les tendances :
   ```
   === EVOLUTION vs PERIODE PRECEDENTE ===
   Clics      : +X% / -X%
   Impressions: +X% / -X%
   CTR        : +X pts / -X pts
   Position   : amelioration / degradation

   Top requetes en croissance : ...
   Top requetes en baisse     : ...
   ```

## Phase 3 — Top requetes et pages

Lancer ces 4 appels **en parallele** :

1. `mcp__gsc__get_advanced_search_analytics` — dimensions: `query`, sort_by: `clicks` desc, row_limit: 20
2. `mcp__gsc__get_advanced_search_analytics` — dimensions: `page`, sort_by: `clicks` desc, row_limit: 20
3. `mcp__gsc__get_advanced_search_analytics` — dimensions: `device`
4. `mcp__gsc__get_advanced_search_analytics` — dimensions: `country`, row_limit: 10

Puis un 5e appel avec **periode elargie** (90 jours) :

5. `mcp__gsc__get_advanced_search_analytics` — dimensions: `query,page`, sort_by: `impressions` desc, row_limit: 30, start_date: 90 jours avant

Afficher :
```
=== TOP 20 REQUETES ===
| # | Requete | Clics | Impressions | CTR | Position |

=== TOP 20 PAGES ===
| # | Page | Clics | Impressions | CTR | Position |

=== REPARTITION PAR DEVICE ===
Desktop : X% | Mobile : X% | Tablet : X%

=== TOP PAYS ===
| Pays | Clics | Impressions | CTR | Position |
```

## Phase 4 — Sitemaps

1. `mcp__gsc__list_sitemaps_enhanced` pour lister tous les sitemaps
2. Pour chaque sitemap, noter : URLs soumises vs indexees, derniere soumission, erreurs
3. Afficher :
   ```
   === SITEMAPS ===
   | Sitemap | URLs soumises | URLs indexees | Taux | Derniere soumission |
   ```

## Phase 5 — Inspection d'indexation

1. Prendre les 5-10 pages les plus importantes (Phase 3) + pages strategiques du sitemap non presentes dans les tops
2. Appeler `mcp__gsc__batch_url_inspection` avec ces URLs
3. Pour chaque URL : statut d'indexation, couverture, rich results, derniere exploration
4. Afficher :
   ```
   === INDEXATION ===
   | Page | Statut | Couverture | Rich Results | Derniere exploration |
   Pages non indexees ou en erreur : [liste]
   ```

## Phase 6 — Analyse mots-cles et contenu (keyword gap)

### 6.1 Identifier les opportunites
Pour chaque page avec impressions :
1. `mcp__gsc__get_search_by_page_query` pour obtenir les requetes associees
2. Si GSC anonymise (volume faible), elargir a 90 jours

### 6.2 Verifier presence dans le contenu
Pour chaque couple (requete vers page) :
1. Lire le code source de la page (dictionnaires i18n, composants, metadata)
2. Chercher le mot-cle exact avec `Grep`
3. Classifier :
   - **Present et bien place** (H1, title, meta description) = OK
   - **Present mais faible** (body uniquement) = a renforcer
   - **Absent** = a ajouter

### 6.3 Afficher
```
=== KEYWORD GAP ===
| Page | Mot-cle GSC | Impressions | Position | Present ? | Action |
```

## Phase 7 — Opportunites d'amelioration

### 7.1 Quick Wins
- Requetes position 5-20 avec impressions elevees mais CTR faible = optimiser title/meta
- Requetes position 11-20 = pousser en 1ere page
- Mots-cles manquants = les ajouter

### 7.2 Problemes d'indexation
- Pages non indexees, erreurs de crawl, ecarts sitemap

### 7.3 Contenu
- Requetes sans page dediee = creer du contenu
- Pages sans trafic = ameliorer ou desindexer
- Cannibalization

### 7.4 Technique
- Ecart mobile vs desktop, rich results manquants, couverture sitemap

## Phase 8 — Resume executif
```
=== RESUME EXECUTIF ===
Site : [url]
Periode : [dates]
Points forts : ...
Points faibles : ...
Actions prioritaires : 1. ... 2. ... 3. ...
Score sante SEO : X/10
```

---

# SECTION 2 — `/geo audit <url>` : Audit Complet GEO+SEO+GSC

C'est l'audit le plus complet. Il combine les analyses GEO avec les donnees reelles GSC.

## Phase 1 : Decouverte (Sequentiel)

1. Fetch homepage HTML via WebFetch
2. Detecter le type de business :
   | Type | Signaux |
   |------|---------|
   | **SaaS** | Pricing, "Sign up", "Free trial", API docs |
   | **Local** | Adresse, telephone, Google Maps, zone de service |
   | **E-commerce** | Produits, panier, prix, "Add to cart" |
   | **Publisher** | Blog, articles, bylines, dates |
   | **Agency** | Portfolio, cas clients, "Nos services", temoignages |
3. Extraire les pages cles depuis sitemap.xml (max 50 pages)

## Phase 2 : Analyse Parallele (6 tracks simultanees)

Lancer ces 6 analyses **en parallele** :

| # | Track | Responsabilite |
|---|-------|---------------|
| 1 | **AI Visibility** | Citabilite, crawlers IA, llms.txt, brand mentions |
| 2 | **Platform Analysis** | Optimisation ChatGPT, Perplexity, Google AIO |
| 3 | **Technical SEO** | Core Web Vitals, SSR, securite, mobile |
| 4 | **Content E-E-A-T** | Qualite contenu, auteur, sources, fraicheur |
| 5 | **Schema Markup** | Detection, validation, generation JSON-LD |
| 6 | **GSC Data** | Phases 0-5 du rapport GSC (performance, indexation, sitemaps) |

## Phase 3 : Keyword Gap + Citabilite Croisee

1. Executer Phase 6 du GSC (keyword gap)
2. Pour chaque page avec un gap de mot-cle, scorer aussi sa citabilite IA
3. Croiser : pages a fort potentiel GSC + faible citabilite = priorite maximale

## Phase 4 : Synthese et Scoring

### GEO Score (0-100)

| Categorie | Poids | Mesure |
|-----------|-------|--------|
| Citabilite IA | 25% | Qualite des passages, answer blocks, acces crawlers |
| Autorite de Marque | 20% | Mentions Reddit, YouTube, Wikipedia, LinkedIn |
| Contenu E-E-A-T | 20% | Expertise, sources, auteur, fraicheur |
| Technique | 15% | SSR, Core Web Vitals, securite, mobile |
| Donnees Structurees | 10% | Schema completude, validation JSON-LD |
| Optimisation Plateforme | 10% | Readiness ChatGPT, Perplexity, Google AIO |

### SEO Health Score (0/10) — depuis GSC

Base sur les donnees reelles :
- Clics, impressions, CTR, position moyenne
- Taux d'indexation
- Couverture sitemap
- Tendance vs periode precedente

### Rapport Final

Generer `GEO-AUDIT-REPORT.md` avec :
- Resume executif (GEO Score + SEO Health Score)
- Score breakdown par categorie
- Issues critiques / hautes / moyennes / basses
- Quick Wins (cette semaine)
- Plan d'action 30 jours
- Donnees GSC integrees (top requetes, pages, keyword gaps)
- Annexe : pages analysees

---

# SECTION 3 — Sous-commandes GEO

Chaque sous-commande route vers le sub-skill correspondant :

| Commande | Sub-skill | Script Python |
|----------|-----------|---------------|
| `/geo citability <url>` | `geo-citability/` | `scripts/citability_scorer.py` |
| `/geo crawlers <url>` | `geo-crawlers/` | `scripts/fetch_page.py robots` |
| `/geo llmstxt <url>` | `geo-llmstxt/` | `scripts/llmstxt_generator.py` |
| `/geo brands <url>` | `geo-brand-mentions/` | `scripts/brand_scanner.py` |
| `/geo platforms <url>` | `geo-platform-optimizer/` | — |
| `/geo schema <url>` | `geo-schema/` | — |
| `/geo technical <url>` | `geo-technical/` | — |
| `/geo content <url>` | `geo-content/` | — |
| `/geo report <url>` | `geo-report/` | — |
| `/geo report-pdf <url>` | `geo-report-pdf/` | `scripts/generate_pdf_report.py` |

### Utilisation des scripts Python

Les scripts sont dans `~/.claude/skills/geo/scripts/`. Executer via :
```bash
python3 ~/.claude/skills/geo/scripts/fetch_page.py <url> [mode]
python3 ~/.claude/skills/geo/scripts/citability_scorer.py <url>
python3 ~/.claude/skills/geo/scripts/brand_scanner.py "<brand>" [domain]
python3 ~/.claude/skills/geo/scripts/llmstxt_generator.py <url> [validate|generate]
python3 ~/.claude/skills/geo/scripts/generate_pdf_report.py <data.json> [output.pdf]
```

---

# SECTION 4 — Fichiers de Sortie

| Commande | Fichier genere |
|----------|---------------|
| `/geo audit` | `GEO-AUDIT-REPORT.md` |
| `/geo gsc` | Affichage inline (pas de fichier) |
| `/geo citability` | `GEO-CITABILITY-SCORE.md` |
| `/geo crawlers` | `GEO-CRAWLER-ACCESS.md` |
| `/geo llmstxt` | `llms.txt` (pret a deployer) |
| `/geo brands` | `GEO-BRAND-MENTIONS.md` |
| `/geo schema` | `GEO-SCHEMA-REPORT.md` + JSON-LD |
| `/geo technical` | `GEO-TECHNICAL-AUDIT.md` |
| `/geo content` | `GEO-CONTENT-ANALYSIS.md` |
| `/geo report` | `GEO-CLIENT-REPORT.md` |
| `/geo report-pdf` | `GEO-REPORT.pdf` |
| `/geo quick` | Inline (pas de fichier) |

---

# SECTION 5 — Regles

- **Langue** : Toute sortie en francais sauf demande explicite de l'utilisateur
- **GSC d'abord** : Pour `/geo audit`, toujours collecter les donnees GSC en parallele des analyses GEO
- **Appels paralleles** : Maximiser les appels MCP en parallele (Phase 3 GSC = 4 appels simultanes)
- **Formatter en tableaux markdown** pour la lisibilite
- **Recommandations actionnables** : toujours basees sur les donnees reelles, jamais generiques
- **Si une API echoue** : noter l'erreur, continuer avec les donnees disponibles
- **Volume faible GSC** : elargir la periode a 90 jours, utiliser dimensions `query,page` croisees
- **Keyword gap obligatoire** : toujours verifier les mots-cles dans le contenu source
- **Proposer d'appliquer** les corrections directement si le projet est local
- **Crawl limit** : Max 50 pages par audit
- **Timeout** : 30 secondes par page fetch
- **Robots.txt** : Toujours respecter
- **Mettre a jour MEMORY.md** apres chaque rapport avec les metriques cles
