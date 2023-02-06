------------------------ MODULE bridge_controller_m1 ------------------------
EXTENDS Integers, Naturals, Sequences, TLC

\* Constant and axiom form the context (recall from 3342)

CONSTANT d, bound(* bound denotes the length of interleaving of events *)
AXIOM /\ d \in Nat
      /\ d > 0
      
\* Here we model the dynamic part of the module (the algorithm)
\* What is included within the algorithm (upon clicking the translate button) will be translated into the TLA state machine.

(*
--algorithm bridgeController_m1 {
  \*Variables need to all be declared here (cannot interleave variable declerations)
  variable a = 0, b = 0, c = 0, n = 0, i = 0;
  
  procedure ML_out(){
    \* Can think of this as either the BAP, or just variable assignment.
    ML_out_concrete_action: a := a + 1;
    ML_out_abstract_action: n := n + 1;
    return;
  }
  
  procedure ML_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    ML_in_concrete_action: c:= c - 1;
    ML_in_abstract_action: n := n - 1;
    return;
  }
  procedure IL_out(){
    \* Can think of this as either the BAP, or just variable assignment.
    IL_out_concrete_action_1: b := b - 1;
    IL_out_concrete_action_2: c := c + 1;
    return;
  }
  
  procedure IL_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    IL_in_concrete_action_1: a := a - 1;
    IL_in_concrete_action_2: b := b + 1;
    return;
  }
  
  \* Main program
  {
    \* Number of iterations is equal to bound
    loop: while(i < bound) {
        \* We use the "choice" operator to simulate the selection of event execution by some central controller
        choice: either { 
            ML_out_guard: if((a + b < d) /\ (c = 0)) { 
                call ML_out(); 
            }; 
        }
        or { 
            ML_in_guard: if(c > 0) { 
                call ML_in(); 
            }; 
        } 
        or { 
            IL_out_guard: if( (b > 0) /\ (a = 0) ) { 
                call IL_out(); 
            }; 
        }
        or { 
            IL_in_guard: if(a > 0) { 
                call IL_in(); 
            }; 
        };
        progress: i := i + 1;
    }
  }
  
}

*)
\* BEGIN TRANSLATION (chksum(pcal) = "7e200cc6" /\ chksum(tla) = "a6c1d83c")
VARIABLES a, b, c, n, i, pc, stack

vars == << a, b, c, n, i, pc, stack >>

Init == (* Global variables *)
        /\ a = 0
        /\ b = 0
        /\ c = 0
        /\ n = 0
        /\ i = 0
        /\ stack = << >>
        /\ pc = "loop"

ML_out_concrete_action == /\ pc = "ML_out_concrete_action"
                          /\ a' = a + 1
                          /\ pc' = "ML_out_abstract_action"
                          /\ UNCHANGED << b, c, n, i, stack >>

ML_out_abstract_action == /\ pc = "ML_out_abstract_action"
                          /\ n' = n + 1
                          /\ pc' = Head(stack).pc
                          /\ stack' = Tail(stack)
                          /\ UNCHANGED << a, b, c, i >>

ML_out == ML_out_concrete_action \/ ML_out_abstract_action

ML_in_concrete_action == /\ pc = "ML_in_concrete_action"
                         /\ c' = c - 1
                         /\ pc' = "ML_in_abstract_action"
                         /\ UNCHANGED << a, b, n, i, stack >>

ML_in_abstract_action == /\ pc = "ML_in_abstract_action"
                         /\ n' = n - 1
                         /\ pc' = Head(stack).pc
                         /\ stack' = Tail(stack)
                         /\ UNCHANGED << a, b, c, i >>

ML_in == ML_in_concrete_action \/ ML_in_abstract_action

IL_out_concrete_action_1 == /\ pc = "IL_out_concrete_action_1"
                            /\ b' = b - 1
                            /\ pc' = "IL_out_concrete_action_2"
                            /\ UNCHANGED << a, c, n, i, stack >>

IL_out_concrete_action_2 == /\ pc = "IL_out_concrete_action_2"
                            /\ c' = c + 1
                            /\ pc' = Head(stack).pc
                            /\ stack' = Tail(stack)
                            /\ UNCHANGED << a, b, n, i >>

IL_out == IL_out_concrete_action_1 \/ IL_out_concrete_action_2

IL_in_concrete_action_1 == /\ pc = "IL_in_concrete_action_1"
                           /\ a' = a - 1
                           /\ pc' = "IL_in_concrete_action_2"
                           /\ UNCHANGED << b, c, n, i, stack >>

IL_in_concrete_action_2 == /\ pc = "IL_in_concrete_action_2"
                           /\ b' = b + 1
                           /\ pc' = Head(stack).pc
                           /\ stack' = Tail(stack)
                           /\ UNCHANGED << a, c, n, i >>

IL_in == IL_in_concrete_action_1 \/ IL_in_concrete_action_2

loop == /\ pc = "loop"
        /\ IF i < bound
              THEN /\ pc' = "choice"
              ELSE /\ pc' = "Done"
        /\ UNCHANGED << a, b, c, n, i, stack >>

choice == /\ pc = "choice"
          /\ \/ /\ pc' = "ML_out_guard"
             \/ /\ pc' = "ML_in_guard"
             \/ /\ pc' = "IL_out_guard"
             \/ /\ pc' = "IL_in_guard"
          /\ UNCHANGED << a, b, c, n, i, stack >>

ML_out_guard == /\ pc = "ML_out_guard"
                /\ IF (a + b < d) /\ (c = 0)
                      THEN /\ stack' = << [ procedure |->  "ML_out",
                                            pc        |->  "progress" ] >>
                                        \o stack
                           /\ pc' = "ML_out_concrete_action"
                      ELSE /\ pc' = "progress"
                           /\ stack' = stack
                /\ UNCHANGED << a, b, c, n, i >>

ML_in_guard == /\ pc = "ML_in_guard"
               /\ IF c > 0
                     THEN /\ stack' = << [ procedure |->  "ML_in",
                                           pc        |->  "progress" ] >>
                                       \o stack
                          /\ pc' = "ML_in_concrete_action"
                     ELSE /\ pc' = "progress"
                          /\ stack' = stack
               /\ UNCHANGED << a, b, c, n, i >>

IL_out_guard == /\ pc = "IL_out_guard"
                /\ IF (b > 0) /\ (a = 0)
                      THEN /\ stack' = << [ procedure |->  "IL_out",
                                            pc        |->  "progress" ] >>
                                        \o stack
                           /\ pc' = "IL_out_concrete_action_1"
                      ELSE /\ pc' = "progress"
                           /\ stack' = stack
                /\ UNCHANGED << a, b, c, n, i >>

IL_in_guard == /\ pc = "IL_in_guard"
               /\ IF a > 0
                     THEN /\ stack' = << [ procedure |->  "IL_in",
                                           pc        |->  "progress" ] >>
                                       \o stack
                          /\ pc' = "IL_in_concrete_action_1"
                     ELSE /\ pc' = "progress"
                          /\ stack' = stack
               /\ UNCHANGED << a, b, c, n, i >>

progress == /\ pc = "progress"
            /\ i' = i + 1
            /\ pc' = "loop"
            /\ UNCHANGED << a, b, c, n, stack >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == ML_out \/ ML_in \/ IL_out \/ IL_in \/ loop \/ choice
           \/ ML_out_guard \/ ML_in_guard \/ IL_out_guard \/ IL_in_guard
           \/ progress
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

\* Adding Boolean properties for model checking invariants

inv1_1 == a \in Nat
inv1_2 == b \in Nat
inv1_3 == c \in Nat
inv1_4 == a + b + c = n
inv1_5 == \/ (a=0) \/ (c=0) 

\* Adding Boolean properties for model checking guard conditions for DLF

ML_out_event_guard == /\ (a + b < d) /\ (c = 0)
ML_in_event_guard == c > 0
IL_out_event_guard == /\ (b > 0) /\ (a = 0)
IL_in_event_guard == a > 0

deadlock_free == \/ ML_out_event_guard \/ ML_in_event_guard \/ IL_out_event_guard \/ IL_in_event_guard

=============================================================================
\* Modification History
\* Last modified Sun Feb 05 19:27:41 EST 2023 by jorra04
\* Created Fri Feb 03 20:23:32 EST 2023 by jorra04
