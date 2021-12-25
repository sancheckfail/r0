# r0

## Install
```shell
apt install ruby -y (or what ever)
gem install sinatra
gem install sinatra-cross_origin
```
## Usage

```shell
ruby main.rb
```

Then in browser: 
http://127.0.0.1:8888

## Introduction

Input is a YAML format

```YAML
id: 'coqtest'
sh: 'coqtop 2>&1 <code | tail -n 20'
code: |
    Axiom LEM: forall P : Prop, P \/ ~P.
    Lemma DNE: forall P : Prop, ~~P -> P.
    Proof.
       intros.
       destruct (LEM P) as [ H1 | H2 ].
       assumption.
       tauto.
       Qed.
```       

#### code
its content will go to a file named 'code'

#### fs 
```YAML
fs:
    a.txt: |
       Hello
    b.txt: |
       World
```

Will create two files with the contents
(Not supporting nesting folders at present)

#### sh
What to run
```YAML
sh: 'coqtop 2>&1 <code'
```

#### before
An array, each is run before finally running 'sh' line

#### id
```
id: 'a'
```
The snippet will be saved in a file named 'a'

If you type 
```YAML
load: 'a'
```
The output will be the content
