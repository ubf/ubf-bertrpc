%%%----------------------------------------------------------------------
%%% File    : bertprc_plugin_sup.erl
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
    DefaultPlugins = proplists:get_value(plugins, Args, [ubf_bertprc_plugin]),

    CBBF = case proplists:get_value(test_bbf_tcp_port, Args, 0) of
               undefined ->
                   [];
               BBFPort ->
                   BBFMaxConn = proplists:get_value(test_bbf_maxconn, Args, DefaultMaxConn),
                   BBFIdleTimer = proplists:get_value(test_bbf_timeout, Args, DefaultTimeout),
                   BBFOptions = [{statelessrpc,true}                %% mandatory for bertprc
                                 , {startplugin,ubf_bertprc_plugin} %%          "
                                 , {serverhello,undefined}          %%          "
                                 , {simplerpc,true}                 %%          "
                                 , {proto,ebf}                      %%          "
                                 , {maxconn,BBFMaxConn}
                                 , {idletimer,BBFIdleTimer}
                                 , {registeredname,test_bbf_tcp_port}
                                ],
                   BBFServer =
                       {bbf_server, {ubf_server, start_link, [test_bbf, DefaultPlugins, BBFPort, BBFOptions]},
                        permanent, 2000, worker, [bbf_server]},

                   [BBFServer]
           end,

    {ok, {{one_for_one, 2, 60}, CBBF}}.

%%%----------------------------------------------------------------------
%%% Internal functions
%%%----------------------------------------------------------------------
