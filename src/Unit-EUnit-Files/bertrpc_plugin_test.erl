-module(bertrpc_plugin_test).

-compile(export_all).
-include_lib("eunit/include/eunit.hrl").
-include("ubf.hrl").

do_eunit() ->
    case eunit:test({timeout,120,?MODULE}) of
        ok -> ok;
        _ -> erlang:halt(1)
    end.

-define(APPLICATION, bertprc_plugin).
-define(BBF_PORT, server_port(test_bbf_tcp_port)).

-define(SLEEP, 50).

-record(args, {host, port}).


%%%----------------------------------------------------------------------
%%% TESTS
%%%----------------------------------------------------------------------

all_tests_test_() ->
    all_tests_(fun () -> test_setup(?APPLICATION) end,
               fun (X) -> test_teardown(X) end
              ).

%%%----------------------------------------------------------------------
%%% API
%%%----------------------------------------------------------------------

all_tests_(Setup,Teardown) ->
    {setup,
     Setup,
     Teardown,
     (all_actual_tests_())(not_used)
    }.

all_actual_tests_() ->
    all_actual_tests_("localhost",fun() -> ?BBF_PORT end).

all_actual_tests_(Host,Port) ->
    fun(_) ->
            [?_test(test_001(#args{host=Host,port=Port()}))
             , ?_test(test_002(#args{host=Host,port=Port()}))
             , ?_test(test_003(#args{host=Host,port=Port()}))
             , ?_test(test_004(#args{host=Host,port=Port()}))
             , ?_test(test_005(#args{host=Host,port=Port()}))
             %% @TODO Implement BERT-RPC 1.0 tests
            ]
    end.

%%%----------------------------------------------------------------------
%%% Internal
%%%----------------------------------------------------------------------

test_setup(App) ->
    application:start(sasl),
    application:stop(App),
    ok = application:start(App),
    App.

test_teardown(App) ->
    application:stop(App),
    ok.

%% connect -> close
test_001(#args{host=Host,port=Port}) ->
    {ok,Sock} = gen_tcp:connect(Host,Port,[]),
    ok = gen_tcp:close(Sock).

%% connect -> shutdown(X) -> close
test_002(Args) ->
    test_002(Args,read),
    test_002(Args,write),
    test_002(Args,read_write).

test_002(#args{host=Host,port=Port},How) ->
    {ok,Sock} = gen_tcp:connect(Host,Port,[]),
    ok = gen_tcp:shutdown(Sock, How),
    ok = gen_tcp:close(Sock).

%% 'synchronous' keepalive
test_003(#args{}=Args) ->
    {ok,Pid1} = client_connect(Args),
    {reply,ok} = client_rpc(Pid1,keepalive),
    client_stop(Pid1).

%% 'asynchronous' keepalive -> echo 'asynchronous' keepalive
test_004(#args{}=Args) ->
    {ok,Pid1} = client_connect(Args),

    Ref = client_install_single_callback(Pid1),
    ok = client_event(Pid1, keepalive),
    keepalive = client_expect_callback(Pid1, Ref),

    client_stop(Pid1).



%%%----------------------------------------------------------------------
%%% Helpers
%%%----------------------------------------------------------------------

server_port(Name) ->
    case proc_socket_server:server_port(Name) of
        Port when is_integer(Port) ->
            Port;
        _ ->
            timer:sleep(10),
            server_port(Name)
    end.

client_connect(#args{host=Host,port=Port}) ->
    Options = [{proto,ebf},{serverlessrpc,true},{serverhello,undefined},{simplerpc,true}],
    {ok,Pid,undefined} = ubf_client:connect(Host,Port,Options,infinity),
    {ok,Pid}.

client_rpc(X,Y) ->
    client_rpc(X,Y,infinity).

client_rpc(Pid,Args,Timeout) ->
    ubf_client:rpc(Pid,Args,Timeout).

client_event(Pid,Msg) ->
    ubf_client:sendEvent(Pid, Msg).

client_install_single_callback(Pid) ->
    Caller = self(),
    Ref = {Pid, make_ref()},
    Fun = fun(Msg) -> Caller ! {Ref, Msg}, ubf_client:install_default_handler(Pid) end,
    ack = ubf_client:install_handler(Pid, Fun),
    Ref.

client_expect_callback(_Pid, Ref) ->
    receive {Ref, Msg} -> Msg end.

client_stop(Pid) ->
    ubf_client:stop(Pid).
