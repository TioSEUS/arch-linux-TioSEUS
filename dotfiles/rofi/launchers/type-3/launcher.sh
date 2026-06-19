#!/usr/bin/env bash

## TioSEUS Rofi Launcher
## Grid fullscreen com ícones grandes (type-3 style)

dir="$HOME/.config/rofi/launchers/type-3"
theme='style-3'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
