# radare2 速查表

## 基础侦察

```powershell
rabin2 -I sample.exe
rabin2 -S sample.exe
rabin2 -i sample.exe
rabin2 -E sample.exe
rabin2 -zz sample.exe
```

## 进入交互

```powershell
r2 sample.exe
```

```text
aaa
afl
iz
iS
is
s entry0
pdf
q
```

## 字符串和引用

```text
iz~http
iz~error
axt <addr>
s <addr>
pdf
```

## 常用查看

```text
px 64
pd 20
psz
pxa
```

## patch

```powershell
r2 -w sample.exe
```

```text
s 0x401000
wa nop
wx 9090
wq
```

## 非交互模式

```powershell
r2 -A -q -c "afl;iz;ii;q" sample.exe
```

## 其他工具

### rasm2

```powershell
rasm2 -d "9090"
rasm2 -a x86 -b 64 "xor eax, eax"
```

### radiff2

```powershell
radiff2 old.exe new.exe
radiff2 -C old.exe new.exe
```

### rahash2

```powershell
rahash2 -a md5 sample.exe
rahash2 -a sha256 sample.exe
```

### rax2

```powershell
rax2 0x401000
rax2 4198400
rax2 -s hello
```

## radare2-skills 生态命令

### r2xsql 查询示例

```powershell
r2xsql -s sample.exe -q "SELECT name, module FROM imports WHERE name LIKE '%Crypt%'"
r2xsql -s sample.exe -q "SELECT addr, content FROM strings WHERE content LIKE '%http%'"
```

### r2http / r2mcp 会话

```powershell
r2 -N -e http.bind=127.0.0.1 -e http.port=9393 -e http.sandbox=true -q -c=h sample.exe
```

仅在隔离的本地环境中临时启用；不要暴露或自动调用未认证的 `/cmd` 端点，使用完立即停止服务。

### radius2 符号执行

```powershell
radius2 -p sample.exe -s stdin 96 -X Incorrect
radius2 -p sample.exe -s flag 256 -A . flag -B Correct -X Wrong -j
```

### r2pm 插件安装

```powershell
r2pm -l
```

安装社区插件前先审计源码并固定提交；不要直接执行未固定来源的 `r2pm -ci`。
