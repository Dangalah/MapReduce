#!/usr/bin/env python3

import sys

def punct(word: str) -> str:
    return "".join([letter for letter in word if word.isalpha()])
    
def lenght(word: str) -> bool:
    if len(word) < 6 or len(word) > 9:
        return False
    return word.istitle()
    
if __name__=="__main__":
    
    for line in sys.stdin:
        line = line.strip()
        words = line.split()
        
        for word in words:
            wword = punct(word)
            if not wword:
                continue
            res = int(lenght(wword))
            print("\t".join([wword.lower(), str(res)]))
