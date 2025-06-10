local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node

local fmt = require("luasnip.extras.fmt").fmt

-- dynamic snippet nodes (based on prev input / selections)
local function generate_arg_names(args)
    local compType = args[1][1] or ""
    local n = tonumber(args[2][1]) or 1

    local nodes = {}

    local default_open = "<"
    local default_close = ">"

    local last_open = default_open
    local last_close = default_close

    local comp_min = false
    if compType == "<" then
        comp_min = true

        last_open = "["
        last_close = "]"
    end

    for j = 1, n - 1 do
        local last_arg = j == n - 1

        local used_open = not last_arg and default_open or last_open
        local used_close = not last_arg and default_close or last_close

        local arg_name = "arg_name" .. j
        table.insert(nodes, t(" " .. used_open))
        if comp_min and last_arg then
            table.insert(nodes, i(j, arg_name))
            table.insert(nodes, t(", ..."))
        else
            table.insert(nodes, i(j, arg_name))
        end
        table.insert(nodes, t(used_close))
    end

    return sn(nil, nodes)
end

local function generate_rand_func(args)
    local rand_range = args[1][1]

    local nodes = {}
    table.insert(nodes, t("return min + rand() % ("))

    if rand_range == "[min, max]" then
        table.insert(nodes, t("max+1"))
    else
        table.insert(nodes, t("max"))
    end

    table.insert(nodes, t(" - min);"))
    return sn(nil, nodes)
end

-- static snippet nodes (for easier readability && to maintain DRY principle)
local function includes()
    return sn(nil, {
        t({
            "/*",
            "\tDisclaimer: I'm using a lot of snippets I created with the luasnip plugin for nvim.",
            "\tThe code for the snippets can be found in this repo: TODO: Add repo link",
            "*/",
            "",
            "",
        }),
        t({
            "// Base Includes",
            "#include <stdio.h>",
            "#include <stdlib.h>",
            "#include <stddef.h>",
            "#include <pthread.h>",
            "#include <errno.h>",
            "",
            "",
        }),
        t({ "// Type Includes", "#include <stdbool.h>", "#include <string.h>", "#include <stdatomic.h>", "", "" }),
        t({
            "// Fork includes and sleep (unistd)",
            "#include <unistd.h>",
            "#include <sys/types.h>",
            "#include <sys/wait.h>",
            "",
            "",
        }),
        t({ "// Rand and nanosleep includes", "#include <time.h>", "", "" }),
    })
end

local function macros()
    return sn(
        "macros",
        t({
            "// Time related macros",
            "#define MS_TO_NS(x) (((int) x) * 1e6)",
            "",
            "",
        })
    )
end

local function fork_once_sn()
    return sn(
        "fork_once_sn",
        fmt(
            [[
    pid_t pid = fork();
    if (pid < 0) {{
        perror("fork");
        {}
        exit(EXIT_FAILURE);
    }} else if (pid == 0) {{
        // Beware: all global and dynamically allocated vars have to be handled
        {}
        exit(EXIT_SUCCESS);
    }}
    ]],
            {
                i(1, "// TODO: Handle Fork failure"),
                i(2, "// TODO: Run child process code"),
            }
        )
    )
end

local function rand_int_incl_max_sn()
    return t({
        "// Generates a random int in interval [min, max]",
        "int rand_int_incl_max(int min, int max) {",
        "\treturn min + rand() % (max+1 - min);",
        "}",
    })
end

local function rand_int_excl_max_sn()
    return t({
        "// Generates a random int in interval [min, max)",
        "int rand_int_excl_max(int min, int max) {",
        "\treturn min + rand() % (max - min);",
        "}",
    })
end

-- exported snippets
local function c_main()
    return s("c_main", {
        includes(),
        macros(),
        t({ "int main(" }),
        c(1, {
            t("void"),
            t("int argc, char* argv[]"),
        }),
        t({ ") {", "\t" }),
        i(2, "// TODO: implement"),
        t({ "", "\treturn EXIT_SUCCESS;", "}" }),
    })
end

local function check_args()
    return s(
        "check_args",
        fmt(
            [[
    if (argc {} {}) {{
        fprintf(stderr, "USAGE: %s{}\n", argv[0]);
        exit(EXIT_FAILURE);
    }}

    {}
    ]],
            {
                c(1, { t("!="), t("<") }),
                i(2, "2"),
                d(3, generate_arg_names, { 1, 2 }),
                i(4, "// TODO: Implement"),
            }
        )
    )
end

local function fork_once()
    return s(
        "fork_once",
        fmt(
            [[
    {}

    {}
    ]],
            {
                d(1, fork_once_sn),
                i(2, "// TODO: Run main_process code"),
            }
        )
    )
end

local function fork_mult()
    return s(
        "fork_mult",
        fmt(
            [[
    for (size_t i = 0; i < {}; i++) {{
        {}
    }}

    {}
    ]],
            {
                i(1, "fork_amt"),
                d(2, fork_once_sn),
                i(3, "// TODO: Handle main prog"),
            }
        )
    )
end

local function wait_once()
    return s(
        "wait_once",
        fmt(
            [[
    if (wait(NULL) == -1) {{
        perror("wait);
        {}
        exit(EXIT_FAILURE);
    }}
    ]],
            {
                i(1, "// TODO: Handle wait error"),
            }
        )
    )
end

local function wait_all()
    return s(
        "wait_all",
        fmt(
            [[
    int wait_ret = 1;
    bool wait_err = false;
    while (wait_ret) {{
        wait_ret = wait(NULL);

        if (wait_ret == -1) {{
            perror("wait");
            wait_err = true;
            continue;
        }}

    }}

    if (wait_err) {{
        {}
    }}
    ]],
            {
                i(1, "// TODO: Handle wait error"),
            }
        )
    )
end

local function srand()
    return s("srand", {
        t({ "srand(time(NULL));", "", "" }),
        i(1, "// TODO: Implement"),
    })
end

local function rand_int_func()
    return s(
        "rand_int_func",
        c(1, {
            rand_int_incl_max_sn(),
            rand_int_excl_max_sn(),
        })
    )
end

local function sleep_ms_func()
    return s(
        "sleep_ms_func",
        fmt(
            [[
        bool sleep_ms(unsigned int duration_ms) {{
            unsigned int sleep_sec = duration_ms / 1000;
            unsigned int sleep_ms = duration_ms % 1000;
            struct timespec sleep_dur = {{
                .tv_sec = sleep_sec,
                .tv_nsec = MS_TO_NS(sleep_ms),
            }};

            bool sleep_failed = false;
            while (true) {{
                int sleep_res = nanosleep(&sleep_dur, &sleep_dur);
                if (sleep_res == -1) {{
                    if (errno == EINTR) {{
                        continue;
                    }} else {{
                        sleep_failed = true;
                    }}
                }}
                break;
            }}

            return !sleep_failed;
        }}
    ]],
            {}
        )
    )
end

-- todo: signal handling, pthread, mutex, semaphores, barriers (maybe also my_barrier.h), fifo, unnamed pipe, server & client, sockets, files, makefile snippets, message queues, myqueue (ex06), shared_mem, thread_pool, mmap
-- todo: thread_function

return {
    c_main(),
    check_args(),
    fork_once(),
    fork_mult(),
    wait_once(),
    wait_all(),
    srand(),
    rand_int_func(),
    sleep_ms_func(),
}
