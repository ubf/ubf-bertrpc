%%%----------------------------------------------------------------------
%%% File    : bertrpc_plugin_sup.erl
%%% Purpose : test UBF top-level supervisor
%%%----------------------------------------------------------------------

-module(bertrpc_plugin_sup).

-behaviour(supervisor).

%% External exports
-export([start_link/1]).

%% supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%----------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------
start_link(_Args) ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%----------------------------------------------------------------------
%%% Callback functions from supervisor
%%%----------------------------------------------------------------------

%%----------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}
%%----------------------------------------------------------------------
%% @spec(Args::term()) -> {ok, {supervisor_flags(), child_spec_list()}}
%% @doc The main TEST UBF supervisor.

init(Args) ->
    %% seq_trace:set_token(send, true), seq_trace:set_token('receive', true),

    %% Child_spec = [Name, {M, F, A},
    %%               Restart, Shutdown_time, Type, Modules_used]

    DefaultMaxConn = 10000,
    DefaultTimeout = 60000,
    DefaultPlugins = proplists:get_value(plugins, Args, [ubf_bertrpc_plugin]),

    CBERT = case proplists:get_value(test_bert_tcp_port, Args, 0) of
                undefined ->
                    [];
                BERTPort ->
                    BERTMaxConn = proplists:get_value(test_bert_maxconn, Args, DefaultMaxConn),
                    BERTIdleTimer = proplists:get_value(test_bert_timeout, Args, DefaultTimeout),
                    BERTOptions = [{statelessrpc,true}                %% mandatory for bertrpc
                                   , {startplugin,ubf_bertrpc_plugin} %%          "
                                   , {serverhello,undefined}          %%          "
                                   , {simplerpc,true}                 %%          "
                                   , {proto,bert}                     %%          "
                                   , {maxconn,BERTMaxConn}
                                   , {idletimer,BERTIdleTimer}
                                   , {registeredname,test_bert_tcp_port}
                                  ],
                    BERTServer =
                        {bert_server, {ubf_server, start_link, [test_bert, DefaultPlugins, BERTPort, BERTOptions]},
                         permanent, 2000, worker, [bert_server]},

                    [BERTServer]
            end,

    {ok, {{one_for_one, 2, 60}, CBERT}}.

%%%----------------------------------------------------------------------
%%% Internal functions
%%%----------------------------------------------------------------------
