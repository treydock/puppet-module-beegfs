(*
Module: Test_BeeGFS_config
  Provides unit tests and examples for the <BeeGFS_config> lens.
*)

module Test_BeeGFS_config =

(* Variable: conf *)
let conf = "#
# --- Section 1.1: [Basic Settings] ---
#

sysMgmtdHost                  =

#
# --- Section 1.2: [Advanced Settings] ---
#

connInterfacesFile            = 
connMaxInternodeNum           = 12
connNetFilterFile             = /dne/file.txt

connUseRDMA                   = true
quotaEnabled                  = false
"

(* Test: BeeGFS_config.lns *)
test BeeGFS_config.lns get conf =
  { }
  { "#comment" = "--- Section 1.1: [Basic Settings] ---" }
  { }
  { }
  { "sysMgmtdHost" = "" { } }
  { }
  { }
  { "#comment" = "--- Section 1.2: [Advanced Settings] ---" }
  { }
  { }
  { "connInterfacesFile" = "" { } }
  { "connMaxInternodeNum" = "12" }
  { "connNetFilterFile" = "/dne/file.txt" }
  { }
  { "connUseRDMA" = "true" }
  { "quotaEnabled" = "false" }
