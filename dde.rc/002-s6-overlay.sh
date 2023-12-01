# shell configuration for using s6-overlay in Docker

# exec into a quick exit script that shuts down s6 immediately and exits docker.
# An exec is necessary, or the exit only closes the sub shell executing the script.
function qb { exec docker-s6-quick-exit; }

# It'd be nice to just run this here in .bashrc, but bad things happen.
# Better for now to run interactively before running tmux.
function reset-stdin {
exec 0<&-
exec 0<>/dev/pts/0
}
