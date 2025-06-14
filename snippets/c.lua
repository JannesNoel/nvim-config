local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node

local rep = require("luasnip.extras").rep
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
        table.insert(nodes, i(j, arg_name))
        if comp_min and last_arg then
            table.insert(nodes, t(", ..."))
        end
        table.insert(nodes, t(used_close))
    end

    return sn(nil, nodes)
end

-- static snippet nodes (for easier readability && to maintain DRY principle)
local function disclaimer()
    return sn(nil, {
        t({
            "/*",
            "\tDisclaimer: I'm using a lot of snippets which I created with the luasnip plugin for nvim.",
            "\tThe code for the snippets can be found in this repo: https://github.com/JannesNoel/nvim-config",
            "*/",
            "",
        }),
    })
end

local function includes()
    return sn(nil, {
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
        t({ "// Rand and nanosleep includes", "#include <time.h>" }),
    })
end

local function macros()
    return sn(
        "macros",
        t({
            "// Time related macros",
            "#define MS_IN_S 1000",
            "#define NS_IN_MS 1000000",
            "#define S_TO_MS(x) ((long) (x * MS_IN_S))",
            "#define MS_TO_S(x) ((long) (x / MS_IN_S))",
            "#define MS_TO_NS(x) ((long) (x * NS_IN_MS))",
            "#define NS_TO_MS(x) ((long) (x / NS_IN_MS))",
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
        "\treturn min + (rand() % (max + 1 - min));",
        "}",
    })
end

local function rand_int_excl_max_sn()
    return t({
        "// Generates a random int in interval [min, max)",
        "int rand_int_excl_max(int min, int max) {",
        "\treturn min + (rand() % (max - min));",
        "}",
    })
end

-- exported snippets
local function c_main()
    return s(
        "c_main",
        fmt(
            [[
        {}
        {}

        {}

        int main({}) {{
            {}

            return EXIT_SUCCESS;
        }}

    ]],
            {
                disclaimer(),
                includes(),
                macros(),
                c(1, {
                    t("int argc, char* argv[]"),
                    t("void"),
                }),
                i(2, "// TODO: Implement"),
            }
        )
    )
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
        perror("wait");
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
            unsigned int sleep_sec = MS_TO_S(duration_ms);
            unsigned int sleep_ms = duration_ms % MS_IN_S;
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
                    }}

                    sleep_failed = true;
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

-- Todo add basic thread_attrs
local function thread_single()
    return s(
        "thread_single",
        fmt(
            [[
        pthread_t thread;
        {} param;
        if (pthread_create(&thread, NULL, {}, &param) != 0) {{
            {}
        }}


        // Join thread
        {}* thread_ret;
        if (pthread_join(thread, (void**) &thread_ret) != 0) {{
            {}
        }}
    ]],
            {
                i(1, "param_type"),
                i(2, "NULL"),
                i(3, "// TODO: Handle thread creation err"),
                i(4, "return_type"),
                i(5, "// TODO: Handle thread join err"),
            }
        )
    )
end

-- Todo add basic thread_attrs
local function thread_mult()
    return s(
        "thread_mult",
        fmt(
            [[
        size_t last_idx;
        size_t thread_amt = {};
        bool thread_err = false;
        pthread_t threads[thread_amt];
        {} params[thread_amt];
        for (size_t i = 0; i < thread_amt; i++) {{
            {}
            // TODO: Construct thread attrs if needed
            if (pthread_create(&threads[i], NULL, {}, &params[i]) != 0) {{
                thread_err = true;
                last_idx = i - 1;
            }}
        }}

        // Handle thread creation error
        if (thread_err) {{
            for (size_t i = 0; i < last_idx; i++) {{
                pthread_join(threads[i], NULL);
            }}

            {}
            exit(EXIT_FAILURE);
        }}

        //Join all threads
        {}* thread_ret[thread_amt];
        for (size_t i = 0; i < thread_amt; i++) {{
            if (pthread_join(threads[i], (void**) &thread_ret[i]) != 0) {{
                {}
            }}
        }}
        ]],
            {
                i(1, "thread_amt"),
                i(2, "param_type"),
                i(3, "// TODO: Construct param"),
                i(4, "thread_func"),
                i(5, "// TODO: Handle error"),
                i(6, "thread_ret_type"),
                i(7, "// TODO: Handle thread join error"),
            }
        )
    )
end

local function thread_func()
    return s(
        "thread_func",
        fmt(
            [[
            void* {}(void* param) {{
                {}* {} = ({}*)param;

                {}
            }}
        ]],
            {
                i(1, "func_name"),
                i(2, "arg_type"),
                i(3, "arg_name"),
                rep(2),
                i(4, "// TODO: Implement"),
            }
        )
    )
end

local function myqueue()
    return s(
        "myqueue",
        fmt(
            [[
#ifndef MYQUEUE_H_
#define MYQUEUE_H_

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <sys/queue.h>  // see queue(7) & stailq(3)


struct myqueue_entry {{
    {} value;
    STAILQ_ENTRY(myqueue_entry) entries;
}};

STAILQ_HEAD(myqueue_head, myqueue_entry);

typedef struct myqueue_head myqueue;

static void myqueue_init(myqueue* q) {{
    STAILQ_INIT(q);
}}

static bool myqueue_is_empty(myqueue* q) {{
    return STAILQ_EMPTY(q);
}}

static void myqueue_push(myqueue* q, {} value) {{
    struct myqueue_entry* entry = (struct myqueue_entry*)malloc(sizeof(struct myqueue_entry));
    entry->value = value;
    STAILQ_INSERT_TAIL(q, entry, entries);
}}

static {} myqueue_pop(myqueue* q) {{
    assert(!myqueue_is_empty(q));
    struct myqueue_entry* entry = STAILQ_FIRST(q);
    const {} value = entry->value;
    STAILQ_REMOVE_HEAD(q, entries);
    free(entry);
    return value;
}}

#endif
            ]],
            {
                i(1, "value_type"),
                rep(1),
                rep(1),
                rep(1),
            }
        )
    )
end

-- todo: signal handling, semaphores, barriers (maybe also my_barrier.h), fifo, unnamed pipe, server & client, sockets, files, makefile snippets, message queues, shared_mem, thread_pool, mmap

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
    thread_single(),
    thread_mult(),
    thread_func(),
    myqueue(),
}
