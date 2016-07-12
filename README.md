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

0. Clone this repository.

1. Install Haskell `stack`: follow the instructions at
http://docs.haskellstack.org/en/stable/install_and_upgrade/.
2. Create stack.yaml
    cd pml-ide
    stack init
    stack setup

3. Build  the pml-ide cgi script

    stack build
    
4. Install the pml-ide script and web pages.

    make install

5. Clone the `peos` repository

    git clone https://github.com/jnoll/peos.git

6. Build `pmlcheck`.

    cd peos/pml
    make
    
7. Copy `pmlcheck` to ~/public_html/pml-ide

    cp check/pmlcheck ~/public_html/pml-ide
    
8. Test: visit http://hostname/~install-account/pml-ide/pmlcheck.html

