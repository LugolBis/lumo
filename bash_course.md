# Bash - Course

## Data Structures

### Scalar | String

- Declaration :
  ```Bash
  lulu="Hello world!"
  ```
- Usage :
  ```Bash
  lulu+=Jean     # Add "Jean" to lulu
  echo $lulu     # Display : Hello world!Jean
  echo "$lulu"   # Display : Hello world!Jean
  ```
  ```Bash
  echo '$lulu'   # Display : $lulu
  ```
  ```Bash
  current_date=`date`  # Store the current date in a variable
  echo `ls -lh`        # Execute the command 'ls -lh'
  ```            
- Length :
  ```Bash
  length=${#lulu}
  ```
- Find an occurrence :
  ```Bash
  result=$(echo "$lulu" | grep -o "pattern")
  ```
  or
  ```Bash
  if [[ $variable == *"$element"* ]]; then
    result="The element is present in the variable."
  else 
    result="The element is not present in the variable."
  fi
  ```
- Slice :
  ```Bash
  lulu="Hello World!"
  echo "${lulu:3}"              # Displays : lo World!
  ```
  ```Bash
  lulu="Hello World!"
  echo "${lulu:0:${#lulu}-2}"   # Displays : Hello Worl
  ```
- Replace :
  ```Bash
  lulu="Hello World!"
  lulu="${lulu//Hello/Bonjourno}"
  echo "$lulu"
  ```
  
### Int

- Declaration :
  ```Bash
  lulu=$((42))
  ```
  or
  ```Bash
  let "lulu=5"
  ```
  or
  ```Bash
  declare -i lulu
  lulu="42"
  ```
- Usage :
  ```Bash
  lulu=$(($lulu+1)) # Add 1 to lulu
  echo $lulu
  ```
  
### Float

- Declaration :
  ```Bash
  precision=3  # precision after the decimal point
  nb1=$((5))
  nb2=$((3))
  lulu=$(echo "scale=$precision; $nb1/$nb2" | bc)
  ```
  
### Array

- Declaration :
  ```Bash
  array=("apple" "banana" "cherry")
  ```
- Add an element :
  ```Bash
  array+=("orange")
  ```
- Usage :
  ```Bash
  echo ${array[1]} # Displays: banana
  ```
- Iterate on it :
  ```Bash
  for fruit in "${array[@]}"; do
    echo $fruit
  done
  ```
  
### Dictionary | Hashmap

- Declaration :
  ```Bash
  declare -A dico
  ```
- Add an element :
  ```Bash
  dico["France"]="Paris"
  ```
- Usage :
  ```Bash
  echo ${dico["France"]} # Displays: Paris
  ```
- Iterate on it :
  ```Bash
  for country in "${!dico[@]}"; do
    echo "The capital of $country is ${dico[$country]}"
  done
  ```

## Comparisons Operators
> [!Warning]
> These comparisons are used in [conditions](https://github.com/LugolBis/lumo/edit/main/bash_course.md#conditions), to store the result you can do this :
> ```Bash
> c=$([[ $a -eq $b ]] && echo "true" || echo "false")
> ```
### Scalar | String
- Equal :
  ```Bash
  $a = $b
  ```
- Different :
  ```Bash
  $a != $b
  ```
- Empty :
  ```Bash
  -z $a
  ```
- Not Empty :
  ```Bash
  -n $a
  ```
### Int
- Equal :
  ```Bash
  $a -eq $b
  ```
- Different :
  ```Bash
  $a -ne $b
  ```
- Lower than :
  ```Bash
  $a -lt $b
  ```
- Lower or Equal :
  ```Bash
  $a -le $b
  ```
- Greater than :
  ```Bash
  $a -gt $b
  ```
- Greater or Equal :
  ```Bash
  $a -ge $b
  ```

## Conditions
```Bash
lulu=$((88))
if [ $lulu -lt $((50)) ]
then
  echo Lower than 50
elif [ $(($lulu%2)) -eq 1 ]
then
  echo Greater than 50 and odd
else
  echo Greater than 50 and peer
fi
```
<br>

You can use logic operators
```Bash
lulu=$((5))
if [ $lulu -gt $((50)) ] && ! [[ $(($lulu%2)) -eq 1 ]]
then
  echo Greater than 50 and peer
else
  echo Lower than 50 or odd
fi
```
```Bash
lulu=$((88))
if [ $lulu -eq 50 ] || [ -z $lulu ]
then
  echo Lulu is empty or equal to 50
fi
```
<br>

Case-block
```Bash
case $# in
  2)
    name=$1
    age=$2
    ;;
  *)
    echo "Usage : ./main.sh <Name> <Age>"
    exit
    ;;
esac
echo $name is $age years old
```
<br>

```Bash
# Script to check the existence of a file

dir="$PWD/data"
if [ -e "$dir" ]; then
  echo "There is a file or folder named 'data'"
else
  echo "There isn't a file or folder named 'data'"
fi
```

## Loop
- While
  ```Bash
  lulu=10
  while [ $lulu -ge 0 ]
  do
    echo $lulu
    lulu=$(($lulu-1))
  done
  echo Happy new year !
  ```
- For <variable> in <iterable>
  ```Bash
  names=("Jean" "Bruno" "Hugo" "François")
  for name in "${names[@]}"
  do
      echo "Hello $name"
  done
  ```
- For index in <sequence>
  ```Bash
  for i in `seq 0 10`    # start:0 ; end:10 
  do
      echo Day $i
  done
  ```
  ```Bash
  for i in `seq 0 2 10`   # start:0 ; step:2 ; end:10 
  do
      echo Day $i
  done
  ```

## Function
> [!Caution]
> In Bash, functions have no side effects, changes to a variable in the body of a function
> directly affect the scope in which the function was called.
> ```Bash
> function ADD
> {
>   a=$((a+1))
> }
> a=5
> echo $a  # Displays : 5
> ADD      # Call the function 'ADD'
> echo $a  # Displays : 6
> ```
<br>

Function with arguments
```Bash
function add_numbers
{
  result=$(($1+$2))
}
add_numbers 5 2
echo $result  # Displays : 7
```

## I/O

### Read prompt data
```Bash
# To interact with the user directly in the terminal

read -p "What's your name ? " name
read -p "How old are you ? " age
echo $name : $age
```

### Setting up the script at launch
```Bash
echo $#    # Displays the number of parameters
```
main.sh :
```Bash
echo $1 is $2 years old
```
In your terminal execute :
```Bash
./main.sh Lulu 90
```
The previous command displays : Lulu is 90 years old

### Standard input redirection | Files
- File as input
  data.txt :
  ```Txt
  Lulu
  90
  ```
  main.sh :
  ```Bash
  echo $1 is $2 years old
  ```
  In your terminal execute :
  ```Bash
  ./main.sh < data.txt
  ```
  The previous command displays : Lulu is 90 years old
- File as output
  In your terminal execute :
  ```Bash
  echo Lulu is everywhere... > output.txt
  ```
