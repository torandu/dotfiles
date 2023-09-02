if exists("b:did_ftplugin")
    finish
endif
let b:did_ftplugin = 1

set keywordprg=man\ ssh_config\ -P\ \'less\ -p\ <cword>\'
