#!/usr/bin/env bats

@test "if bitday.sh is not able to run, then don't run any other tests" {
    run bash -c "which bitday.sh"

    # asserts
    [[ ${status} -eq 0 ]]
    [[ -x ${output} ]]
}


@test "if there are no 12 bitday pictures in Pictures/bitday/ folder, then don't run any other tests" {
    TOTAL=$(ls ~/Pictures/bitday/bitday{1..12}.png | wc -l)

    # asserts
    [[ ${TOTAL} -eq 12 ]]
}


@test "if run, then content of org.gnome.desktop.background setting must be changed" {
    run bitday.sh

    # asserts
    [[ $(gsettings get org.gnome.desktop.background picture-uri) =~ /bitday[0-9]{1,2}.png\'$ ]]
}


# @test "if some of the bitday pictures doesn't exist, then exit with status 1" {
# @test "if some of the bitday pictures doesn't exist, then print error message" {
