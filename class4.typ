
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
    subtitle: [基础阶段 - Rust编程],
    author: [温祖彤],
    date: [2024年10月7日],
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

- 枚举与Options
- Rust 的包、create 和模块
- Rust 泛型

<br>

*《Rust程序设计语言》*：

https://kaisery.github.io/trpl-zh-cn/

*《通过例子学Rust》*：

https://rustwiki.org/zh-CN/rust-by-example/

*Rust语言中文社区*：

https://rustcc.cn/

= 枚举（enum）

#auto-two-column(
  [*枚举定义*

    ```rust
    enum IpAddrKind {
        V4,
        V6,
    }
    ```

    包含成员关联类型的定义

    ```rust
    enum IpAddr {
        V4(String),
        V6(String),
    }
    ```],
  [创建成员实例

    ```rust
    let four = IpAddrKind::V4;
    let six = IpAddrKind::V6;
    ```
  ],
)




= 枚举实例

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

成员初始化

```rust
let messages = [
    Message::Move { x: 10, y: 30 },
    Message::Echo(String::from("hello world")),
    Message::ChangeColor(200, 255, 255),
    Message::Quit,
];
```

= Option枚举

`Option` 是标准库定义的另一个枚举。`Option` 类型应用广泛因为它编码了一个非常普遍的场景，即一个值要么有值要么没值。

```rust
enum Option<T> {
    None,
    Some(T),
}
```

Option值

```rust
let some_number = Some(5);
let some_char = Some('e');

let absent_number: Option<i32> = None;
```

= match控制流
#auto-two-column(
  [Rust 有一个叫做 `match` 的极为强大的控制流运算符，它允许我们将一个值与一系列的模式相比较，并根据相匹配的模式执行相应代码。
    类似其他语言的 switch],
  [```rust
    enum Coin {
        Penny,
        Nickel,
        Dime,
        Quarter,
    }
    fn value_in_cents(coin: Coin) -> u8 {
        match coin {
            Coin::Penny => 1,
            Coin::Nickel => 5,
            Coin::Dime => 10,
            Coin::Quarter => 25,
        }
    }
    ```],
)




= match控制流

在match分支中运行多行代码

```rust
fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        }
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

= 分支中绑定匹配模式值
#auto-two-column(
  [


    ```rust
    #[derive(Debug)]
    enum UsState {
        Alabama,
        Alaska,
        // --snip--
    }
    enum Coin {
        Penny,
        Nickel,
        Dime,
        Quarter(UsState),
    }
    ```
  ],
  [
    ```rust
    fn value_in_cents(coin: Coin) -> u8 {
      match coin {
          Coin::Penny => 1,
          Coin::Nickel => 5,
          Coin::Dime => 10,
          Coin::Quarter(state) => {
              println!("State quarter from {:?}!", state);
              25
          }
      }
    }
    ```
  ],
)

= 匹配 Option

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

let five = Some(5);
let six = plus_one(five);
let none = plus_one(None);
```

= 通配符匹配
#auto-two-column(
  [```rust
    let dice_roll = 9;
    match dice_roll {
        3 => add_fancy_hat(),
        7 => remove_fancy_hat(),
        other => move_player(other),
    }

    fn add_fancy_hat() {}
    fn remove_fancy_hat() {}
    fn move_player(num_spaces: u8) {}
    ```],
  [
    使用'\_'通配符

    ```rust
    	let dice_roll = 9;
        match dice_roll {
            3 => add_fancy_hat(),
            7 => remove_fancy_hat(),
            _ => reroll(),
        }

        fn add_fancy_hat() {}
        fn remove_fancy_hat() {}
        fn reroll() {}
    ```
  ],
)




= match控制流

*match 控制流结构*

- match 是 Rust 的一个强大的控制流运算符，它可以将一个值与一系列的模式相比较，并根据匹配的模式执行相应的代码。
- match 的分支由一个模式和一些代码组成，可以使用变量或通配符来绑定匹配的模式的部分值。
- match 是穷尽的，必须覆盖所有可能的情况，否则会编译错误。

*`Option<T>`和 match*

- `Option<T>` 是 Rust 的一个枚举，它表示一个值可能存在或不存在。
- match 可以用来处理 `Option<T>` 的成员，Some(T) 或 None，并根据其中是否有值执行不同的操作。
- 使用 \_ 模式可以匹配任意值而不绑定到该值，用于忽略不需要使用的值或满足穷尽性要求。

= if let 简洁控制流

`if let` 语法让我们以一种不那么冗长的方式结合 `if` 和 `let`，来处理只匹配一个模式的值而忽略其他模式的情况。

```rust
let mut count = 0;
match coin {
    Coin::Quarter(state) => println!("State quarter from {:?}!", state),
    _ => count += 1,
}
```
#line(length: 100%)
```rust
let mut count = 0; // 使用if let
if let Coin::Quarter(state) = coin {
    println!("State quarter from {:?}!", state);
} else {
    count += 1;
}
```

= Rust模块

这里有一个需要说明的概念 “作用域（scope）”：代码所在的嵌套上下文有一组定义为 “in scope” 的名称。当阅读、编写和编译代码时，程序员和编译器需要知道特定位置的特定名称是否引用了变量、函数、结构体、枚举、模块、常量或者其他有意义的项。你可以创建作用域，以及改变哪些名称在作用域内还是作用域外。同一个作用域内不能拥有两个相同名称的项；可以使用一些工具来解决名称冲突。

Rust 有许多功能可以让你管理代码的组织，包括哪些内容可以被公开，哪些内容作为私有部分，以及程序每个作用域中的名字。这些功能。这有时被称为 “模块系统（the module system）”，包括：

- *包*（*Packages*）：Cargo 的一个功能，它允许你构建、测试和分享 crate。
- *Crates* ：一个模块的树形结构，它形成了库或二进制项目。
- *模块*（*Modules*）和 *use*：允许你控制作用域和路径的私有性。
- *路径*（*path*）：一个命名例如结构体、函数或模块等项的方式

= 包和 create

*包和 crate*

- 包是提供一系列功能的一个或者多个 crate，包含一个 Cargo.toml 文件。
- crate 是 Rust 在编译时最小的代码单位，有两种形式：二进制项和库。
- crate root 是一个源文件，是 crate 的根模块。

*crate 的约定*

- src/main.rs 是一个与包同名的二进制 crate 的 crate 根。
- src/lib.rs 是一个与包同名的库 crate 的 crate 根。
- src/bin 目录下的每个文件都会被编译成一个独立的二进制 crate。

= 模块系统与模块树

*模块系统*

- 模块可以将crate中的代码进行分组和封装，提高可读性和重用性。
- 路径是一种命名项的方式，可以使用绝对路径或相对路径。
- use关键字可以在一个作用域内创建一个项的快捷方式，减少长路径的重复。
- pub关键字可以将模块或模块内的项标记为公开的，使外部代码可以使用它们。

*模块树*

- crate根文件（src/lib.rs或src/main.rs）是crate模块结构的根，也是名为crate的隐式模块的根。
- 在crate根文件中，可以声明新的模块，使用mod关键字和花括号或分号。
- 在其他文件中，可以定义子模块，使用mod关键字和花括号或分号，并在以父模块命名的目录中寻找子模块代码。
- 模块树可以用来展示crate中的模块层次结构，以及模块之间的父子和兄弟关系。

= 引用模块的路径

- *绝对路径*（*absolute path*）是以 crate 根（root）开头的全路径；对于外部 crate 的代码，是以 crate 名开头的绝对路径，对于当前 crate 的代码，则以字面值 `crate` 开头。
- *相对路径*（*relative path*）从当前模块开始，以 `self`、`super` 或当前模块的标识符开头。

绝对路径和相对路径都后跟一个或多个由双冒号（`::`）分割的标识符。

= 声明模块

一个crate中，可以包含多个模块。

声明的模块将通过以下几种途径去寻找：

- 内联，在大括号中，当mod xxx后方不是一个分号而是一个大括号

- 在文件 src/xxx.rs

- 在文件 src/xxx/mod.rs

= 声明子模块

在除了根节点之外的其他文件的模块中，也可以声明子模块。

例如，在src/xxx.rs中定义了一个mod yyy。那么在以下几个位置寻找：

- 内联，在大括号中，当mod yyy后方不是一个分号而是一个大括号

- 在文件 src/xxx/yyy.rs

- 在文件 src/xxx/yyy/mod.rs

= 使用use关键字引用模块

例如在xxx模块的yyy子模块下面定义了一个zzz

那么可以通过crate::xxx::yyy::zzz;来使用它。

使用use关键字

使用use crate::xxx::yyy::zzz;之后，之后可以直接用zzz

使用as关键字

（这和python中import xxx as yyy类似）

use crate::xxx::yyy::zzz as z;

= 模块私有和公有

在rust中，默认对父模块来说，所有内容都是私有的。

所以在mod关键词之前加pub，让父模块可以访问子模块。

子模块的函数或者变量，也要加pub，让父模块访问。

一言以蔽之，想要访问私有，就用pub。

= Rust泛型

*泛型数据类型*

- 泛型数据类型可以让代码适用于多种不同的具体类型，避免重复和冗余。
- 泛型可以用在函数签名、结构体、枚举和方法中，用尖括号 <> 来声明泛型参数的名称。
- 泛型参数可以有限制（constraint），指定它们必须实现某些 trait 或具有某些行为。

*单态化*

- Rust 通过在编译时进行泛型代码的单态化，将泛型参数替换为具体类型，来保证运行时的效率。
- 单态化可以避免使用泛型带来的性能损失，使得泛型代码的执行速度与手写的具体类型代码一样快。

= 在函数定义中使用泛型
#auto-one-column([
  #set text(size: 16pt)

  ```rust
  fn largest_i32(list: &[i32]) -> &i32 {
      let mut largest = &list[0];
      for item in list {
          if item > largest {
              largest = item;
          }
      }
      largest
  }
  fn largest_char(list: &[char]) -> &char {
      let mut largest = &list[0];
      for item in list {
          if item > largest {
              largest = item;
          }
      }
      largest
  }


  fn main() {
      let number_list = vec![34, 50, 25, 100, 65];
      let result = largest_i32(&number_list);
      println!("The largest number is {}", result);
      let char_list = vec!['y', 'm', 'a', 'q'];
      let result = largest_char(&char_list);
      println!("The largest char is {}", result);
  }
  ```])


= 在函数定义中使用泛型
#auto-one-column([
  #set text(size: 16pt)

  ```rust
  fn largest<T>(list: &[T]) -> &T {
      let mut largest = &list[0];

      for item in list {
          if item > largest {
              largest = item;
          }
      }

      largest
  }









  fn main() {
      let number_list = vec![34, 50, 25, 100, 65];

      let result = largest(&number_list);
      println!("The largest number is {}", result);

      let char_list = vec!['y', 'm', 'a', 'q'];

      let result = largest(&char_list);
      println!("The largest char is {}", result);
  }
  ```])


= 结构体定义中的泛型
#auto-two-column(
  [```rust
    struct Point<T> {
        x: T,
        y: T,
    }

    fn main() {
        let integer = Point { x: 5, y: 10 };
        let float = Point { x: 1.0, y: 4.0 };
    }
    ```],
  [多个泛型类型
    #set text(size: 16pt)
    ```rust
    struct Point<T, U> {
        x: T,
        y: U,
    }

    fn main() {
        let both_integer = Point { x: 5, y: 10 };
        let both_float = Point { x: 1.0, y: 4.0 };
        let integer_and_float = Point { x: 5, y: 4.0 };
    }
    ```],
)




= 方法定义中的泛型

```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

fn main() {
    let p = Point { x: 5, y: 10 };

    println!("p.x = {}", p.x());
}
```
