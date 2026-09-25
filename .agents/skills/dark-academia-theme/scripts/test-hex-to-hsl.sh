#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
helper="$script_dir/hex-to-hsl.sh"
tests_run=0

fail() {
    printf 'FAIL: %s\n' "$1" >&2
    exit 1
}

assert_output() {
    local input=$1
    local expected=$2
    local actual

    actual=$("$helper" "$input") || fail "$input returned nonzero"
    [[ $actual == "$expected" ]] ||
        fail "$input produced '$actual'; expected '$expected'"
    ((tests_run += 1))
}

assert_failure() {
    local expected_message=$1
    shift
    local error_file="$temporary_directory/error"
    local output_file="$temporary_directory/output"
    local result
    local error

    set +e
    "$helper" "$@" >"$output_file" 2>"$error_file"
    result=$?
    set -e

    [[ $result -ne 0 ]] || fail "invalid invocation returned zero"
    [[ ! -s $output_file ]] || fail "invalid invocation wrote to stdout"
    error=$(<"$error_file")
    [[ $error == *"$expected_message"* ]] ||
        fail "invalid invocation stderr '$error' omitted '$expected_message'"
    ((tests_run += 1))
}

temporary_directory=$(mktemp -d)
trap 'rm -f -- "$temporary_directory/error" "$temporary_directory/output"; rmdir -- "$temporary_directory"' EXIT

[[ -x $helper ]] || fail "$helper is not executable"

# Representative palette values.
assert_output '#080808' 'hsl(0, 0%, 3%)'
assert_output 'B89C5C' 'hsl(42, 39%, 54%)'

# Achromatic boundaries.
assert_output '000000' 'hsl(0, 0%, 0%)'
assert_output 'FFFFFF' 'hsl(0, 0%, 100%)'
assert_output '808080' 'hsl(0, 0%, 50%)'

# Primaries and equal-channel maxima.
assert_output 'FF0000' 'hsl(0, 100%, 50%)'
assert_output '00FF00' 'hsl(120, 100%, 50%)'
assert_output '0000FF' 'hsl(240, 100%, 50%)'
assert_output 'FFFF00' 'hsl(60, 100%, 50%)'
assert_output '00FFFF' 'hsl(180, 100%, 50%)'
assert_output 'FF00FF' 'hsl(300, 100%, 50%)'

# Values at or immediately around integer rounding and hue-wrap boundaries.
assert_output '020000' 'hsl(0, 100%, 0%)'
assert_output '030000' 'hsl(0, 100%, 1%)'
assert_output 'F00200' 'hsl(1, 100%, 47%)'
assert_output 'FF0002' 'hsl(0, 100%, 50%)'
assert_output 'FF0003' 'hsl(359, 100%, 50%)'

# Invalid arity and format.
assert_failure 'Usage:'
assert_failure 'Usage:' '000000' 'FFFFFF'
assert_failure 'Invalid sRGB hexadecimal color:' '12345'
assert_failure 'Invalid sRGB hexadecimal color:' '#12345G'

printf 'PASS: %d hex-to-HSL checks\n' "$tests_run"
