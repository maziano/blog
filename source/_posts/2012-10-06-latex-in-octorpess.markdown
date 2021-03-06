---
layout: post
title: "LaTeX in Octorpess"
date: 2012-10-06 09:24
comments: true
categories: [LaTeX, GitHub Pages, How To]
keywords: "latex, octopress, mathjax"
---

{% blockquote %}
UPDATE - LaTeX is no longer supported in this blog.  I will leave these instructions in case you want to add LaTeX to your Octopress blog.
{% endblockquote %}

After much tinkering, I decided to use [kramdown](http://kramdown.rubyforge.org/) as the markdown parser for my blog, since it supports $\LaTeX$ [out of the box](http://kramdown.rubyforge.org/converter/latex.html).

# Install KramDown

To install the KramDown gem, just type ```gem install kramdown``` 
and change the markdown engine in the ```_config.yml``` file to
```markdown: kramdown```

# Include MathJax

To include [MathJax](http://www.mathjax.org/), you have to add the following code into ```/source/_includes/custom/head.html```.

{% gist 3845538 %}

# Examples

Finally, here are some $\LaTeX$ examples

## Inline equations
For inline equations, just use the ```$ \text{some} \LaTex $``` command.  For example $\pi \approx 3.1415$ is generated by the code ```$\pi \approx 3.1415$```.

Another way to generate inline equations is with ```\\( \text{some} \LaTex \\)```, for example \\( \cos^2(x)+\sin^2(x) = 1 \\).
 
## Display equations
For display equations, the following command is supported ```$$ $ \text{some} \LaTex $$```.
As per [kramdown doc](http://kramdown.rubyforge.org/syntax.html#math-blocks), this command will wrap the equation using ```\begin{displaymath}``` and ```\end{displaymath}```.

$$ x=\dfrac{-b \pm \sqrt{b^2-4ac}}{2a} $$

Which is generated by this code: ```$$ x=\dfrac{-b \pm \sqrt{b^2-4ac}}{2a} $$```

At the same way, you can generate display equations with the $\LaTeX$ command ```\\[ \text{some} \LaTex \\]```, here is an example:
\\[
  \frac{1}{\displaystyle 1+
  \frac{1}{\displaystyle 2+
  \frac{1}{\displaystyle 3+x}}} +
  \frac{1}{1+\frac{1}{2+\frac{1}{3+x}}}
\\]

# Right-click Bug Fix

As [Luikore](http://luikore.github.com/2011/09/good-things-learned-from-octopress/) points out, there is a bug when right-clicking on a MathJax formula.  To fix it, open ```sass/base/_theme.scss``` and change the div under body from

{% codeblock lang:css %}
body {
  > div {
    background: $sidebar-bg $noise-bg;
{% endcodeblock %}

to

{% codeblock lang:css %}
body {
  > div#main {
    background: $sidebar-bg $noise-bg;
{% endcodeblock %}

# Acknowledgments

This post is inspired by these posts from [chico](http://oblita.com/blog/2012/07/06/octopress-with-mathjax-by-kramdown/) and [Chao Chu](http://chuchao333.github.com/blog/2012/08/18/supporting-latex-in-octopress/)

## Other Solutions

There are a variety of alternative solutions to include $\LaTeX$ in Octopress, like:

- [Luikore](http://luikore.github.com/2011/09/good-things-learned-from-octopress/)
- [Chao Chu](http://chuchao333.github.com/blog/2012/08/18/supporting-latex-in-octopress/)
- [chico](http://oblita.com/blog/2012/07/06/octopress-with-mathjax-by-kramdown/)