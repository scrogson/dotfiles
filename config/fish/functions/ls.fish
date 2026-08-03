function ls
  if command -q eza
    command eza --git -lh $argv
  else
    command ls $argv
  end
end
