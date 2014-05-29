_module() {
	local cur prev opts
	commands="add load rm unload swap display show avail use unuse update refresh purge list clear help whatis apropos keyword initadd initprepend initrm initswitch initlist initclear" # Removed switch from the list to complete swap sooner
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	prevprev=dummy
	if [[ $COMP_CWORD -ge 2 ]]
	then
		prevprev="${COMP_WORDS[COMP_CWORD-2]}"
	fi

	if [[ $prev =~ add|load|display|show|avail|help|whatis|initadd|initprepend|initswitch ]] \
		|| [[ "$prevprev" =~ switch|swap|initswitch ]];
	then
		COMPREPLY=( $(compgen -W "$(module avail -t 2>&1| tr "\n" " ") \
			$( module avail -t 2>&1| cut -d/ -f1 | uniq) " -- $cur) )
		return 0
	elif [[ $prev == module ]]
	then
		COMPREPLY=( $(compgen -W "$commands" -- $cur) )
		return 0
	elif [[ $prev =~ rm|unload|initrm|swap|switch ]] 
	then
		COMPREPLY=( $(compgen -W "$(module list -t 2>&1| tr "\n" " ") \
			 $( module list -t 2>&1| cut -d/ -f1 | uniq)" -- $cur) )
		return 0
	fi
}

complete -F _module module
