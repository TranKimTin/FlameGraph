#!/bin/bash
set -e

BIN=~/BotFather/botfather_c++/build/backtest
FG=~/FlameGraph
args="$@"

sudo perf record -F 99 -g "$BIN" $args
sudo perf script > out.perf
$FG/stackcollapse-perf.pl out.perf > out.folded
$FG/flamegraph.pl out.folded > flamegraph.svg
xdg-open flamegraph.svg >/dev/null 2>&1 &
