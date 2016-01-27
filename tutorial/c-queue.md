# c queue

---

虽然没有真正的标准库，但还是有 `<sys/queue.h>` 可以用。
至少 `stack` 和 `queue` 不用自己写了。

API 查 `man 3 queue`。

---

## stack / singly-linked list

栈最主要的也就出栈入栈，其他都是链表的特性了。

```c
// 定义
typedef struct stack {
    SLIST_ENTRY(stack) next;
    long val;
} STACK;
typedef SLIST_HEAD(stack_head, stack) STACK_HEAD;

STACK *ptr;

// 初始化
STACK_HEAD head;
SLIST_INIT(&head);

// 入栈
ptr = malloc(sizeof(STACK));
SLIST_INSERT_HEAD(&head, ptr, next);

// 出栈
ptr = SLIST_FIRST(&head);
SLIST_REMOVE_HEAD(&head, next);
free(ptr);

// 是否为空
if (SLIST_EMPTY(&head)) {}

// 遍历
SLIST_FOREACH(ptr, &head, next) {}

// 其他还有
// SLIST_HEAD_INITIALIZER
// SLIST_FOREACH_SAFE
// SLIST_NEXT
// SLIST_INSERT_AFTER
// SLIST_REMOVE
```

可以写个 demo 然后 `cc -E` 看下展开后的代码。
使用的时候还是要知道 STACK 的内部的定义才行，`next` 等还是要自己写的。

---

## queue / singly-linked tail queue

队列主要的方法就是入队出队了，使用上和栈基本是一样的。

```c
// 定义
typedef struct queue {
    STAILQ_ENTRY(queue) next;
    long val;
} QUEUE;
typedef STAILQ_HEAD(stailhead, queue) QUEUE_HEAD;

QUEUE *ptr;

// 初始化
QUEUE_HEAD head;
STAILQ_INIT(&head);

// 入队
ptr = malloc(sizeof(QUEUE));
STAILQ_INSERT_TAIL(&head, ptr, next);

// 出队
ptr = STAILQ_FIRST(&head);
STAILQ_REMOVE_HEAD(&head, next);
free(ptr);
```

本身就是链表，其他方法就不罗列了。
看宏展开后的代码，就会看到是在 head 节点维护了指向末尾的指针，所以能在末尾插入。

---

```
typedef struct stack {
    SLIST_ENTRY(stack) next;
    long val;
} STACK;

// 展开后是

typedef struct stack {
    struct { struct stack *sle_next; } next;
    long val;
} STACK;
```

这里没有直接使用指针指向下一个元素，而是用了一个结构体，结构体里放指针。
不知道除了统一变量名，还有其他意图没有。

另外，展开的代码里有大量的 `do { ... } while (0)` 这种形式的代码。
看起来毫无意义，网上搜到的解释是

> The reason for the do{}while(0) dodge in multi-statement macro expansions
> is to make them work right in contexts where just one statement is allowed.

当年写 C 的时候还是学得太浅……
