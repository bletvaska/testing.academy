#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'


URL="http://api.openweathermap.org/data/2.5/weather?units=metric&APPID=${APPID}&q=${CITY}"

APPID="3718d7f90e7b081ca8f46aa4305c05ea"
CITY="kosice"


get_weather() {
    declare appid=$1 
    declare city=$2

    echo curl -s "http://api.openweathermap.org/data/2.5/weather?units=metric&APPID=$appid&q=$city"
}


@test "when city is provided, then some data are received" {
    run $(get_weather "$APPID" "praha")
    assert_equal $(echo "$output" | jq -r .name) "Prague"
}

@test "when wrong API key is provided, then 401 with error message is returned" {
    run $(get_weather "wrong-key" "$CITY")
    message=$(echo "$output" | jq -r .message)

    assert_equal $(echo "$output" | jq -r .cod) 401  # "cod": 401
    assert_equal "$message" "Invalid API key. Please see http://openweathermap.org/faq#error401 for more info."  # "message": ...
}


@test "when non existing city is provided, then message with code 404 is returned" {
    run $(get_weather "$APPID" "vajcovany")
    message=$(echo "$output" | jq -r .message)

    assert_equal $(echo "$output" | jq -r .cod) 404  # "cod": 404
    assert_equal "$message" "city not found"  # "message": ...
}

