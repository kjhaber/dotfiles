return {
    -- Text object for portions of a variable name (iv, av) - snake or camel case
    {
      "Julian/vim-textobj-variable-segment",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for backticks (yi`)
    {
      "fvictorio/vim-textobj-backticks",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for the entire doc (ae, ie) - ie skips leading/trailing lines
    -- (rarely used)
    {
      "kana/vim-textobj-entire",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for last searched pattern (a/, i/) (rarely used)
    {
      "kana/vim-textobj-lastpat",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for text between underscores (a_, i_) (rarely used)
    {
      "kana/vim-textobj-underscore",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for entire line (al, il)
    {
      "kana/vim-textobj-line",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for closest pair of quotes (single quote, double quote, backtick)
    {
      "beloglazov/vim-textobj-quotes",
      dependencies = { "kana/vim-textobj-user" }
    },

    -- Text object for Ruby blocks (ar, ir) (rarely used)
    {
      "nelstrom/vim-textobj-rubyblock",
      dependencies = { "kana/vim-textobj-user" }
    },
}
