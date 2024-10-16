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
    title: [2024秋冬季开源操作系统训练营],
    subtitle: [基础阶段 - Rust编程],
    author: [温祖彤],
    date: [2024年9月29日],
  ),
  config-common(new-section-slide-fn: none),
)

// define a function of 2-column

#let auto-two-column(
  body1,
  body2,
) = (
  columns[
    #body1
    #colbreak()
    #body2
  ]
)

#let auto-one-column(
  body1,
  body2,
) = (
  columns[
    #body1
    #body2
  ]
)

#set heading(numbering: numbly("{1}.", default: "1.1"))

#title-slide()

// #import "@preview/touying:0.5.2": *
// #import themes.simple: *

// #show: simple-theme.with(
//   aspect-ratio: "16-9",
//   footer: [Simple slides],
// )
// #set text(font: "LXGW WenKai Mono", size: 20pt)
//

= 本人介绍

温祖彤，《从零构建Rust生产级服务》译者，曾参与过多次操作系统训练营的教学工作，对 Rust 语言/算法/开发有一定的了解，希望能够帮助大家更好地学习 Rust 语言。
#figure(
  image("book.jpg", height: 70%),
)


= 课程内容与安排

- Rust 课程共三周，九节课，三节语法课，三节答疑课，三节算法课
- 配套实验：训练营110题版 Rustlings (前30题为基础题目，不做要求)
- 晋级要求：完成训练营110题版 Rustlings 的所有题目
学习建议与时间安排

- 完成全部 Rustlings 题目一般需要五到十个小时，基础较好的同学三四个小时可完成，0基础也可以轻松完成
- 建议配合官方教材学习，课程时间有限无法面面俱到，部分内容可能需要自行拓展
- 学习过程中可随时在微信群内提问，讲师和助教会积极解答大家的问题
- 每节课对应二十道左右的 Rustlings 练习题，大家可以参考课程安排规划进度

= 导学课程预先目标

#set text(size: 17pt)

在进行明天的导学课程前，希望大家能够完成最基础的环境配置，可以从以下几个方面选择一个进行开发环境的配置（推荐使用Ubuntu24.04和VSCode进行开发）

- 原生Linux系统（推荐Ubuntu24.04）或者MacOS，直接安装在物理机上，体验最好，但不推荐，容易把电脑弄坏

- 虚拟机（VirtualBox/VMWare），安装一个Linux虚拟机，进行开发，体验与原生基本一致（课程演示将主要采用此种方式）

- WSL2（Windows上的Linux子系统，由微软官方推出，安装非常简易，非常适合使用Windows的同学，初始没有图形界面，需要一定的基础）

- Docker（适合使用过Docker的同学）

开发环境的配置相关教程可以参考各种搜索引擎，也希望大家在提问的时候多多查阅资料，提高自己的搜索能力。

明天的课程上我们会给大家安排详细的环境配置以及如何进行提交作业的流程演示，希望大家一定不要错过！

