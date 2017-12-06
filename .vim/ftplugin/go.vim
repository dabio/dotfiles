nmap <leader>b <Plug>(go-build)
nmap <leader>r <Plug>(go-run)
nmap <leader>t <Plug>(go-test)
nmap <leader>c <Plug>(go-coverage-toggle)

command! -bang A call go#alternate#Switch(<bang>0, 'edit')
command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
command! -bang AS call go#alternate#Switch(<bang>0, 'split')
command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

setlocal expandtab tabstop=4 shiftwidth=4
