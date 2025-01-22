#!/bin/bash

clear

# Initializing the automata from the file automata.txt
declare -A AUTOMATE
{
    read AUTOMATE["S"]
    read AUTOMATE["Q"]
    read AUTOMATE["Q0"]
    read AUTOMATE["F"]
    read AUTOMATE["T"]
} < automata.txt

function display
{
    echo ${AUTOMATE["S"]}
    echo ${AUTOMATE["Q"]}
    echo ${AUTOMATE["Q0"]}
    echo ${AUTOMATE["F"]}
    echo ${AUTOMATE["T"]} 
}

function delete_epsilon
{
    IFS=" " read -ra nodes <<< ${AUTOMATE["Q"]}
    N=$(($(echo "${AUTOMATE["Q"]}" | grep -o " " | wc -l)+1))

    # Initializing a matrix of the epsilon path
    matrix=()
    for ((i=0; i<N*N; i++)); do
        matrix[i]="0"
    done

    for ((i=0; i<N; i++)); do
        for ((j=0; j<N; j++)); do
            for transition in ${AUTOMATE["T"]}
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
    for i in `seq 0 $((N-1))`
    do
        for j in `seq 0 $((N-1))`
        do
            for k in `seq 0 $((N-1))`
            do
                if [ ${matrix[$(($k * $N + $j))]} = "1" ] && [ ${matrix[$(($i * $N + $k))]} = "1" ]
                then
                    matrix[$(($i * $N + $j))]="1"
                fi
            done
        done
    done

    for i in `seq 0 $((N-1))`
    do
        echo ${nodes[$(($i))]}
    done

    # Not complete
}

function check_word
{
    # This function check if a word is recognized by a DFA
    state=0
    current_node=${AUTOMATE["Q0"]}
    word=$1 ; word_save=$1
    while [ ${#word} -ne 0 ] && [ $state -eq 0 ]
    do
        state=1
        letter="${word:0:1}"
        word="${word:1}"

        for transition in ${AUTOMATE["T"]}
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
        for node in ${AUTOMATE["F"]}
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

check_word $1

# chmod +x main.sh