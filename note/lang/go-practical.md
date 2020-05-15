# practical go

https://dave.cheney.net/practical-go

越看越觉得 go 的 nil 设计很难受

---

- `var s []string` a slice value that is nil
- `var s = []string{}` a slice value that has zero length
- `var s = make([]string, 0)`

受不了，之前看网友聊天，还列举了更多

```go
var s []int
var s = []int{}
var s = make([]int, 0)
var s []int = []int{}
// var s = append(nil, 0)
// var s = append(nil, []int(nil)...)
```

---

> you should prefer declaring methods on *T unless you have a strong reason to do otherwise

```go
type Val struct {
	val int
}

func (v *Val) Get() int {
	return v.val
}

func main() {
	var x Val
	println(x.Get())
}
```


Get 需要的是 *Val，后面用 Val 调用 Get 的时候，会自动取指针。

申明方法的时候不用指针，会导致 struct 被复制，发生零值初始化，结果可能不符合预期。

---

> you can call methods on types that have a nil value

```go
type Val struct {
	val int
}

func (v *Val) Get() int {
	return 1
	// return v.val
}

func main() {
	var this_is_nil *Val
	println(this_is_nil.Get())
}
```

go 里方法只是语法糖
上面这个例子里 `func (v *Val) Get() int` 可以理解成 `func Get(v *Val) int`
只要 Get 里不访问参数 v，调用 Get 就不会报错
要做防御性编程的话，可以在 Get 里做一次检查

---

- A send to a nil channel blocks forever
- A receive from a nil channel blocks forever

读写 nil channel 会 block

```go
var ch chan bool // nil channel
<-ch // blocked
```

- A send to a closed channel panics
- A receive from a closed channel returns the zero value immediately

写 closed channel 会 panic，读 closed channel 会返回 zero value

```go
ch := make(chan bool, 1)
close(ch)
v, ok := <-ch // false, false
```

---

> The common party line is panics, if used, should not leak beyond the API boundary.
> Do not use panic in library code.

应该把 panic 理解成 os.exit(1) 这样的意思

---

> If you assign nil to a pointer the pointer will not point to anything.
> If you assign nil to an interface, the interface will not contain anything.
> If you assign nil to a slice and the slice will have zero len and zero cap and no longer point an underlying array.

> If your method returns an interface type, be sure to always return nil explicitly.
> Assigning nil to a value of a concrete type and returning that will convert it to a typed nil.

总之，nil 太古怪了

在另一个网站看到一句话

> https://www.calhoun.io/when-nil-isnt-equal-to-nil/
> This phenomena is somewhat hard/weird to explain, but no, it is not a bug in
> the language, and no, it isn’t random/magical/whatever else.
> There are some clear rules being applied, we just need to take some time to
> understand them.

我的想法是，行为可以解释、行为有明确规范，并不能说明这个行为是正确、合理的。

practical go 里也说 APIs should be easy to use and hard to misuse。
我觉得 go 本身的设计就不符合这一点。

---

> The Go memory model says that writes to a single machine word will be atomic,
> but interfaces are two word values.

还是 interface 里，type 和 data 分离的问题

---

> Never start a goroutine without knowing how it will stop

老生常谈了

---

> Although make creates generic slice, map, and channel values, they are still
> just regular values; make does not return pointer values.

> new(T) always returns a *T pointing to an initialised T.

`new` 返回 pointer，`make` 返回的是 value 不是 pointer

> the use of new, like the use of named return arguments, is a signal that the
> code is trying to do something clever
> It may be that code really is clever, but more than likely, it can be
> rewritten to be clearer and more idiomatic.

作者不推荐 new

---

> The standard Go idiom, checking the error and iff it is nil is it safe to
> consult the other return values.

（还是一个 optional 就能在类型系统保证的事情

---

介绍了三种错误的定义方式

```go
// sentinel error
var EOF = fmt.Errorf("EOF")

if err == EOF { ... }
```

直接用某个值表示错误
判断时直接看是否相等
例子有 `syscall.ENOENT`

```go
// error type
type EofError struct {
	Msg string
}
func (e *EofError) Error() string {
	return fmt.Sprintf("%s", e.Msg)
}

if err, ok := err.(EofError); ok { ... }
switch err := err.(type) {
	case *EofEofEofError:
		...
}
```

自定义一个结构
判断时可以通过类型转换
例子有 `os.PathError`

```go
// opaque error
func isTimeout(err error) bool {
	type timeout interface {
		Timeout() bool
	}
	te, ok := err.(timeout)
	return ok && te.Timeout()
}
```

最后这一种，不直接暴露错误，而是给出一个函数，让用户做行为判断。

前两类都暴露了实现细节，而最后一种则把错误完全封装在了内部。

---

```go
func ReadFile(path string) ([]byte, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, errors.Wrap(err, "open failed")
	}
	defer f.Close()

	buf, err := ioutil.ReadAll(f)
	if err != nil {
		return nil, errors.Wrap(err, "read failed")
	}
	return buf, nil
}

func ReadConfig() ([]byte, error) {
	home := os.Getenv("HOME")
	config, err := ReadFile(filepath.Join(home, ".settings.xml"))
	return config, errors.Wrap(err, "could not read config")
}

func main() {
	_, err := ReadConfig()
	if err != nil {
		// could not read config: open failed: open /home/xxx/.settings.xml: no such file or directory
		errors.Print(err)
		// readfile.go:27: could not read config
		// readfile.go:14: open failed
		// open /home/xxx/.settings.xml: no such file or directory
		os.Exit(1)
	}
}
```

通过 errors.Wrap 可以获得异常的堆栈

```go
func isTimeout(err error) bool {
	type timeout interface {
		Timeout() bool
	}
	te, ok := errors.Cause(err).(timeout)
	return ok && te.Timeout()
}
```

前面的 opaque error 可以用 errors.Cause 处理

---

```go
func (r *Reader) Read(buf []byte) (int, error)
func (r *Reader) Read() ([]byte, error)
```

> passing a buffer into Read puts the control of the allocations into the
> caller’s hands

作者认为普通接口，都应该采取第二种方式，更清晰易用。

而需要高性能的接口，应该采用第一种方式，由用户自己做内存分配等操作。
在这种基础接口之上，可以再封装针对特定场合的上层接口。

---


