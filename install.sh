#!/usr/bin/env sh

AGENTS_DIRNAME=~/.config/zed

mkdir -p "$AGENTS_DIRNAME"
mkdir -p "$AGENTS_DIRNAME"/guidelines
mkdir -p .agents/skills

if [ -d .agents/skills ]; then
    rm -rf .agents/skills
fi

curl -L https://raw.githubusercontent.com/slacking-eveywhere/agents/AGENTS.md -o "$AGENTS_DIRNAME"/AGENTS.md
curl -L https://raw.githubusercontent.com/slacking-eveywhere/agents/bin/skills.tar.gz | tar -xz -C .agents
curl -L https://raw.githubusercontent.com/slacking-eveywhere/agents/bin/guidelines.tar.gz | tar -xz -C "$AGENTS_DIRNAME"
