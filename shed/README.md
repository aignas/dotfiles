# Shed

Stolen and adapted from a [great example from @motiejus][1]

```
$ grep shed ~/.zshrc
alias shed="docker run --name shed --volume ${PWD}:/x --workdir /x --tty --interactive --rm aignas/shed:latest"
```

[1]: https://github.com/motiejus/toolshed
