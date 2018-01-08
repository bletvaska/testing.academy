#!/usr/bin/env bats

@test "if chsh.sh is not able to run, then don't run any other tests" {
    run bash -c "which chsh.sh"

    # asserts
    [[ ${status} -eq 0 ]]
    [[ -x ${output} ]]
}


@test "if run, then login of currently logged in user must be shown" {
    USER=jano
    run bash -c 'export USER='${USER}'; echo -e "\n" | chsh.sh'

    # asserts
    [[ ${output} == "Changing shell for jano." ]]
}


@test "if run, then current shell of logged in user must be shown" {
    SHELL=/bin/megashell
    run bash -c 'export SHELL=${SHELL}; echo -e "\n" | chsh.sh'

    # asserts
    [[ ${output} == "Changing shell for ${USER}." ]]
}


@test "if no path is given, then no change is provided and exit with status 0" {
    run bash -c 'echo -e "\n" | chsh.sh'
    # TODO check, if shell was not changed in passwd file

    # asserts
    [[ ${status} -eq 0 ]]
}


@test "if no full path is provided, then print error message" {
    run bash -c 'echo "something" | chsh.sh'

    # asserts
    [[ ${output} =~ "chsh.sh: shell must be a full path name" ]]
}


@test "if no full path is provided, then exit with status 1" {
    run bash -c 'echo "something" | chsh.sh'

    # asserts
    [[ ${status} -eq 1 ]]
}


@test "if run with non existing file, then exit with status 1" {
    run bash -c 'echo "/this/path/doesnt/exist" | chsh.sh'

    # asserts
    [[ ${output} =~ "chsh.sh: \"/this/path/doesnt/exist\" does not exist" ]]
}


@test "if run with non existing file, then print error message" {
    run bash -c 'echo "/this/path/doesnt/exist" | chsh.sh'

    # asserts
    [[ ${output} =~ "chsh.sh: \"/this/path/doesnt/exist\" does not exist" ]]
}


@test "if run with non executable file, then exit with status 1" {
    run bash -c 'echo "/etc/passwd" | chsh.sh'

    # asserts
    [[ ${status} -eq 1 ]]
}


@test "if run with non executable file, then print error message" {
    run bash -c 'echo "/etc/passwd" | chsh.sh'

    # asserts
    [[ ${output} =~ "chsh.sh: \"/etc/passwd\" is not executable" ]]
}



@test "if run with path, which is not in /etc/shells, then exit with status 1" {
    run bash -c 'echo "/usr/bin/vi" | chsh.sh'
    
    # asserts
    [[ ${status} -eq 1 ]]
}


@test "if run with path, which is not in /etc/shells, then print error message" {
    run bash -c 'echo "/usr/bin/vi" | chsh.sh'

    # asserts
    [[ ${output} =~ 'chsh.sh: "/usr/bin/vi" is not listed in /etc/shells' ]]
}



@test "bonus #1: if run with path, which is not in /etc/shells, then print error message and exit with status 1" {
    run bash -c 'echo "/usr/bin/vi" | chsh.sh'

    # asserts
    [[ "${status}" -eq 1 ]]
    [[ "${output}" =~ 'chsh.sh: "/usr/bin/vi" is not listed in /etc/shells' ]]
    [[ "${output}" =~ "Use chsh.sh -l to see list." ]]
}

@test "bonus #1: if run with '-l', then exit with status 0" {
    run bash -c "chsh.sh -l"

    # asserts
    [[ ${status} -eq 0 ]]
}


@test "bonus #1: if run with '-l', then show content of /etc/shells" {
    run bash -c "chsh.sh -l"

    # asserts
    [[ ${output} == $(cat /etc/shells) ]]
}


