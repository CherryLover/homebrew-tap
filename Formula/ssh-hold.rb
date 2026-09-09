class SshHold < Formula
  desc "Hold one SSH connection open and reuse it for every command after"
  homepage "https://github.com/CherryLover/ssh-hold"
  url "https://github.com/CherryLover/ssh-hold/releases/download/v1.1.0/ssh-hold-1.1.0.tar.gz"
  sha256 "c0ab9242ea8e3dc07436858f665e1198f2670accec56f8d44ccd3c909d72aacf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    bin.install "bin/ssh-hold"
    # ssh-hold 按可执行文件的位置找 ../lib/ssh-hold 和 ../share/ssh-hold，
    # 装成这个布局就不用再传 SSH_HOLD_LIB。
    (lib/"ssh-hold").install "lib/askpass", "lib/paste.py"
    chmod 0755, lib/"ssh-hold/askpass"
    pkgshare.install "skill/SKILL.md"
    man1.install "man/ssh-hold.1"
    bash_completion.install "completions/ssh-hold.bash" => "ssh-hold"
    zsh_completion.install "completions/_ssh-hold"
  end

  def caveats
    <<~EOS
      把用法教给本机的 Claude Code / Codex（两边都会写）：
        ssh-hold skill install

      ssh-hold paste 需要 python3，且只支持 macOS 剪贴板；
      其余子命令没有这个依赖。
    EOS
  end

  test do
    ENV["HOME"] = testpath
    ENV["SSH_HOLD_DIR"] = testpath/"hold"

    assert_match "ssh-hold #{version}", shell_output("#{bin}/ssh-hold version")
    assert_match "现在没有撑开的通道", shell_output("#{bin}/ssh-hold list")

    # 名字对不上时必须停下来报错，绝不退回去挑另一条通道执行。
    output = shell_output("#{bin}/ssh-hold run nope -- hostname 2>&1", 1)
    assert_match "没有名为 nope 的通道", output

    # 运行库和技能文件都要能从安装位置找到。
    (testpath/".claude").mkpath
    system bin/"ssh-hold", "skill", "install"
    assert_path_exists testpath/".claude/skills/ssh-hold/SKILL.md"
    assert_match "name: ssh-hold", (testpath/".claude/skills/ssh-hold/SKILL.md").read
  end
end
