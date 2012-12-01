---
layout: post
title: "Cache Octopress with Memcachier"
date: 2012-10-28 12:30
comments: true
tags: ["Octopress", "Cache"]
keywords: "octopress, cache, memcachier, memcached, cache"
---

<p>In my <a href="/2012/10/21/supercharge-octopress-with-rack-cache/">previous post</a>,
I described how I was able to setup <code>Rail-Cache</code> for my Octopress blog. Since
<a href="https://addons.heroku.com/memcache">Memcache</a> does not have a web interface and
Cloud9 blocks the connection to Heroku&#8217;s console, it was almost impossible to
flush the cache. </p>
<p>I decided to switch to <a href="https://addons.heroku.com/memcachier">Memcachier</a>, which
comes with free 25 MB of cache and a handy interface to check out usage and to
flush the cache.</p>
<h1 id="transfer-from-memcache-to-memcachier">Transfer from Memcache to Memcachier</h1>
<p>As advertised on Memcachier&#8217;s <a href="https://devcenter.heroku.com/articles/memcachier#switching-from-the-memcache-addon">help page</a>,
switching to Memcachier should (and it is) a piece of cake.</p>
<h2 id="fix-your-gemfile">Fix your GemFile</h2>
<p>The first thing to do is to update your <code>GemFile</code>. Just add the Memcachier
gem <code>gem 'memcachier'</code> and use <code>bundle install</code> to compile your <code>Gemfile.lock</code></p>
<h2 id="update-your-configru-file">Update your config.ru file</h2>
<p>After that, just add <code>require "memcachier"</code> to your <code>config.ru</code> file, and
change <code>ENV["MEMCACHED_SERVERS"]</code> to <code>ENV["MEMCACHIER_SERVERS"]</code> in <code>Rack::Cache</code>&#8217;s definition.</p>
<p>And you are done.</p>
<h1 id="final-configru">Final config.ru</h1>
<p>Here is my final <code>config.ru</code></p>
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
<span class="line-number">48</span>
</pre></td><td class="code"><pre><code class="ruby"><span class="line"><span class="nb">require</span> <span class="s1">&#39;bundler/setup&#39;</span>
</span><span class="line"><span class="nb">require</span> <span class="s1">&#39;sinatra/base&#39;</span>
</span><span class="line"><span class="nb">require</span> <span class="s2">&quot;dalli&quot;</span>
</span><span class="line"><span class="nb">require</span> <span class="s2">&quot;rack-cache&quot;</span>
</span><span class="line"><span class="nb">require</span> <span class="s2">&quot;memcachier&quot;</span>
</span><span class="line">
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">ContentLength</span>   <span class="c1"># Set Content-Length on string bodies</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">ETag</span>            <span class="c1"># Set E-Tags on string bodies</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">ConditionalGet</span>  <span class="c1"># If-Modified-Since</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Deflater</span>        <span class="c1"># Compress HTML using deflate / gzip</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Head</span>            <span class="c1"># Head requests must return an empty body</span>
</span><span class="line"><span class="k">if</span> <span class="n">memcache_servers</span> <span class="o">=</span> <span class="no">ENV</span><span class="o">[</span><span class="s2">&quot;MEMCACHIER_SERVERS&quot;</span><span class="o">]</span>     <span class="c1"># Defined in ENV on Heroku</span>
</span><span class="line">  <span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Cache</span><span class="p">,</span>        <span class="c1"># Uses MemCachier to cache requests</span>
</span><span class="line">    <span class="n">verbose</span><span class="p">:</span> <span class="kp">true</span><span class="p">,</span>
</span><span class="line">    <span class="n">metastore</span><span class="p">:</span>   <span class="s2">&quot;memcached://</span><span class="si">#{</span><span class="n">memcache_servers</span><span class="si">}</span><span class="s2">&quot;</span><span class="p">,</span>
</span><span class="line">    <span class="n">entitystore</span><span class="p">:</span> <span class="s2">&quot;memcached://</span><span class="si">#{</span><span class="n">memcache_servers</span><span class="si">}</span><span class="s2">&quot;</span>
</span><span class="line"><span class="k">end</span>
</span><span class="line"><span class="n">use</span> <span class="no">Rack</span><span class="o">::</span><span class="no">Static</span><span class="p">,</span>         <span class="c1"># Serves static content with specific max-age</span>
</span><span class="line">  <span class="ss">:urls</span> <span class="o">=&gt;</span> <span class="o">[</span><span class="s2">&quot;/assets&quot;</span><span class="p">,</span> <span class="s2">&quot;/images&quot;</span><span class="p">,</span> <span class="s2">&quot;/fonts&quot;</span> <span class="p">,</span><span class="s2">&quot;/javascripts&quot;</span><span class="p">,</span> <span class="s2">&quot;/stylesheets&quot;</span><span class="p">,</span> <span class="s2">&quot;/media&quot;</span> <span class="p">,</span> <span class="s2">&quot;/favicon.ico&quot;</span><span class="o">]</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:root</span> <span class="o">=&gt;</span> <span class="s1">&#39;public&#39;</span><span class="p">,</span>
</span><span class="line">  <span class="ss">:cache_control</span> <span class="o">=&gt;</span> <span class="s1">&#39;public, max-age=2592000&#39;</span>
</span><span class="line">
</span><span class="line"><span class="c1"># The project root directory</span>
</span><span class="line"><span class="vg">$root</span> <span class="o">=</span> <span class="o">::</span><span class="no">File</span><span class="o">.</span><span class="n">dirname</span><span class="p">(</span><span class="bp">__FILE__</span><span class="p">)</span>
</span><span class="line">
</span><span class="line"><span class="k">class</span> <span class="nc">SinatraStaticServer</span> <span class="o">&lt;</span> <span class="no">Sinatra</span><span class="o">::</span><span class="no">Base</span>
</span><span class="line">
</span><span class="line">  <span class="n">before</span> <span class="k">do</span>
</span><span class="line">    <span class="n">expires</span> <span class="mi">3600</span><span class="p">,</span> <span class="ss">:public</span><span class="p">,</span> <span class="ss">:must_revalidate</span>
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
<p>This setup will allow you to use <code>Memcachier</code> to store your cache. With 25 MB
of free storage, you will have five times the space provided by <code>Memcache</code>,
at the same great price of $0.</p>