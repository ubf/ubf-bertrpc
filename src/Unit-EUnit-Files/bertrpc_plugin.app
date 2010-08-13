%%% -*- mode: erlang -*-
%%%

{application, bertprc_plugin,
 [
  {description, "BERTRPC_PLUGIN"},
  {vsn, "0.01"},
  {id, "BERTRPC_PLUGIN"},
  {modules, [
             %% TODO: fill in this list, perhaps
            ]
  },
  {registered, [ ] },
  %% NOTE: do not list applications which are load-only!
  {applications, [ kernel, stdlib, sasl ] },
  {mod, {bertprc_plugin_app, []} }
 ]
}.
