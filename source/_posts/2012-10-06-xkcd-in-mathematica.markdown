---
layout: post
title: "XKCD in Mathematica"
date: 2012-10-06 13:02
comments: true
categories: [Mathematica, XKCD, StackExchange]
---

A Mathematica function that generates XKCD charts!

{% img center http://static.pacbard.tk/media/2012/ohDio.jpg 388 323 Awesome graph %}

I really believe that this wins the internet - at least for this month.

```
xkcdStyle = &#123;FontFamily -&gt; "Comic Sans MS", 16&#124;;

xkcdLabel[&#123;str_, &#123;x1_, y1_&#124;, &#123;xo_, yo_&#124;&#124;] := Module[&#123;x2, y2&#124;,
   x2 = x1 + xo; y2 = y1 + yo;
   &#123;Inset[
     Style[str, xkcdStyle], &#123;x2, y2&#124;, &#123;1.2 Sign[x1 - x2],
      Sign[y1 - y2] Boole[x1 == x2]&#124;], Thick,
    BezierCurve[&#123;&#123;0.9 x1 + 0.1 x2, 0.9 y1 + 0.1 y2&#124;, &#123;x1, y2&#124;, &#123;x2, y2&#124;&#124;]&#124;];

xkcdRules = &#123;EdgeForm[ef:Except[None]] :&gt; EdgeForm[Flatten@&#123;ef, Thick, Black&#124;],
   Style[x_, st_] :&gt; Style[x, xkcdStyle],
   Pane[s_String] :&gt; Pane[Style[s, xkcdStyle]],
   &#123;h_Hue, l_Line&#124; :&gt; &#123;Thickness[0.02], White, l, Thick, h, l&#124;,
   Grid[&#123;&#123;g_Graphics, s_String&#124;&#124;] :&gt; Grid[&#123;&#123;g, Style[s, xkcdStyle]&#124;&#124;],
   Rule[PlotLabel, lab_] :&gt; Rule[PlotLabel, Style[lab, xkcdStyle]]&#124;;

xkcdShow[p_] := Show[p, AxesStyle -&gt; Thick, LabelStyle -&gt; xkcdStyle] /. xkcdRules

xkcdShow[Labeled[p_, rest__]] :=
 Labeled[Show[p, AxesStyle -&gt; Thick, LabelStyle -&gt; xkcdStyle], rest] /. xkcdRules

xkcdDistort[p_] := Module[&#123;r, ix, iy&#124;,
   r = ImagePad[Rasterize@p, 10, Padding -&gt; White];
   &#123;ix, iy&#124; =
    Table[RandomImage[&#123;-1, 1&#124;, ImageDimensions@r]~ImageConvolve~
      GaussianMatrix[10], &#123;2&#124;];
   ImagePad[ImageTransformation[r,
     # + 15 &#123;ImageValue[ix, #], ImageValue[iy, #]&#124; &, DataRange -&gt; Full], -5]];

xkcdConvert[x_] := xkcdDistort[xkcdShow[x]]
```