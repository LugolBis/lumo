# lumo
## Project Objective :
The objective of this **personal** project is to develop an application allowing the users to manipulate **Deterministic finite automaton** (**DFA**) on their terminal.
<br>
This data structure from programming language theory makes it possible to determine whether a word belongs to a language.

## Configure :
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
## Formats :
> [!Important]
> - The file containing the automata must be formatted as follows :
>   <br>Line 1 : The letters of the alphabet, separated from each other by a space.
>   <br>Line 2 : The states of the automata, separated from each other by a space.
>   <br>Line 3 : The initial state.
>   <br>Line 4 : The finals states, separated from each other by a space.
>   <br>Line 5 : The transitions, separated from each other by a space.
>   <br>Exemple of the format of a transition : q0-a-q1
> - Epsilon transitions are reprsesented as the following example : q0-epsilon-q1
> - The states formed from several states are formalized as follows : {q0} U {q1} -> q0;q1

## How to use :
### Flags usage :
- **-w**     : Take in argument the word you want to recognize with the automata.
- **-in**    : Take in argument the path of the file that contains an automata.
- **-out**   : Take in argument the path to save the finite deterministic and complete automata.
- **-union** : Take in argument the path of the file that contains the automata that you want to union with the automata from the flag -in.
- **-comp**  : Take nothing in argument, this flag realize the complementary of the automata.
### Examples :
- To check if a *abc* is recognized by the automata contained in *path/to/file.txt* you can do that :
  ```Bash
  lumo abc path/to/file.txt
  ```
  or
  ```Bash
  lumo -in path/to/file.txt -w abc
  ```
> [!WARNING]
> If you want to test with the epsilon word you can do that :
> ```Bash
> lumo -w "" -in path/to/file.txt
> ```
- To save the new automata from the *file1* to the *file2* you can do that :
  ```Bash
  lumo "" file1 file2
  ```
  or
  ```Bash
  lumo "" -in file1 -out file2
  ```
- To realize the union of A1 U A2 you can do that :
  ```Bash
  lumo "" -in A1.txt -union A2.txt -out union.txt
  ```
- To realize the complementary of the automata :
  ```Bash
  lumo "" -comp
  ```

## Requirements
| OS | Shell | Compatibility |
|:-:|:-:|:-:|
| Type Unix<br>(Linux/MacOS) | Bash | ✅ |
| ~ | ~ | ❌ |
