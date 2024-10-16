#import "@preview/touying:0.5.2": *
#import themes.dewdrop: *
#set text(font: "LXGW WenKai Mono")

#import "@preview/numbly:0.1.0": numbly
#show: dewdrop-theme.with(
  aspect-ratio: "16-9",
  footer: self => (
    self.info.title + self.info.subtitle + " - " + self.info.author + " - " + self.info.date
  ),
  navigation: "none",
  config-info(
    title: [2024秋冬季操作系统训练营],
    subtitle: [算法阶段 - Rust编程],
    author: [温祖彤],
    date: [2024年10月16日],
  ),
  config-common(new-section-slide-fn: none),
)

// define a function of 2-column

#let auto-two-column(
  body1,
  body2,
  fontsize: 16pt,
) = {
  set text(size: fontsize)
  return columns[
    #body1
    #colbreak()
    #body2
  ]
}

#let auto-one-column(
  body1,
  fontsize: 16pt,
) = {
  set text(size: fontsize)
  return columns[
    #body1
    #[]
  ]
}

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()


= 本节课程内容

- 栈的实现
- 队列的实现
- 数据结构与标准库对比
- 测试编写
- 环形队列的实现


= 栈
栈是一个仅能在尾部插入或删除的线性表


#figure(
  image("stack.gif", height:70%),
  caption: text("栈的动画图解"),
)
---
栈的数据部分就是一个数组，可以自行分配，也可以使用Rust中的动态数组进行提供

为了简单起见，先写一个整数(`i32`)类型的栈。

#auto-two-column(
  [```rust
#[derive(Debug)]
struct Stack<const N: usize> {
    data: [i32; N],
    top: usize,
}
```],[```rust
impl<const N: usize> Stack<N> {
    fn new() -> Self {
        Self {
            data: [0; N],
            top: 0,
        }
    }
}
```]
)



新建一个栈一般都是空的，以只需要编写一个new函数即可

---



#auto-two-column([
  接下来是栈的两个最基本的操作

  入栈和出栈
  ```rs
  impl<const N: usize> Stack<N> {
    fn push(&mut self, item: i32) {
        self.data[self.top] = item;
        self.top += 1;
    }
    fn pop(&mut self) -> i32 {
        self.top -= 1;
        Ok(self.data[self.top])
    }
}
```
],[
  测试代码：能看出这个`main`函数有什么问题吗？
  ```rs
  fn main() {
    let mut stack = Stack::<10>::new();
    for i in 0..10 {
        stack.push(i);
    }
    for _ in 0..10 {
        println!("{}", stack.pop());
    }
}
```
])

---
如果用户写出了这样的代码
```rust
fn main() {
    let mut stack = Stack::<10>::new();
    for i in 0..20 {
        stack.push(i);
    }
    for _ in 0..20 {
        println!("{}", stack.pop());
    }
}
```

对错误没有任何有效的处理，包括上溢出/下溢出，导致程序崩溃。


---
== 加入错误处理
#[
  #set text(size: 17pt)
  ```rs
impl<const N: usize> Stack<N> {
    fn push(&mut self, item: i32) -> Result<(), &'static str> {
        if self.top == N {
            return Err("Stack is full");
        }
        self.data[self.top] = item;
        self.top += 1;
        Ok(())
    }
    fn pop(&mut self) -> Result<i32, &'static str> {
        if self.top == 0 {
            Err("Stack is empty")
        } else {
            self.top -= 1;
            Ok(self.data[self.top])
        }
    }
}
```
]

== 泛型

刚刚只实现了整数类型，而实际的栈中可能存储的是不同类型的数据，比如字符串、浮点数等。为了支持不同类型的数据，我们可以使用泛型来定义栈。
#[
  #set text(size: 18pt)
```rs
#[derive(Debug)]
struct Stack<T, const N: usize> {
    data: [T; N],
    top: usize,
}
impl<T: Default, const N: usize> Stack<T, N> {
    fn new() -> Self {
        Self {
            data: std::array::from_fn(|_i| T::default()),
            top: 0,
        }
    }


    fn push(&mut self, item: T) -> Result<(), &'static str> {
        if self.top == N {
            return Err("Stack is full");
        }
        self.data[self.top] = item;
        self.top += 1;
        Ok(())
    }
    fn pop(&mut self) -> Result<T, &'static str> {
        if self.top == 0 {
            Err("Stack is empty")
        } else {
            self.top -= 1;
            let mut k = T::default();
            std::mem::swap(&mut k, &mut self.data[self.top]);
            Ok(k)
        }
    }
}
```
]

= 队列
队列是一个仅能在尾部插入或头部删除的线性表
#figure(
  image("queue.gif", height:70%),
  caption: text("队列的动画图解"),
)


---
队列和栈的区别就是删除的方向不同，栈是后进先出，队列是先进先出。栈会选取尾部作为删除方向，队列会选取头部作为删除方向。所以需要一个额外的变量来指示队头。

#[
  #set text(size: 17pt)
```rust
#[derive(Debug)]
struct Queue<T, const N: usize> {
    data: [T; N],
    bottom: usize,
    top: usize,
}
impl<T: Default, const N: usize> Queue<T, N> {
    fn new() -> Self {
        Self {
            data: std::array::from_fn(|_i| T::default()),
            top: 0,
            bottom: 0,
        }
    }

    fn push(&mut self, item: T) -> Result<(), &'static str> {
        if self.top == N {
            return Err("Queue is full");
        }
        self.data[self.top] = item;
        self.top += 1;
        Ok(())
    }
    fn pop(&mut self) -> Result<T, &'static str> {
        if self.top == self.bottom {
            Err("Queue is empty")
        } else {
            let mut k = T::default();
            std::mem::swap(&mut k, &mut self.data[self.bottom]);
            self.bottom += 1;
            Ok(k)
        }
    }
}
```
]

---
队列的长度并非栈一样显而易见。所以最好编写一个函数来获取队列的长度。

```rust
impl<T> Stack<T, const N: usize> {
    pub fn len(&self) -> usize {
        self.top - self.bottom
    }
}
```

---
== 队列的简单测试
```rust
mod test {
    use super::*;
    #[test]
    fn check_queue() {
        let mut a = Queue::<i32, 3>::new();
        assert_eq!(a.push(1), Ok(()));
        assert_eq!(a.push(2), Ok(()));
        assert_eq!(a.push(3), Ok(()));
        assert_eq!(a.push(4), Err("Queue is full"));
        assert_eq!(a.pop(), Ok(1));
        assert_eq!(a.pop(), Ok(2));
        assert_eq!(a.pop(), Ok(3));
        assert_eq!(a.pop(), Err("Queue is empty"));
    }
}
```

= 两个数据结构与标准库实现的对比


实际上这两个数据结构都是非常基础的，而且标准库中实际上有一些符合这两个数据结构使用方式的类型。

`Vec`可以做为一个简单的栈使用

```rust
let mut stack = Vec::new();
stack.push(1); // 等价于入栈
stack.pop(); // 等价于出栈
```

`VecDeque`可以做为一个简单的队列使用。
```rust
let mut queue = VecDeque::new();
queue.push_back(1);
queue.pop_front();
queue.pop_back();
```

那为什么还要学习数据结构和算法呢？因为其中的思想可以帮助我们解决更多问题

== 环形队列

我们的队列实现虽然可以使用，但是在某些情况下会存在问题。如果我们定义了一个长度为100的队列


```rust
let mut queue = Queue::<i32,100>::new();
```

如果我们往队列中添加100个元素，然后我们再从队列中取出100个元素，那么队列中就只剩下0个元素了

虽然此时队列是空的，但是我们再也没办法向队列里添加元素了。这是因为队列的实现中，top和bottom都是单向增长的，所以在100轮之后，top和bottom都指向了队列的最后一个元素。

但是这些前面的空间能否被重新利用呢？

---

答案是可以的，我们可以将整个数组想象成一个环形结构在top或者bottom超出数组边界时，我们只需要将top或者bottom指向数组的另一个边界即可。
#[
  #set text(size: 16pt)

```rust
#[derive(Debug)]
struct CircledQueue<T, const N: usize> {
    data: [T; N],
    bottom: usize,
    top: usize,
    size: usize,
}
impl<T: Default, const N: usize> CircledQueue<T, N> {
    fn new() -> Self {
        Self {
            data: std::array::from_fn(|_i| T::default()),
            top: 0,
            bottom: 0,
            size: 0,
        }
    }
    fn push(&mut self, item: T) -> Result<(), &'static str> {
        if self.size == N {
            return Err("CircledQueue is full");
        }
        self.data[self.top] = item;
        self.top = (self.top + 1) % N;
        self.size += 1;
        Ok(())
    }
    fn pop(&mut self) -> Result<T, &'static str> {
        if self.size == 0 {
            Err("CircledQueue is empty")
        } else {
            let mut k = T::default();
            std::mem::swap(&mut k, &mut self.data[self.bottom]);
            self.bottom = (self.bottom + 1) % N;
            self.size -= 1;
            Ok(k)
        }
    }
}
```
]