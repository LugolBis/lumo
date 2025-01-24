# lumo
## Project Objective :
The objective of this **personal** project is to implement **Deterministic finite automaton** (**DFA**) in ```Bash Script```.
<br>
This data structure from programming language theory makes it possible to determine whether a word belongs to a language.

## Local Usage :
Clone the repository (or download it) :
```Bash
git clone https://github.com/LugolBis/lumo.git
```
Open your terminal in the folder lumo.
<br>
Execute the following command to configure the command ```lumo``` :
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
> - Epsilon transitions are reprsesented as the following example : q0-epsilon-q1
> - The states formed from several states are formalized as follows : {q0} U {q1} -> q0;q1

## Requirements
| OS | Shell | Compatibility |
|:-:|:-:|:-:|
| Type Unix<br>(Linux/MacOS) | Bash | ✅ |
| ~ | ~ | ❌ |
