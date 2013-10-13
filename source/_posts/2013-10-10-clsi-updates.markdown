---
layout: post
title: "CLSI Updates"
date: 2013-10-10 19:07
comments: true
categories: [CLSI, LaTeX, OpenShift]
---

In the last few months, I have work on a Common Latex Server Interface
port to Python. The repo is hosted on
[GitHub](http://github.com/pacbard/clsipy).

# Installation
This CLSI implementation will work out-of-the-box on
[OpenShift](http://openshift.com). A ```pre-start``` hook guarantees that the
current version of TexLive is installed. To update the installation, it is best
to use the incldued ```tlmgr``` utility or to delete the TexLive directory from
the server, which would force the complete reisntallation of LaTeX.

# Support for custom build engines
One of the biggest changes in the CLSI code has been to support client-declared
compilers and output formats.  The CLSI parser will extract this information
from the XML request, compile using the provided command, and return the
requested output file. To avoid compilation errors, it is advised to use the
following combinations of compilers/output formats:

```
latex       dvi, ps, pdf (png, jpg, tiff, bmp with standalone class)
pdflatex    pdf
lualatex    pdf
xelatex     pdf
latexmk     dvi, ps, pdf (png, jpg, tiff, bmp with standalone class)
```

It is also possible to include compiler options within the XML request by adding
it to the XML compiler option (e.g., ```"latexmk -pdf"``` will compile the file
with```latexmk``` as compiler and ```-pdf``` as option.

# Tokens
Authorized users will have to use a token to access the CLSI server. The token
needs to be included in the XLM request. At the time to writing, each CLSI
server has a master token that is stored in the ```CLSI_TOKEN``` enironment
variable. If this variable is not set, the server will use the standard fallback
token (```clsi_token```). For security reasons, it is advised to setup a token
as soon as possible. The command ```rhc env-set CLSI_TOKEN <TOKEN VALUE> --app NAME```
can be used to specify env variables client side.

# CLI Client
The [Remote Latex CLI](http://pacbard.github.io/RLatex) is the suggested
application to access a CLSI server. This project's goal is to
provide a LaTeX-like executable that leverages the CLSI server as compiler.
At this time, the CLSI has been tested on Windows 7 (both using the native
python application or the provided .exe), Mac OS 10.7, and Linux without major
issues.

# Future Development
Future development will focus on adding the asynchronous compilation option. At
this time, this feature is not supported and the CLSI can behave unexpectedly if
this option is used.
