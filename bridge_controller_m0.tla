------------------------ MODULE bridge_controller_m0 ------------------------

\*TLC == Temporal Logic Checker
(*
- Extends is the same as "import".
- Everything in TLA is case sensitive
*)

EXTENDS Integers, Naturals, Sequences, TLC

\* Constant and axiom form the context (recall from 3342)

CONSTANT d, bound (* bound denotes the length of interleaving of events *)
AXIOM /\ d \in Nat
      /\ d > 0
      
\* Here we model the dynamic part of the module (the algorithm)
\* What is included within the algorithm (upon clicking the translate button) will be translated into the TLA state machine.

(*
--algorithm bridgeController_m0 {
  \*Variables need to all be declared here (cannot interleave variable declerations)
  variable n = 0, i = 0;
  
  procedure ML_out(){
    \* Can think of this as either the BAP, or just variable assignment.
    n := n + 1;
    return;
  }
  
  procedure ML_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    n := n - 1;
    return;
  }
  
  \* Main program
  {
    \* Number of iterations is equal to bound
    while(i < bound) {
        \* We use the "choice" operator to simulate the selection of event execution by some central controller
        either { 
            if(TRUE) { 
                call ML_out(); 
            }; 
        }
        or { 
            if(TRUE) { 
                call ML_in(); 
            }; 
        };
        i := i + 1;
    }
  }
  
}

*)

=============================================================================
\* Modification History
\* Last modified Sun Jan 22 20:55:31 EST 2023 by jorra04
\* Created Sun Jan 22 17:59:10 EST 2023 by jorra04
