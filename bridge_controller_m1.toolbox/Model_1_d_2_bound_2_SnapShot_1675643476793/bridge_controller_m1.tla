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
    a := a + 1;
    n := n + 1;
    return;
  }
  
  procedure ML_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    c:= c - 1;
    n := n - 1;
    return;
  }
  procedure IL_out(){
    \* Can think of this as either the BAP, or just variable assignment.
    b := b - 1;
    c := c + 1;
    return;
  }
  
  procedure IL_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    a := a - 1;
    b := b + 1;
    return;
  }
  
  \* Main program
  {
    \* Number of iterations is equal to bound
    while(i < bound) {
        \* We use the "choice" operator to simulate the selection of event execution by some central controller
        either { 
            if((a + b < d) /\ (c = 0)) { 
                call ML_out(); 
            }; 
        }
        or { 
            if(c > 0) { 
                call ML_in(); 
            }; 
        } 
        or { 
            if( (b > 0) /\ (a = 0) ) { 
                call IL_out(); 
            }; 
        }
        or { 
            if(a > 0) { 
                call IL_in(); 
            }; 
        };
        i := i + 1;
    }
  }
  
}

*)
\* BEGIN TRANSLATION (chksum(pcal) = "cf0a4652" /\ chksum(tla) = "bead2927")
VARIABLES a, b, c, n, i, pc, stack

vars == << a, b, c, n, i, pc, stack >>

Init == (* Global variables *)
        /\ a = 0
        /\ b = 0
        /\ c = 0
        /\ n = 0
        /\ i = 0
        /\ stack = << >>
        /\ pc = "Lbl_5"

Lbl_1 == /\ pc = "Lbl_1"
         /\ a' = a + 1
         /\ n' = n + 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << b, c, i >>

ML_out == Lbl_1

Lbl_2 == /\ pc = "Lbl_2"
         /\ c' = c - 1
         /\ n' = n - 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << a, b, i >>

ML_in == Lbl_2

Lbl_3 == /\ pc = "Lbl_3"
         /\ b' = b - 1
         /\ c' = c + 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << a, n, i >>

IL_out == Lbl_3

Lbl_4 == /\ pc = "Lbl_4"
         /\ a' = a - 1
         /\ b' = b + 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << c, n, i >>

IL_in == Lbl_4

Lbl_5 == /\ pc = "Lbl_5"
         /\ IF i < bound
               THEN /\ \/ /\ IF (a + b < d) /\ (c = 0)
                                THEN /\ stack' = << [ procedure |->  "ML_out",
                                                      pc        |->  "Lbl_6" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_1"
                                ELSE /\ pc' = "Lbl_6"
                                     /\ stack' = stack
                       \/ /\ IF c > 0
                                THEN /\ stack' = << [ procedure |->  "ML_in",
                                                      pc        |->  "Lbl_6" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_2"
                                ELSE /\ pc' = "Lbl_6"
                                     /\ stack' = stack
                       \/ /\ IF (b > 0) /\ (a = 0)
                                THEN /\ stack' = << [ procedure |->  "IL_out",
                                                      pc        |->  "Lbl_6" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_3"
                                ELSE /\ pc' = "Lbl_6"
                                     /\ stack' = stack
                       \/ /\ IF a > 0
                                THEN /\ stack' = << [ procedure |->  "IL_in",
                                                      pc        |->  "Lbl_6" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_4"
                                ELSE /\ pc' = "Lbl_6"
                                     /\ stack' = stack
               ELSE /\ pc' = "Done"
                    /\ stack' = stack
         /\ UNCHANGED << a, b, c, n, i >>

Lbl_6 == /\ pc = "Lbl_6"
         /\ i' = i + 1
         /\ pc' = "Lbl_5"
         /\ UNCHANGED << a, b, c, n, stack >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == ML_out \/ ML_in \/ IL_out \/ IL_in \/ Lbl_5 \/ Lbl_6
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
\* Last modified Sun Feb 05 19:30:36 EST 2023 by jorra04
\* Created Fri Feb 03 20:23:32 EST 2023 by jorra04
