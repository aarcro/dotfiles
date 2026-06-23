#!/usr/bin/env bash

# $1 is the current search query passed from fzf
query="$1"

# Strip git symbols and remove empty lines, then run awk
sed -E 's/^[* ]+//' | grep -v '^$' | awk -v q="$query" '
  BEGIN { count = 0 }
  {
    count++
    if (count == 1) { first = $0 }
    last = $0
  } 
  END {
    # If the fzf list is totally empty, return the query untouched
    if (count == 0) { print q; exit }
    
    # If there is exactly one match left, autocomplete it fully
    if (count == 1) { print first; exit }
    
    # Calculate the longest common prefix
    for (i=1; i<=length(first); i++) {
      if (substr(first,i,1) != substr(last,i,1)) break
    }
    
    prefix = substr(first,1,i-1)
    
    # Return the prefix, or the original query if no common prefix exists
    print (prefix != "" ? prefix : q)
  }
'

