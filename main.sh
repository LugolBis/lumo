#!/bin/bash

clear

function display
{
    echo Alphabet : ${AUTOMATA["S"]}
    echo States : ${AUTOMATA["Q"]}
    echo Initial state : ${AUTOMATA["Q0"]}
    echo Finals state : ${AUTOMATA["F"]}
    echo Transitions : ${AUTOMATA["T"]} 
}

function delete_epsilon
{
    IFS=" " read -ra nodes <<< ${AUTOMATA["Q"]}
    N=$(($(echo "${AUTOMATA["Q"]}" | grep -o " " | wc -l)+1))

    # Initializing a matrix of the epsilon path
    matrix=()
    for ((i=0; i<N*N; i++)); do
        matrix[i]="0"
    done

    for ((i=0; i<N; i++)); do
        for ((j=0; j<N; j++)); do
            for transition in ${AUTOMATA["T"]}
            do
                IFS='-' read -r node1 lt node2 <<< "$transition"
                if [ "$node1" = "${nodes[$((i))]}" ] && [ "$node2" = "${nodes[$((j))]}" ] && [ "$lt" = "epsilon" ]
                then
                    matrix[$(( $i * $N + $j ))]="1"
                    break
                fi
            done
        done
    done

    # Find all the epsilon path
    for ((i=0; i<N; i++)); do
        for ((j=0; j<N; j++)); do
            for ((k=0; k<N; k++)); do
                if [ ${matrix[$(($k * $N + $j))]} = "1" ] && [ ${matrix[$(($i * $N + $k))]} = "1" ]
                then
                    matrix[$(($i * $N + $j))]="1"
                fi
            done
        done
    done

    local new_transitions=""
    for ((i=0; i<N; i++)); do
        for ((j=0; j<N; j++)); do
            if [ ${matrix[$(($i * $N + $j))]} = "1" ] && [ $i != $j ]
            then
                nodeA=${nodes[$i]}
                nodeB=${nodes[$j]}
                for transition in ${AUTOMATA["T"]}; do
                    IFS='-' read -r node1 lt node2 <<< "$transition"
                    if [ "$node1" = "$nodeB" ] && [ "$lt" != "epsilon" ]
                    then
                        new_transitions="$new_transitions $nodeA-$lt-$node2"
                    fi
                done
                if [ $(($(echo ${AUTOMATA["F"]} | egrep -o "$nodeB" | wc -l))) -gt 0 ] && [ $(($(echo ${AUTOMATA["F"]} | egrep -o "$nodeA" | wc -l))) -eq 0 ]; then
                    AUTOMATA["F"]="${AUTOMATA["F"]} $nodeA"
                fi
            fi
        done
    done
    
    for transition in ${AUTOMATA["T"]}; do
        IFS='-' read -r node1 lt node2 <<< "$transition"
        if [ $lt != "epsilon" ]
        then
            new_transitions="$new_transitions $node1-$lt-$node2"
        fi
    done

    AUTOMATA["T"]=$new_transitions
}

function determine
{
    alphabet=()
    for letter in ${AUTOMATA["S"]}; do
        if [ $(($(echo ${AUTOMATA["T"]} | egrep -o "\-$letter\-" | wc -l))) -gt 0 ]; then
            alphabet+=($letter)
        fi
    done

    # Initializing the successor of each node by each letter
    declare -A successor
    for node in ${AUTOMATA["Q"]}; do
        for letter in ${alphabet[*]}; do
            successor["$node-$letter"]=""
        done
    done
    for transition in ${AUTOMATA["T"]}; do
        IFS='-' read -r node1 lt node2 <<< "$transition"
        successor["$node1-$lt"]="${successor["$node1-$lt"]} $node2"
    done
    
    Q_=${AUTOMATA["Q0"]} ; F_=${AUTOMATA["F"]} ; T_=""
    IFS=" " read -ra stack <<< $Q_
    while [ $((${#stack})) -gt 0 ]; do
        for node in $stack; do
            for letter in ${alphabet[*]}; do
                currentS=""
                IFS=";" read -ra distinctN <<< $node
                for n in ${distinctN[*]}; do
                    IFS=" " read -ra distinctS <<< ${successor["$n-$letter"]}
                    for s in ${distinctS[*]}; do
                        if [ $(($(echo $currentS | egrep -o "$s" | wc -l))) -eq 0 ]; then
                            currentS="$currentS $s"
                        fi
                    done
                done
                new_node=$(echo "${currentS:1}" | tr ' ' ';')
                if [ "$new_node" != "" ]; then
                    T_="$T_ $node-$letter-$new_node"
                fi
                if [[ ! "$Q_" =~ (^| )"$new_node"( |$) ]]; then
                    Q_="$Q_ $new_node"
                    stack+=($new_node)
                fi
                for n__ in ${distinctN[*]}; do
                    if [ $(($(echo $F_ | egrep -o "$n__" | wc -l))) -gt 0 ] && [ $(($(echo $F_ | egrep -o "$node" | wc -l))) -eq 0 ]; then
                        F_="$F_ $node"
                        break
                    fi
                    
                done
            done
            stack=("${stack[@]:1}")
            break
        done
    done

    AUTOMATA["Q"]=$Q_
    AUTOMATA["F"]=$F_
    AUTOMATA["T"]=$T_
}

function complete
{
    # This function complete the automata
    for state in ${AUTOMATA["Q"]}; do
        for letter in ${AUTOMATA["S"]}; do
            if [ $(($(echo ${AUTOMATA["T"]} | egrep -o "$state-$letter-" | wc -l))) -eq 0 ]; then
                AUTOMATA["T"]="${AUTOMATA["T"]} $state-$letter-TRASH"
            fi
        done
    done
}

function union
{
    # This function realizes the union of two automata
    declare -A AUTOMATA2
    {
        read AUTOMATA2["S"]
        read AUTOMATA2["Q"]
        read AUTOMATA2["Q0"]
        read AUTOMATA2["F"]
        read AUTOMATA2["T"]
    } < $union

    AUTOMATA["S"]="${AUTOMATA["S"]} ${AUTOMATA2["S"]}"

    for state in ${AUTOMATA2["Q"]}; do
        if [[ ${AUTOMATA["Q"]} =~ (^|[[:space:]])"$state"([[:space:]]|$) ]]; then
            new_state="${state}2"
            while [[ ${AUTOMATA["Q"]} =~ (^|[[:space:]])"${new_state}"([[:space:]]|$) ]]; do
                new_state="${state}2"
            done
            AUTOMATA2["Q"]=`echo ${AUTOMATA2["Q"]} | sed "s/$state/$new_state/"`
            AUTOMATA2["Q0"]=`echo ${AUTOMATA2["Q0"]} | sed "s/$state/$new_state/"`
            AUTOMATA2["F"]=`echo ${AUTOMATA2["F"]} | sed "s/$state/$new_state/"`
            while [[ ${AUTOMATA2["T"]} =~ (^|-)"${state}"(-|$) ]]; do
                AUTOMATA2["T"]=`echo ${AUTOMATA2["T"]} | sed "s/$state/$new_state/"`
            done
        fi
    done
    
    AUTOMATA["S"]="${AUTOMATA["S"]} ${AUTOMATA2["S"]}"
    AUTOMATA["Q"]="${AUTOMATA["Q"]} ${AUTOMATA2["Q"]}"
    AUTOMATA["F"]="${AUTOMATA["F"]} ${AUTOMATA2["F"]}"
    AUTOMATA["T"]="${AUTOMATA["T"]} ${AUTOMATA2["T"]}"

    new_state="${AUTOMATA["Q0"]}0"
    while [[ ${AUTOMATA["Q"]} =~ (^|[[:space:]])"${new_state}"([[:space:]]|$) ]]; do
        new_state="${AUTOMATA["Q0"]}0"
    done
    AUTOMATA["T"]="${AUTOMATA["T"]} $new_state-epsilon-${AUTOMATA["Q0"]} $new_state-epsilon-${AUTOMATA2["Q0"]}"
    AUTOMATA["Q"]="$new_state ${AUTOMATA["Q"]}"
    AUTOMATA["Q0"]="$new_state"
}

function complementary
{
    # This function realize the complementary of the automata
    old_finals=${AUTOMATA["F"]}
    F_=""
    for state in ${AUTOMATA["Q"]}; do
        if [[ ! "$old_finals" =~ (^| )"$state"( |$) ]]; then
            F_="$F_ $state"
        fi
    done
    AUTOMATA["F"]="$F_"
}

function check_word
{
    # This function check if a word is recognized by a DFA
    state=0
    current_node=${AUTOMATA["Q0"]}
    word=$1
    while [ ${#word} -ne 0 ] && [ $state -eq 0 ]
    do
        state=1
        letter="${word:0:1}"
        word="${word:1}"

        for transition in ${AUTOMATA["T"]}
        do
            IFS='-' read -r node1 lt node2 <<< "$transition"
            if [ "$node1" = "$current_node" ] && [ "$lt" = "$letter" ]
            then
                current_node=$node2
                state=0
                break
            fi
        done
    done

    if [ ${#word} -eq 0 ]
    then
        for node in ${AUTOMATA["F"]}
        do
            if [ $current_node = $node ]
            then
                echo "The word '$w' is recognized by the Automata."
                return
            fi
        done
        echo "The word '$w' is not recognized by the Automata."
    else
        echo "The word '$w' is not recognized by the Automata."
    fi
}

function save
{
    # Save the automata to a file
    display > $1
}

function run 
{
    if [ "$w" = "--help" ] || [ "$w" = "-help" ]; then
        CYAN="\e[36m" ; MAGENTA="\e[35m" ; YELLOW="\e[33m" ; GREEN="\e[32m" # Text colors
        RESET="\e[0m" # To reset the colors
        echo -e "Usage : lumo ${CYAN}<YOUR_WORD> ${MAGENTA}<AUTOMATA_PATH> ${CYAN}<SAVE_PATH>${RESET}"
        echo
        echo "Flags usage :"
        echo -e "${CYAN}-w      ${RESET}:   ${CYAN}Take in argument the word you want to recognize with the automata${RESET}."
        echo -e "${MAGENTA}-in     ${RESET}:   ${MAGENTA}Take in argument the path of the file that contains an automata${RESET}."
        echo -e "${CYAN}-out    ${RESET}:   ${CYAN}Take in argument the path to save the finite deterministic and complete automata${RESET}."
        echo -e "${MAGENTA}-union  ${RESET}:   ${MAGENTA}Take in argument the path of the file that contains the automata that you want to union with the automata from the flag -in${RESET}."
        echo -e "${CYAN}-comp   ${RESET}:   ${CYAN}Take nothing in argument, this flag realize the complementary of the automata${RESET}."
        echo
        echo -e "${YELLOW}Note${RESET} : The order of the execution of the functions is"
        echo -e "${YELLOW}->${RESET} Init automata from ${MAGENTA}-in${RESET} -> delete epsilon transitions -> determine."
        echo -e "(${YELLOW}Optional${RESET}) ${YELLOW}->${RESET} Realize the union from ${MAGENTA}-union${RESET} -> delete epsilon transitions -> determine."
        echo -e "(${YELLOW}Optional${RESET}) ${YELLOW}->${RESET} Realize the complementary from ${CYAN}-comp${RESET}."
        echo -e "${YELLOW}->${RESET} Complete the automata."
        echo -e "${YELLOW}->${RESET} Displays the automata or save it in the file from ${CYAN}-out${RESET}."
        echo -e "${YELLOW}->${RESET} Check if the word from ${CYAN}-w${RESET} is recognized by the automata."
        echo
        echo -e "For more ${YELLOW}informations${RESET} you can consult the repository on ${GREEN}Github${RESET} :"
        echo -e "https://github.com/LugolBis/lumo#lumo"
        echo
        exit 0
    fi

    if [ "$in" = "" ]; then
        in="automata.txt"
    fi

    declare -A AUTOMATA
    {
        read AUTOMATA["S"]
        read AUTOMATA["Q"]
        read AUTOMATA["Q0"]
        read AUTOMATA["F"]
        read AUTOMATA["T"]
    } < $in

    delete_epsilon
    determine
    
    if [ "$union" != "" ]; then
        union $union
        delete_epsilon
        determine
    fi

    if [ "$comp" = "YES" ]; then
        complementary
    fi

    complete

    if [ "$out" != "" ]; then
        save $out
        echo "The automata was successfully saved in : $out"
    else
        display
    fi

    echo
    check_word $w
}

function parse_args()
{
    # Parse inputs args

    w=""
    in=""
    out=""
    lifo=""
    union=""
    comp="NO"

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -w)
                w="$2"
                shift 2
                ;;
            -in)
                in="$2"
                shift 2
                ;;
            -out)
                out="$2"
                shift 2
                ;;
            -lifo)
                lifo="$2"
                shift 2
                ;;
            -union)
                union="$2"
                shift 2
                ;;
            -comp)
                comp="YES"
                shift 1
                ;;
            -w=*)
                w="${1#*=}"
                shift
                ;;
            -in=*)
                in="${1#*=}"
                shift
                ;;
            -out=*)
                out="${1#*=}"
                shift
                ;;
            -lifo=*)
                lifo="${1#*=}"
                shift
                ;;
            -union=*)
                union="${1#*=}"
                shift
                ;;
            -comp=*)
                comp="YES"
                shift
                ;;
            *)
                if [[ -z "$w" ]]; then
                    w="$1"
                elif [[ -z "$in" ]]; then
                    in="$1"
                elif [[ -z "$out" ]]; then
                    out="$1"
                elif [[ -z "$lifo" ]]; then
                    lifo="$1"
                elif [[ -z "$union" ]]; then
                    union="$1"
                elif [[ -z "$comp" ]]; then
                    comp="YES"
                fi
                shift
                ;;
        esac
    done

}

parse_args "$@"
run

# chmod +x main.sh