---
layout: post
title: "Supercharge Octopress with Rack-Cache"
date: 2012-10-21 12:23
comments: true
tags: ["Octopress", "Cache"]
keywords: "octopress, cache, memcached, rack-cache"
---
<p>Since your <a href="http://octopress.org/">Octopress</a> blog is a static website, it is natural
to want to cache its contents, so reloading will be faster and your dyno will not
suffer from stress if you have a lot of visitors.</p>
<h1 id="heroku-and-memcache">Heroku and Memcache</h1>
<p>CouchBase offers a <a href="https://addons.heroku.com/memcache">free Heroku add-on</a>
that adds caching to your app. This will speed the loading process and relieve
some of the dyno&#8217;s workload.<sup id="fnref:1"><a href="#fn:1" rel="footnote">1</a></sup></p>
<p>To install it, just add the free <a href="https://addons.heroku.com/memcache">memcache</a> add-on
to your application using</p>
<div class="bogus-wrapper"><notextile><figure class="code"><figcaption><span></span></figcaption><div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
</pre></td><td class="code"><pre><code class="console"><span class="line"><span class="go">heroku addons:add memcache:5mb</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
<p>The free tier comew with 5 MB of space. As far as I know, it should be plenty of
room for a regular static website.</p>
<h1 id="setting-up-the-cache">Setting up the cache</h1>
<p>In your GemFile, you will have to add the following gems</p>
<div class="bogus-wrapper"><notextile><figure class="code"><figcaption><span></span></figcaption><div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ruby"><span class="line"><span class="n">gem</span> <span class="s2">&quot;dalli&quot;</span>
</span><span class="line"><span class="n">gem</span> <span class="s2">&quot;rack-cache&quot;</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
<p>These will allow you to access memcache from within your application, served
through <code>Sinatra</code>.</p>
<p>In your <code>config.ru</code> file, add <code>Dalli</code> and <code>Rack-Cache</code> as dependencies </p>
<div class="bogus-wrapper"><notextile><figure class="code"><figcaption><span></span></figcaption><div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
</pre></td><td class="code"><pre><code class="ruby"><span class="line"><span class="nb">require</span> <span class="s2">&quot;dalli&quot;</span>
</span><span class="line"><span class="nb">require</span> <span class="s2">&quot;rack-cache&quot;</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
<p>and configure <code>Rack-Cache</code> to use <code>Memcache</code> for storage</p>
<div class="bogus-wrapper"><notextile><figure class="code"><figcaption><span></span></figcaption><div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
</pre></td><td class="code"><pre><code class="ruby"><span class="line"><span class="k">if</span> <span class="n">memcache_servers</span> <span class="o">=</span> <span class="no">ENV</span><span class="o">[</span><span class="s2">&quot;MEMCACHE_SERVERS&quot;</span><span class="o">]</span>
</span><span class="line">  <span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Cache</span><span class="p">,</span>
</span><span class="line">    <span class="n">verbose</span><span class="p">:</span> <span class="kp">true</span><span class="p">,</span>
</span><span class="line">    <span class="n">metastore</span><span class="p">:</span>   <span class="s2">&quot;memcached://</span><span class="si">#{</span><span class="n">memcache_servers</span><span class="si">}</span><span class="s2">&quot;</span><span class="p">,</span>
</span><span class="line">    <span class="n">entitystore</span><span class="p">:</span> <span class="s2">&quot;memcached://</span><span class="si">#{</span><span class="n">memcache_servers</span><span class="si">}</span><span class="s2">&quot;</span>
</span><span class="line"><span class="k">end</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
<p>This will use Heroku&#8217;s <code>ENV</code> variables to set up the caching server.</p>
<p>Finally, add caching to Sinatra&#8217;s requests by adding the following code to
the <code>SinatraStaticServer</code> class before the routing definitions</p>
<div class="bogus-wrapper"><notextile><figure class="code"><figcaption><span></span></figcaption><div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
</pre></td><td class="code"><pre><code class="ruby"><span class="line"><span class="n">before</span> <span class="k">do</span>
</span><span class="line">  <span class="n">expires</span> <span class="mi">300</span><span class="p">,</span> <span class="ss">:public</span><span class="p">,</span> <span class="ss">:must_revalidate</span>
</span><span class="line"><span class="k">end</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
<p>This will set the <code>Expires</code> as well as the <code>Cache-Control</code> headers.</p>
<h1 id="rack-middlewares">Rack Middlewares</h1>
<p>I am also using two <code>Rack</code> middlewares to deliver the static content and to
allow <code>gzip</code> compression. Here is the code that I am using:</p>
<div class="bogus-wrapper"><notextile><figure class="code"><figcaption><span></span></figcaption><div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
</pre></td><td class="code"><pre><code class="ruby"><span class="line"><span class="c1"># Serves static content with specific max-age</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Static</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:urls</span> <span class="o">=&gt;</span> <span class="o">[</span><span class="s2">&quot;/assets&quot;</span><span class="p">,</span> <span class="s2">&quot;/images&quot;</span><span class="p">,</span> <span class="s2">&quot;/javascripts&quot;</span><span class="p">,</span> <span class="s2">&quot;/stylesheets&quot;</span><span class="p">,</span> <span class="s2">&quot;/media&quot;</span> <span class="o">]</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:root</span> <span class="o">=&gt;</span> <span class="s1">&#39;public&#39;</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:cache_control</span> <span class="o">=&gt;</span> <span class="s1">&#39;public, max-age=2592000&#39;</span>
</span><span class="line"><span class="c1"># Handles gzip compression</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Deflater</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
<p>As you notice, I set a <code>max-age</code> of one year for all static content, while
the rest of the site expires every five minutes.</p>
<h1 id="final-configuration">Final Configuration</h1>
<p>All together, my new config file looks like this:</p>
<div class="bogus-wrapper"><notextile><figure class="code"><figcaption><span>config.ru </span></figcaption>
<div class="highlight"><table><tr><td class="gutter"><pre class="line-numbers"><span class="line-number">1</span>
<span class="line-number">2</span>
<span class="line-number">3</span>
<span class="line-number">4</span>
<span class="line-number">5</span>
<span class="line-number">6</span>
<span class="line-number">7</span>
<span class="line-number">8</span>
<span class="line-number">9</span>
<span class="line-number">10</span>
<span class="line-number">11</span>
<span class="line-number">12</span>
<span class="line-number">13</span>
<span class="line-number">14</span>
<span class="line-number">15</span>
<span class="line-number">16</span>
<span class="line-number">17</span>
<span class="line-number">18</span>
<span class="line-number">19</span>
<span class="line-number">20</span>
<span class="line-number">21</span>
<span class="line-number">22</span>
<span class="line-number">23</span>
<span class="line-number">24</span>
<span class="line-number">25</span>
<span class="line-number">26</span>
<span class="line-number">27</span>
<span class="line-number">28</span>
<span class="line-number">29</span>
<span class="line-number">30</span>
<span class="line-number">31</span>
<span class="line-number">32</span>
<span class="line-number">33</span>
<span class="line-number">34</span>
<span class="line-number">35</span>
<span class="line-number">36</span>
<span class="line-number">37</span>
<span class="line-number">38</span>
<span class="line-number">39</span>
<span class="line-number">40</span>
<span class="line-number">41</span>
<span class="line-number">42</span>
<span class="line-number">43</span>
<span class="line-number">44</span>
<span class="line-number">45</span>
<span class="line-number">46</span>
<span class="line-number">47</span>
</pre></td><td class="code"><pre><code class="ruby"><span class="line"><span class="nb">require</span> <span class="s1">&#39;bundler/setup&#39;</span>
</span><span class="line"><span class="nb">require</span> <span class="s1">&#39;sinatra/base&#39;</span>
</span><span class="line"><span class="nb">require</span> <span class="s2">&quot;dalli&quot;</span>
</span><span class="line"><span class="nb">require</span> <span class="s2">&quot;rack-cache&quot;</span>
</span><span class="line">
</span><span class="line"><span class="c1"># Defined in ENV on Heroku.</span>
</span><span class="line"><span class="k">if</span> <span class="n">memcache_servers</span> <span class="o">=</span> <span class="no">ENV</span><span class="o">[</span><span class="s2">&quot;MEMCACHED_SERVERS&quot;</span><span class="o">]</span>
</span><span class="line">  <span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Cache</span><span class="p">,</span>
</span><span class="line">    <span class="n">verbose</span><span class="p">:</span> <span class="kp">true</span><span class="p">,</span>
</span><span class="line">    <span class="n">metastore</span><span class="p">:</span>   <span class="s2">&quot;memcached://</span><span class="si">#{</span><span class="n">memcache_servers</span><span class="si">}</span><span class="s2">&quot;</span><span class="p">,</span>
</span><span class="line">    <span class="n">entitystore</span><span class="p">:</span> <span class="s2">&quot;memcached://</span><span class="si">#{</span><span class="n">memcache_servers</span><span class="si">}</span><span class="s2">&quot;</span>
</span><span class="line"><span class="k">end</span>
</span><span class="line">
</span><span class="line"><span class="c1"># Serves static content with specific max-age</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Static</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:urls</span> <span class="o">=&gt;</span> <span class="o">[</span><span class="s2">&quot;/assets&quot;</span><span class="p">,</span> <span class="s2">&quot;/images&quot;</span><span class="p">,</span> <span class="s2">&quot;/javascripts&quot;</span><span class="p">,</span> <span class="s2">&quot;/stylesheets&quot;</span><span class="p">,</span> <span class="s2">&quot;/media&quot;</span> <span class="o">]</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:root</span> <span class="o">=&gt;</span> <span class="s1">&#39;public&#39;</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:cache_control</span> <span class="o">=&gt;</span> <span class="s1">&#39;public, max-age=2592000&#39;</span>
</span><span class="line"><span class="c1"># Handles gzip compression</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Deflater</span>
</span><span class="line">
</span><span class="line"><span class="c1"># The project root directory</span>
</span><span class="line"><span class="vg">$root</span> <span class="o">=</span> <span class="o">::</span><span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="bp">__FILE__</span><span class="p">)</span>
</span><span class="line">
</span><span class="line"><span class="k">class</span> <span class="nc">SinatraStaticServer</span> <span class="o">&lt;</span> <span class="no">Sinatra</span><span class="o">::</span><span class="no">Base</span>
</span><span class="line">
</span><span class="line">  <span class="n">before</span> <span class="k">do</span>
</span><span class="line">    <span class="n">expires</span> <span class="mi">300</span><span class="p">,</span> <span class="ss">:public</span><span class="p">,</span> <span class="ss">:must_revalidate</span>
</span><span class="line">  <span class="k">end</span>
</span><span class="line">
</span><span class="line">  <span class="n">get</span><span class="p">(</span><span class="sr">/.+/</span><span class="p">)</span> <span class="k">do</span>
</span><span class="line">    <span class="n">send_sinatra_file</span><span class="p">(</span><span class="n">request</span><span class="o">.</span><span class="n">path</span><span class="p">)</span> <span class="p">{</span><span class="mi">404</span><span class="p">}</span>
</span><span class="line">  <span class="k">end</span>
</span><span class="line">
</span><span class="line">  <span class="n">not_found</span> <span class="k">do</span>
</span><span class="line">    <span class="n">send_sinatra_file</span><span class="p">(</span><span class="s1">&#39;404.html&#39;</span><span class="p">)</span> <span class="p">{</span><span class="s2">&quot;Sorry, I cannot find </span><span class="si">#{</span><span class="n">request</span><span class="o">.</span><span class="n">path</span><span class="si">}</span><span class="s2">&quot;</span><span class="p">}</span>
</span><span class="line">  <span class="k">end</span>
</span><span class="line">
</span><span class="line">  <span class="k">def</span> <span class="nf">send_sinatra_file</span><span class="p">(</span><span class="n">path</span><span class="p">,</span> <span class="o">&amp;</span><span class="n">missing_file_block</span><span class="p">)</span>
</span><span class="line">    <span class="n">file_path</span> <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">join</span><span class="p">(</span><span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="bp">__FILE__</span><span class="p">),</span> <span class="s1">&#39;public&#39;</span><span class="p">,</span>  <span class="n">path</span><span class="p">)</span>
</span><span class="line">    <span class="n">file_path</span> <span class="o">=</span> <span class="no">File</span><span class="o">.</span><span class="n">join</span><span class="p">(</span><span class="n">file_path</span><span class="p">,</span> <span class="s1">&#39;index.html&#39;</span><span class="p">)</span> <span class="k">unless</span> <span class="n">file_path</span> <span class="o">=~</span> <span class="sr">/\.[a-z]+$/i</span>
</span><span class="line">    <span class="no">File</span><span class="o">.</span><span class="n">exist?</span><span class="p">(</span><span class="n">file_path</span><span class="p">)</span> <span class="p">?</span> <span class="n">send_file</span><span class="p">(</span><span class="n">file_path</span><span class="p">)</span> <span class="p">:</span> <span class="n">missing_file_block</span><span class="o">.</span><span class="n">call</span>
</span><span class="line">  <span class="k">end</span>
</span><span class="line">
</span><span class="line"><span class="k">end</span>
</span><span class="line">
</span><span class="line"><span class="n">run</span> <span class="no">SinatraStaticServer</span>
</span></code></pre></td></tr></table></div></figure></notextile></div>
<h1 id="conclusion">Conclusion</h1>
<p>This will aggressively cache all your content for the amount of time you prefer. This means that everything
on your static website will be delivered using cache when possible, reducing your dyno&#8217;s
workload. If you are using CloudFront, the content will be also cached on their end,
reducing even more the requests made to your website directly. Most recent browsers
also cache information locally, so returning visitors will make just a few requests
to your website.</p>
<p>Since I just started looking into caching my Octopress blog, I do not know if this
workaround is correct or if it is optimal to cache everything in Memcache. On this
matter, Heroku <a href="https://devcenter.heroku.com/articles/s3">suggests</a> to use
Amazon&#8217;s S3 to serve your assets, instead of MemCache. </p>
<p>Leave a comment below if you know of a better way to setup Sinatra, Dalli, and
Rack-Cache to serve a static Octopress blog.</p>
<div class="footnotes">
<ol>
<li id="fn:1">
<p>Many thanks to <a href="http://henrik.nyh.se/about/">Henrik</a> for his how-to on <a href="http://henrik.nyh.se/2012/07/sinatra-with-rack-cache-on-heroku/">Sinatra and Rack-Cache</a>.<a href="#fnref:1" rel="reference">&#8617;</a></p>