%%% -*- mode: erlang -*-
%%% @doc Sample BERT-RPC contract.
%%%
%%%

-module(ubf_bertrpc_plugin).
-behavior(ubf_plugin_stateless).

%% Required callback API for all UBF contract implementations.
-export([info/0, description/0, keepalive/0]).
-export([handlerStart/1, handlerStop/3, handlerRpc/1, handlerEvent/1]).

-import(ubf_plugin_handler, [sendEvent/2, install_handler/2]).

-compile({parse_transform,contract_parser}).
-add_contract("ubf_bertprc_plugin").

-include("ubf.hrl").

info() ->
    "I am a BERT-RPC server".

description() ->
    "A BERT-RPC server programmed by UBF".

keepalive() ->
    ok.


%% @spec handlerStart(Args::list(any())) ->
%%          {accept, Reply::any(), StateName::atom(), StateData::term()} | {reject, Reason::any()}
%% @doc start handler
handlerStart(_Args) ->
    ack = install_handler(self(), fun handlerEvent/1),
    {accept,ok,none,unused}.

%% @spec handlerStop(Pid::pid(), Reason::any(), StateData::term()) -> void()
%% @doc stop handler
handlerStop(_Pid, _Reason, _StateData) ->
    unused.


%% @spec handlerRpc(Event::any()) ->
%%          Reply::any()
%% @doc rpc handler
%% handlerRpc(Event) ->
%% @TODO Implement BERT-RPC 1.0 synchronous events
%% todo;
handlerRpc(Event)
  when Event==info; Event==description ->
    ?S(?MODULE:Event());
handlerRpc(Event)
  when Event==keepalive ->
    ?MODULE:Event();
handlerRpc(Event) ->
    {Event, not_implemented}.

handlerEvent(Event) ->
    %% @TODO: Implement BERT-RPC 1.0 asynchronous events
    %% Let's fake it and echo the request
    sendEvent(self(), Event),
    fun handlerEvent/1.
