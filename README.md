

# Universal Binary Format and Bert-RPC #

Copyright (c) 2011-2014 by Joseph Wayne Norton

__Authors:__ Joseph Wayne Norton ([`norton@alum.mit.edu`](mailto:norton@alum.mit.edu)).
<p>This is UBF-BERTRPC, a framework for integrating UBF, EBF, and
Bert-RPC.  This repository depends on the UBF open source repository.</p>
<p><em>This repository is experimental in nature and intended for training
purposes.</em></p>

<h2 id="_quick_start_recipe">Quick Start Recipe</h2>

<p>To download, build, and test the ubf_bertrpc application in one shot,
please follow this recipe:</p>


<pre><code>$ mkdir working-directory-name
$ cd working-directory-name
$ git clone https://github.com/ubf/ubf-bertrpc.git ubf_bertrpc
$ cd ubf_bertrpc
$ make deps clean compile test</code></pre>




<h2 id="_documentation">Documentation</h2>


<h3 id="_where_should_i_start">Where should I start?</h3>
<p>This README is a good first step.</p>
<p>The UBF User's Guide is the best next step.  Check out
<a href="http://ubf.github.com/ubf/ubf-user-guide.en.html">http://ubf.github.com/ubf/ubf-user-guide.en.html</a> for further
detailed information.</p>
<p>Sample eunit tests can be found in the test/eunit directory.</p>


<h3 id="_what_is_ubf">What is UBF?</h3>
<p>UBF is the "Universal Binary Format", designed and implemented by Joe
Armstrong.  UBF is a language for transporting and describing complex
data structures across a network.  It has three components:</p>
<ul>
<li>
<p>
UBF(a) is a "language neutral" data transport format, roughly
  equivalent to well-formed XML.
</p>
</li>
<li>
<p>
UBF(b) is a programming language for describing types in UBF(a) and
  protocols between clients and servers.  This layer is typically
  called the "protocol contract".  UBF(b) is roughly equivalent to
  Verified XML, XML-schemas, SOAP and WDSL.
</p>
</li>
<li>
<p>
UBF(c) is a meta-level protocol used between a UBF client and a UBF
  server.
</p>
</li>
</ul>
<p>See <a href="http://ubf.github.com/ubf">http://ubf.github.com/ubf</a> for further details.</p>


<h3 id="_what_is_bert_rpc">What is Bert-RPC?</h3>
<p>Bert-RPC is a remote procedure call protocol.  See
<a href="http://bert-rpc.org/">http://bert-rpc.org/</a> for full details.</p>
<p>Bert-RPC is actually just a subset of UBF's binary network format
implementation known as "EBF".  The name "EBF" is short for "Erlang
Binary Format".</p>


<h3 id="_tools">Tools</h3>
<p>For further information and help for related tools, please refer to
the following links:</p>
<ul>
<li>
<p>
Erlang - <a href="http://www.erlang.org/">http://www.erlang.org/</a>
</p>
<ul>
<li>
<p>
<strong>R15B01 or newer, 17.0 has been tested most recently</strong>
</p>
</li>
</ul>
</li>
<li>
<p>
Git - <a href="http://git-scm.com/">http://git-scm.com/</a>
</p>
<ul>
<li>
<p>
<strong>Git 1.5.4 or newer, Git 1.9.3 has been tested most recently</strong>
</p>
</li>
</ul>
</li>
<li>
<p>
GitHub - <a href="https://github.com">https://github.com</a>
</p>
</li>
</ul>




<h2 id="_credits">Credits</h2>

<p>Many, many thanks to Joe Armstrong, UBF's designer and original
implementer.</p>
<p>Gemini Mobile Technologies, Inc. has approved the release of this
repository under an MIT license.</p>




## Modules ##


<table width="100%" border="0" summary="list of modules">
<tr><td><a href="https://github.com/ubf/ubf-bertrpc/blob/master/doc/bert.md" class="module">bert</a></td></tr>
<tr><td><a href="https://github.com/ubf/ubf-bertrpc/blob/master/doc/bert_driver.md" class="module">bert_driver</a></td></tr>
<tr><td><a href="https://github.com/ubf/ubf-bertrpc/blob/master/doc/ubf_bertrpc_plugin.md" class="module">ubf_bertrpc_plugin</a></td></tr></table>

