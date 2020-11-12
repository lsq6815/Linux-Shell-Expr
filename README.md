# Linux课程shell编程实验任务书
----------------------------

**【实验内容】**

使用`shell`进行编程，使得程序能够完成以下功能：

将给定的源文件夹中的文件按照**后缀名**进行分类，并复制到目标文件夹中的各子文件夹中（各子文件夹以对应后缀名作为文件夹名）。同时，在目标文件夹中，应当有一个`analysis.txt`的分析文件，至少需要记录各文件的原始路径，现路径与其后缀名等信息。

**【基本要求】**

- [x] 源文件夹与目的文件夹通过**参数**的方式传入，若未指定源文件夹，则以**当前文件夹（`./`）为源文件夹**；若未指定目标文件夹，则需要**在临时目录（`/tmp`）中创建临时文件夹来进行存储**。

- [x] 程序应当判断目标文件夹是否已存在，若已存在，则需要在文件夹名后面加上一个随机子串，防止破坏原有文件夹结构。

- [x] 若出现文件重名，需要在新加入的文件后缀名前添加数字段以保证复制的正常进行，
    > 如：若main.cpp发生冲突，则需要修改文件名为main.2.cpp，依次类推。

- [x] 程序需要输出源文件夹、目标文件夹、分析文件的路径。

- [x] 分析文件可以使用column命令进行对齐。

**【主要知识】**

1.  shell条件控制

2.  shell函数

3.  文件、文件夹的操作

4.  文件的读写

5.  其他常用命令

**【参考资料】**

1.  [菜鸟教程shell教程](http://www.runoob.com/linux/linux-shell.html)

2.  [Shell scripting: Parsing command-line arguments and flags easily](https://pretzelhands.com/posts/command-line-flags)

3.  [Shell正则表达式](https://man.linuxde.net/docs/shell_regex.html)

4.  [How to Increment and Decrement Variable in Bash (Counter)](https://linuxize.com/post/bash-increment-decrement-variable/)

5.  [linux shell实现随机数多种方法（date,random,uuid)](https://www.cnblogs.com/chengmo/archive/2010/10/23/1858879.html)
