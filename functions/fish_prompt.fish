function fish_prompt
  test $status -ne 0;
    and set -l color 900
    or  set -l color fa0

  set -l pwd (prompt_pwd)
  set -l base (basename "$pwd")

  set -l expr "s|/|"(__color_snd)"/"(__color_off)"|g;  \
               s|"$base"|"(__color_fst)$base(__color_off)" |g"

  echo -n (echo "$pwd" | sed -e $expr)(__color_off)

  echo -n (set_color $color)">"

  echo -n " "
end
