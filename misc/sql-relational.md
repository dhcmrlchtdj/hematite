# relational algebra

- SQL is based on the relational calculus
- SQL implementation is based on relational algebra

- relational algebra
    - selection `Select(pred, R1)`
    - projection `Proj(column, R1)`
    - cartesian production `Prod(R1 X R2)`
    - rename `Rename(a->b, R1)`
    - union `Union(R1, R2)`
    - minus `Minus(R1, R2)`
        - `Union(R1, R2) = Minus(R1, (Minus(R1, R2)))`
- 从上面可以推出
    - join `Join(R1, R2) = Select(R1.id=R2.id, Prod(R1, R2))`
        - natural join
        - left outer join
        - right outer join
        - (full) outer join
        - left semi join
        - right semi join
