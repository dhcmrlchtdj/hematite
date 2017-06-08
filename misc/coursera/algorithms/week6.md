hash
- key-indexed table
- compute array index from key by hash function
- collision resolution: handle two keys that hash to the same index
- space-time tradeoff

collision
- separate chainning
    - keep M ~ N/5
- open addressing
    - keep M ~ N/2

hash vs BST
- hash
    - simpler to code
    - faster for simple keys
- BST
    - stronger performance guarantee
    - support for ordered ST operations
    - easier to implement `compare` correctly than `hash_code`
