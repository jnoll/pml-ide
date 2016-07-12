A web-based development environment for the PML process modeling
language.

Features:

* Upload PML files and check syntax.
* Edit PML code.

At present, the only way to save code is to copy and paste from the
editor.

# Installation

The PML ide is a CGI script written in haskell, and uses the
[pmlcheck]() utility for syntax checking.



1. Install Haskell `stack`: follow the instructions at
http://docs.haskellstack.org/en/stable/install_and_upgrade/.
s2. Create stack.yaml
    cd pml-ide
    stack init
    stack setup

2. Clone this repository.

    git clone https://github.com/jnoll/pml-ide.git    

3. Clone the `peos` repository 

    cd pml-ide
    git clone https://github.com/jnoll/peos.git

4. Build the pml-ide cgi script and `pmlcheck` utility.

    make build

    
5. Install the pml-ide script and web pages.

    make install
    
6. Test: visit http://hostname/~install-account/pml-ide/pmlcheck.html

