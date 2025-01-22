#!/bin/bash

clear

# Initializing the automata from the file automata.txt
declare -A AUTOMATA
{
    read AUTOMATA["S"]
    read AUTOMATA["Q"]
    read AUTOMATA["Q0"]
    read AUTOMATA["F"]
    read AUTOMATA["T"]
} < automata.txt

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
                if [ $node1 = ${nodes[$((i))]} ] && [ $node2 = ${nodes[$((j))]} ] && [ $lt = "epsilon" ]
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
                    if [ $node1 = $nodeB ] && [ $lt != "epsilon" ]
                    then
                        new_transitions="$new_transitions $nodeA-$lt-$node2"
                    fi
                done
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

function check_word
{
    # This function check if a word is recognized by a DFA
    state=0
    current_node=${AUTOMATA["Q0"]}
    word=$1 ; word_save=$1
    while [ ${#word} -ne 0 ] && [ $state -eq 0 ]
    do
        state=1
        letter="${word:0:1}"
        word="${word:1}"

        for transition in ${AUTOMATA["T"]}
        do
            IFS='-' read -r node1 lt node2 <<< "$transition"
            if [ $node1 = $current_node ] && [ $lt = $letter ]
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
                echo "$word_save is recognized by the Automata."
                return
            fi
        done
        echo "$word_save is not recognized by the Automata."
    else
        echo "$word_save is not recognized by the Automata."
    fi
}

delete_epsilon
display
echo
check_word $1

# chmod +x main.sh