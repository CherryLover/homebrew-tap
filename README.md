# CherryLover/homebrew-tap

我自己的 Homebrew tap。

## 安装

```bash
brew install cherrylover/tap/ssh-hold
```

`brew` 会自动把这个 tap 加上，不用先手工 `brew tap`。

## 里面有什么

| Formula | 说明 |
|---|---|
| [ssh-hold](https://github.com/CherryLover/ssh-hold) | 撑开并复用一条 SSH 连接：认证一次，之后所有命令都走这条已经开着的通道，也能安全地交给 AI Agent 用 |

装完之后：

```bash
ssh-hold version          # 看装在哪、运行库和技能文件在哪
ssh-hold skill install    # 把用法教给本机的 Claude Code / Codex
man ssh-hold              # 完整手册
```

## 更新

Formula 由 [bump-ssh-hold](.github/workflows/bump-ssh-hold.yml) 每天自动对齐到上游最新的
Release，也可以在 Actions 页面手动触发。用的是内置的 `GITHUB_TOKEN`，不需要额外配 secret。

## 其他

在 `brew bundle` 的 Brewfile 里：

```ruby
tap "cherrylover/tap"
brew "ssh-hold"
```
