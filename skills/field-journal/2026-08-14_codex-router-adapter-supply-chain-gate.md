# 2026-08-14 Codex 路由适配器供应链门禁

## 场景分类

代码审计 / 工具链维护 / 多平台路由

## 目标概述

在不复制路由包内部模块、不批量安装外部工具的前提下，为 Codex 安装一个显式调用的最小适配器。

## Scope 摘要（脱敏）

- auth_basis: own_system
- network_profile: authorized_source_only
- asset_types: [local_repository, user_skill_adapter]

## 角色

- lead_role: lead
- specialists: [cae]

## 完整执行链路

1. 读取项目入口、路由、授权和供应链门禁。
2. 生成 gitignored 工具索引，不执行 capability bootstrap。
3. 按来源、权限、网络、配置写入、二进制和秘密模式审计整个包。
4. 将原仓库保留为路由核心，只安装一个无脚本的用户级适配器。
5. 固定适配器哈希，并用新 Codex 进程验证发现与路由。
6. 运行路由、结构一致性、冒烟和严格 case review。

## Evidence 链摘要（脱敏）

| E-id | severity | status | source_type | 可复用命令模式 | 关联 Finding |
|------|----------|--------|-------------|----------------|--------------|
| E-002 | medium | validated | command | `rg`/`git grep` 审计可执行面与凭据模式 | F-001, F-002 |
| E-003 | info | validated | file | `Get-FileHash <staging>,<installed>` | F-003 |
| E-004 | info | validated | command | `codex exec` + repository gates | F-003 |

## Finding / Path 摘要

- top_finding: 路由包本身可以原位使用，但 capability bootstrap 具有全局配置、包管理、下载和服务启动能力，不能等同于 skill 安装。
- path_type: callflow
- path_one_liner: 用户显式调用适配器 -> 原位读取路由 -> scope 门禁 -> 单一 PRIMARY -> 按需且单项批准 bootstrap

## 踩坑记录

| 问题 | 原因 | 解决方案 | 耗时 |
|------|------|---------|------|
| README 的“安装”含义容易被理解为复制所有模块 | 该包实际依赖仓库内相对路径和生成索引 | 只安装薄适配器，核心留在仓库 | 低 |
| bootstrap 默认可覆盖多个客户端配置 | 默认目标范围大于 Codex 安装需求 | 不自动运行；未来单项执行时显式限定 Codex | 低 |
| 安全文档包含强授权覆盖措辞 | 仓库内规则不能高于宿主策略 | 适配器明确保留宿主策略且禁止隐式调用 | 低 |

## 工具链发现

Codex 用户技能可通过 `$HOME/.agents/skills` 发现。工具索引刷新和 capability 安装必须分开：前者只生成状态，后者可能修改全局环境。

## 关键代码/命令

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File skills/scripts/refresh-tool-index.ps1
python skills/case-review/scripts/review_case.py work/<case> --verify-hashes --strict
```

## 对本包的改进建议

将 Codex 薄适配器作为独立、可审计的可选边界；README 明确区分“加载路由包”“刷新索引”和“安装外部 capability”。

## 可复用的模式/脚本片段

大型技能路由包采用“仓库原位核心 + 显式薄适配器 + 按 capability 审批”的三层模型；禁止把批量工具 bootstrap 混入 skill 注册步骤。

## 进化动作

- [ ] 更新了路由矩阵
- [x] 更新了 tool-index
- [ ] 更新了 bootstrap-manifest
- [ ] 更新了子 skill 文档
- [x] 新增了 pitfalls 记录
- [ ] 无需更新

## 环境信息

- OS: Windows
- 工具版本: PowerShell 5.1+ / Python 3 / Codex
- 目标平台/版本: Codex user skill discovery

## 脱敏要求

本条目不包含真实目标、凭据、内部地址或个人身份信息。

---
<!-- [进化统计] 本包累计完成项目: 18 | 本次新增模式: 1 | 本次修复工具链问题: 0 -->
<!-- [社区贡献] 尚未推送或创建 PR。 -->
