%% @doc Protocol driver process for BERT protocol sessions.
%%
%% This driver automagically relies on the OTP +gen_tcp+ "packet"
%% feature, using a 4-byte prefix to specify the size of the data
%% coming from the client.  Similarly, this packet feature is used
%% when sending our reply back to the client.

-module(bert_driver).
-behaviour(contract_driver).

-export([start/1, start/2, init/1, init/2, encode/3, decode/4]).

start(Contract) ->
    start(Contract, []).

start(Contract, Options) ->
    proc_utils:spawn_link_debug(fun() -> contract_driver:start(?MODULE, Contract, Options) end, bert_client_driver).

init(Contract) ->
    init(Contract, []).

init(_Contract, Options) ->
    {Options, {init, undefined, undefined}}.

encode(_Contract, _Options, Term) ->
    erlang:term_to_binary(Term).

decode(_Contract, Options, {init, undefined, undefined}, Binary) ->
    {done, erlang:binary_to_term(Binary, Options), undefined, undefined}.
