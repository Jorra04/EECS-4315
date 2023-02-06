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
    ML_out_action: n := n + 1;
    return;
  }
  
  procedure ML_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    ML_in_action: n := n - 1;
    return;
  }
  
  \* Main program
  {
    \* Number of iterations is equal to bound
    loop: while(i < bound) {
        \* We use the "choice" operator to simulate the selection of event execution by some central controller
        choice: either { 
            ML_out_guard: if(n < d) { 
                ML_out_occurs: call ML_out(); 
            }; 
        }
        or { 
            ML_in_guard: if(n > 0) { 
                ML_in_occurs: call ML_in(); 
            }; 
        };
        progress: i := i + 1;
    }
  }
  
}

*)
\* BEGIN TRANSLATION (chksum(pcal) = "d8d38596" /\ chksum(tla) = "6492b783")
VARIABLES n, i, pc, stack

vars == << n, i, pc, stack >>

Init == (* Global variables *)
        /\ n = 0
        /\ i = 0
        /\ stack = << >>
        /\ pc = "loop"

ML_out_action == /\ pc = "ML_out_action"
                 /\ n' = n + 1
                 /\ pc' = Head(stack).pc
                 /\ stack' = Tail(stack)
                 /\ i' = i

ML_out == ML_out_action

ML_in_action == /\ pc = "ML_in_action"
                /\ n' = n - 1
                /\ pc' = Head(stack).pc
                /\ stack' = Tail(stack)
                /\ i' = i

ML_in == ML_in_action

loop == /\ pc = "loop"
        /\ IF i < bound
              THEN /\ pc' = "choice"
              ELSE /\ pc' = "Done"
        /\ UNCHANGED << n, i, stack >>

choice == /\ pc = "choice"
          /\ \/ /\ pc' = "ML_out_guard"
             \/ /\ pc' = "ML_in_guard"
          /\ UNCHANGED << n, i, stack >>

ML_out_guard == /\ pc = "ML_out_guard"
                /\ IF n < d
                      THEN /\ pc' = "ML_out_occurs"
                      ELSE /\ pc' = "progress"
                /\ UNCHANGED << n, i, stack >>

ML_out_occurs == /\ pc = "ML_out_occurs"
                 /\ stack' = << [ procedure |->  "ML_out",
                                  pc        |->  "progress" ] >>
                              \o stack
                 /\ pc' = "ML_out_action"
                 /\ UNCHANGED << n, i >>

ML_in_guard == /\ pc = "ML_in_guard"
               /\ IF n > 0
                     THEN /\ pc' = "ML_in_occurs"
                     ELSE /\ pc' = "progress"
               /\ UNCHANGED << n, i, stack >>

ML_in_occurs == /\ pc = "ML_in_occurs"
                /\ stack' = << [ procedure |->  "ML_in",
                                 pc        |->  "progress" ] >>
                             \o stack
                /\ pc' = "ML_in_action"
                /\ UNCHANGED << n, i >>

progress == /\ pc = "progress"
            /\ i' = i + 1
            /\ pc' = "loop"
            /\ UNCHANGED << n, stack >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == ML_out \/ ML_in \/ loop \/ choice \/ ML_out_guard \/ ML_out_occurs
           \/ ML_in_guard \/ ML_in_occurs \/ progress
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
\* the == means 'defined as'
inv0_1 == n \in Nat
inv0_2 == n <= d

ML_out_event_guard == n < d
ML_in_event_guard == n > 0

deadlock_free == \/ ML_out_event_guard \/ ML_in_event_guard


=============================================================================
\* Modification History
\* Last modified Sun Feb 05 18:22:34 EST 2023 by jorra04
\* Created Sun Jan 22 17:59:10 EST 2023 by jorra04
