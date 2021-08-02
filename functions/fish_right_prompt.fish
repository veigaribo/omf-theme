function git::is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function git::get_ahead_count
  echo (command git log 2> /dev/null | grep '^commit' | wc -l | tr -d " ")
end

function git::branch_name
  command git symbolic-ref --short HEAD 2> /dev/null || \
          echo (__color_dim)"detached"(__color_off)
end

function git::is_touched
  test -n (echo (command git status --porcelain))
end

function fish_right_prompt
  set -l code $status
  test $code -ne 0; and echo (__color_dim)"("(__color_snd)"$code"(__color_dim)") "(__color_off)

  if test -n "$SSH_CONNECTION"
     printf (__color_trd)":"(__color_dim)"$HOSTNAME "(__color_off)
   end

  if git rev-parse 2> /dev/null
    git::is_stashed; and echo (__color_trd)"^"(__color_off)
    printf (__color_snd)"("(begin
      if git::is_touched
        echo (__color_trd)"*"(__color_off)
      else
        echo ""
      end
    end)(__color_fst)(git::branch_name)(__color_snd)(begin
      set -l count (git::get_ahead_count)
        if test $count -eq 0
          echo ""
        else
          echo (__color_trd)"+"(__color_fst)$count
        end
    end)(__color_snd)") "(__color_off)
  end
  printf (__color_dim)(date +%H(__color_fst):(__color_dim)%M(__color_fst):(__color_dim)%S)(__color_off)" "
end
