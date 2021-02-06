# terminal-tab.vim
 
Manage terminals in a single toggleable tabgroup. All new terminals, including those
created outside the tabgroup will automatically be managed and respond to the commands.
Additionally, set a default terminal configuration with autostart commands.

Terminals are separate from other buffers, and this plugin allows all of them to never
be more than a nmap away.

## Installation

Use your favorite package manager, or install manually. Here's a quick plug example

    Plug 'zacharydscott/vim-terminal-tab'

## Use
To Get started, map the 'TerminalTabToggle' command and you'll be ready.

    nnoremap <leader>t :TerminalTabToggle<CR>

To set up configure a custom set of terminals which can automatically run a command,
configure the g:terminal_tab_config property.


    g:terminal_tab_config = [{'load_command':'git pull'},
                           \ {'load_command':'start server'}]

More configurable options to come, hence the dictionary.
