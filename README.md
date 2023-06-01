# Dotfile

# Minimal install

Add in the ``.bashrc``

``` 
source ~/.dotfile

for file in ~/.bashrc.d/*.bashrc;
do
  source "$file"
done
```

``make make dot-bashrc``

