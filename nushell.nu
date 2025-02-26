$env.EDITOR = "micro"
alias nano = micro

$env.config.show_banner = false

$env.config.cursor_shape.emacs = "line"

$env.config.history.file_format = "sqlite"
$env.config.history.isolation = true

$env.config.completions.case_sensitive = true

$env.config.datetime_format.normal = 'AAA %a, %d %b %Y %H:%M:%S %z'
$env.config.datetime_format.table = '%d %b %Y  %H:%M'

# Adds weird artifacts in Konsole
$env.config.shell_integration.osc133 = false

if $env.NU_USER_FORCE_LIGHT_THEME? != null {
  # $env.config.color_config = $light_theme
}

export def ack [pattern, ...pat, --ignore-case (-i)] {
  if ($in != null) {
    error make { msg: "Cannot use ack wrapper with pipelining yet" }
  }

  mut files: list<string> = []
  if $pat != [] {
    $files = ($pat | each { glob $in } | flatten)
    if $files == [] {
     error make { msg: ("No matches found for " ++ ($pat | each { into string } | str join "asd")) }
    }
  }
  # -H: Print filenames even if only a single one is given
  ^ack --color -H --column $pattern ...([] ++ if $ignore_case {["-i"]} else {[]}) ...$files | lines | parse "{name}:{line}:{column}:{match}" | update name { ansi strip } | update line { ansi strip } | update column { ansi strip }
  #^ack --color --column $pattern | lines | parse "{name}:{match}" | update name { ansi strip }
}

export def nano-ack [] {
  let data = $in
  # TODO: "ansi strip" is required since "input list" behaves weirdly when fed lines containing color codes
  let index = $data | table --theme none | lines | skip 1 | each { ansi strip } | input list --fuzzy --index
  let choice = $data | get $index
  nano ($choice.name ++ ":" ++ $choice.line ++ ":" ++ $choice.column)
  #input list --fuzzy | nano $in.name
}

export def list-conflicts [] {
  git status -s | lines | find -r '^UU ' | str substring 3..
}

#let fish_completer = {|spans|
#    fish --command $'complete "--do-complete=($spans | str join " ")"'
#    | from tsv --flexible --noheaders --no-infer
#    | rename value description
#}
#
#$env.config.completions.external.enable = true
#$env.config.completions.completer = $fish_completer

use std *
path add /opt/homebrew/bin
path add '~/.cargo/bin'
