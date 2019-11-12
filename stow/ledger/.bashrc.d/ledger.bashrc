if which ledger &> /dev/null; then
# COPIED FROM https://gist.github.com/iphoting/5006503

_ledger() 
{ 
    local cur prev command options 
    COMPREPLY=() 
    cur="${COMP_WORDS[COMP_CWORD]}" 
    prev="${COMP_WORDS[COMP_CWORD-1]}" 

    # 26 commands 
    # command explicitely filtered out: push pop reload draft 
    commands="accounts balance budget cleared commodities convert csv 
echo emacs entry equity payees pricedb pricemap prices print register 
server source stats xact xml" 

    # 151 options 
    options="--abbrev-len= --account= --account-width= --actual -- 
actual-dates --add-budget --amount= --amount-data --amount-width= -- 
anon --ansi --args-only --average --balance-format= --base --basis -- 
begin= --bold-if= --budget --budget-format= --by-payee --cache= -- 
cleared --cleared-format= --collapse --collapse-if-zero --color -- 
columns= --cost --count --csv-format= --current --daily --date= --date- 
format= --datetime-format= --date-width= --days-of-week --debug= -- 
decimal-comma --depth= --deviation --display= --display-amount= -- 
display-total= --dow --download --effective --empty --end= --equity -- 
exact --exchange= --file= --first= --flat --force-color --force-pager 
--forecast= --forecast-while= --forecast-years= --format= --full-help 
--gain --generated --group-by= --group-title-format= --head= --help -- 
help-calc --help-comm --help-disp --import= --init-file= --inject= -- 
input-date-format= --invert --last= --leeway= --limit= --lot-dates -- 
lot-prices --lot-tags --lots --lots-actual --market --master-account= 
--meta= --meta-width= --monthly --no-color --no-rounding --no-titles -- 
no-total --now= --only= --options --output= --pager= --payee= --payee- 
width= --pending --percent --period= --period-sort --pivot= --plot- 
amount-format= --plot-total-format= --prepend-format= --prepend-width= 
--price --price-db= --price-exp= --prices-format= --pricedb-format= -- 
quantity --quarterly --raw --real --register-format= --related -- 
related-all --revalued --revalued-only --revalued-total= --seed= -- 
script= --sort= --sort-all= --sort-xacts= --start-of-week= --strict -- 
subtotal --tail= --total= --total-data --total-width= --trace= -- 
truncate= --unbudgeted --uncleared --unrealized --unrealized-gains= -- 
unrealized-losses= --unround --verbose --verify --version --weekly -- 
wide --yearly" 

    case $prev in 
        --@(cache|file|init-file|output|price-db)) 
            _filedir 
            return 0 
            ;; 
    esac 

    if [[ ${cur} == -* ]] ; then 
        COMPREPLY=( $(compgen -W "${options}" -- ${cur}) ) 
    else 
        COMPREPLY=( $(compgen -W "${commands}" -- ${cur}) ) 
    fi 

    return 0 
} 
complete -F _ledger ledger 

fi
