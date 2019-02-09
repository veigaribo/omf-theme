function git::is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function git::get_ahead_count
  echo (command git log ^/dev/null | grep '^commit' | wc -l | tr -d " ")
end

function git::branch_name
  command git symbolic-ref --short HEAD
end

function git::is_touched
  test -n (echo (command git status --porcelain))
end

function fish_right_prompt
  set -l code $status
  test $code -ne 0; and echo (batman_color_dim)"("(batman_color_trd)"$code"(batman_color_dim)") "(batman_color_off)

  if test -n "$SSH_CONNECTION"
     printf (batman_color_trd)":"(batman_color_dim)"$HOSTNAME "(batman_color_off)
   end

  if git rev-parse 2> /dev/null
    git::is_stashed; and echo (batman_color_trd)"^"(batman_color_off)
    printf (batman_color_snd)"("(begin
      if git::is_touched
        echo (batman_color_trd)"*"(batman_color_off)
      else
        echo ""
      end
    end)(batman_color_fst)(git::branch_name)(batman_color_snd)(begin
      set -l count (git::get_ahead_count)
        if test $count -eq 0
          echo ""
        else
          echo (batman_color_trd)"+"(batman_color_fst)$count
        end
    end)(batman_color_snd)") "(batman_color_off)
  end
  printf (batman_color_dim)(date +%H(batman_color_fst):(batman_color_dim)%M(batman_color_fst):(batman_color_dim)%S)(batman_color_off)" "
end
