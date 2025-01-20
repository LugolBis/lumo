# Bash - Course

## Data Structures
### Scalar | String
- Declaration :
  ```Bash
  lulu="Hello world!"
  ```
- Usage :
  ```Bash
  lulu+=Jean # Add "Jean" to lulu
  echo $lulu
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
### Int
- Declaration :
  ```Bash
  lulu=$((42))
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
