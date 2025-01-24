# lumo
## Project Objective :
The objective of this **personal** project is to implement **Deterministic finite automaton** (**DFA**) in ```Bash Script```.

## Local Usage :
Clone the repository :
```Bash
git clone https://github.com/LugolBis/lumo.git
```
Configure the command ```lumo``` :
```Bash
make config
```
> [!Important]
> - Usage in your terminal :
>   ```Bash
>   lumo YOUR_WORD AUTOMATA_PATH
>   ```
>   The second argument ```AUTOMATA_PATH``` is optional.
>   
> - The .txt file containing the automata must be formatted as follows :
>   <br>Line 1 : The letters of the alphabet, separated from each other by a space.
>   <br>Line 2 : The states of the automata, separated from each other by a space.
>   <br>Line 3 : The initial state.
>   <br>Line 4 : The finals states, separated from each other by a space.
>   <br>Line 5 : The transitions, separated from each other by a space.
>   <br>Exemple of the format of a transition : q0-a-q1

> [!Caution]
> The spaces before the line break in your .txt file that contain your automata may not work well.
