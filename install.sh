#!/usr/bin/env sh

ZED_AGENTS_DIRNAME=~/.config/zed
HOME_AGENTS_DIRNAME=~/.agents
SKILL_FOLDER="$HOME_AGENTS_DIRNAME"/skills

REFS="refs/heads/main"

mkdir -p "$ZED_AGENTS_DIRNAME"
mkdir -p "$ZED_AGENTS_DIRNAME"/guidelines
mkdir -p "$HOME_AGENTS_DIRNAME"

if [ -d "$SKILL_FOLDER" ]; then
    rm -rf "$SKILL_FOLDER"
fi

if [ -d "$ZED_AGENTS_DIRNAME"/guidelines ]; then
    rm -rf "$ZED_AGENTS_DIRNAME"/guidelines
fi

curl -L -sS https://raw.githubusercontent.com/slacking-eveywhere/agents/"$REFS"/AGENTS.md -o "$ZED_AGENTS_DIRNAME"/AGENTS.md
curl -L -sS https://raw.githubusercontent.com/slacking-eveywhere/agents/"$REFS"/bin/skills.tar.gz | tar -xz -C "$HOME_AGENTS_DIRNAME"
curl -L -sS https://raw.githubusercontent.com/slacking-eveywhere/agents/"$REFS"/bin/guidelines.tar.gz | tar -xz -C "$ZED_AGENTS_DIRNAME"

printf "Installed AGENTS.md in %s\nguidelines in %s\nskills in %s\n" $ZED_AGENTS_DIRNAME $ZED_AGENTS_DIRNAME $SKILL_FOLDER
