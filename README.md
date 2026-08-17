# Acreedom

**Maintainer:** Natalie (AcreetionOS)  
**Source:** GNU IceCat + Firefox ESR  
**Part of:** [AcreetionOS](https://acreetionos.org)

Privacy-first Gecko browser engine for AcreetionOS. Fork of GNU IceCat (which is itself Firefox ESR + GNU privacy patches).

## Prerequisites

- [**codeberg-tool**](https://github.com/spivanatalie64/codeberg-tool) — For Codeberg operations (`berg` CLI)
- `gh` — GitHub CLI (authenticated)
- `glab` — GitLab CLI (authenticated to your instance)

You will need to set up your own remotes. The script prompts for them,
or you can pre-set environment variables:

```bash
export GITHUB_REPO="git@github.com:USER/acreetium.git"
export GITLAB_REPO="git@gitlab.com:USER/acreetium.git"
export CODEBERG_REPO="git@codeberg.org:USER/acreetium.git"
```

## Setup

```bash
./setup-acreedom.sh
```

Clones GNU IceCat from `git.savannah.gnu.org/git/gnuzilla.git` and Firefox ESR
from `github.com/mozilla-firefox/firefox.git`, then pushes to all your remotes.

## About

This repository was scaffolded with assistance from an AI agent.
See `.opencode/agents/` for documentation on the agent's role and capabilities.
