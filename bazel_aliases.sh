#!/usr/bin/env bash

alias bab="echo 'bazel build [target] (build one target)'; bazel build"
alias bat="echo 'bazel test [target] (run one test)'; bazel test"
alias bar="echo 'bazel run [target] (run an executable)'; bazel run"
alias bac="echo 'bazel clean (delete temporary cache files but not downloaded files)'; bazel clean"

# Sync and Fetch
alias baf="echo 'bazel fetch [target] (prefetch all external dependencies of a target)'; bazel fetch"
alias bas="echo 'bazel sync (unconditionally fetch all external repos)'; bazel sync"
# https://bazelbuild.github.io/rules_rust/crate_universe.html#repinning--updating-dependencies
alias basc="echo 'bazel CARGO_BAZEL_REPIN=1 bazel sync --only=crate_index (Update rust dependencies)'; CARGO_BAZEL_REPIN=1 bazel sync --only=crate_index"

# Query all (non-tool and non-implicit) dependencies of a target
function baqdeps() {
    TARGET=$1; REMAINING_ARGS="${@: 2}"
    bazel query --noimplicit_deps --notool_deps "deps($TARGET)" $REMAINING_ARGS
}

# Query all targets that depend on the given target
function baqrdeps() {
    TARGET=$1
    DEPTH=$2 && [ -z "$DEPTH" ] && DEPTH=1 # Depth may be supplied as the second argument, otherwise default is 1
    REMAINING_ARGS="${@: 3}"
    bazel query "rdeps(//..., $TARGET, $DEPTH)" --keep_going $REMAINING_ARGS
}

# Graph all paths between two nodes on the build graph by generating a PNG in your current directory.
# For example, to find out how `wifi` gains access to `uart_driver`;
#   `bagallpaths //package/wifi //package/uart_driver`
function bagallpaths() {
    TARGET=$1; DEPENDENCY=$2; REMAINING_ARGS="${@: 3}"
    bazel query "allpaths($TARGET, $DEPENDENCY)" --notool_deps $REMAINING_ARGS --output graph | dot -Tpng >graph.png
}

# Graph the build graph of a target's dependencies (non-tool and non-implicit) 
# by generating a PNG in your current directory.
function bagdeps() {
    TARGET=$1; REMAINING_ARGS="${@: 2}"
    bazel query --noimplicit_deps --notool_deps "deps($TARGET)" $REMAINING_ARGS --output graph >graph.in
    dot -Tpng <graph.in >graph.png
}