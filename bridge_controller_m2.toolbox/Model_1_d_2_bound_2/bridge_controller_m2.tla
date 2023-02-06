------------------------ MODULE bridge_controller_m2 ------------------------
EXTENDS Integers, Naturals, Sequences, TLC

\* Constant and axiom form the context (recall from 3342)

CONSTANT d, COLOR, bound, green, red (* bound denotes the length of interleaving of events *)
AXIOM /\ d \in Nat
      /\ d > 0
      /\ COLOR = {green, red}
      /\ green /= red
      
\* Here we model the dynamic part of the module (the algorithm)
\* What is included within the algorithm (upon clicking the translate button) will be translated into the TLA state machine.

(*
--algorithm bridgeController_m1 {
  \*Variables need to all be declared here (cannot interleave variable declerations)
  variable a = 0, b = 0, c = 0, ml_tl = red, il_tl = red, ml_pass = 1, il_pass = 1, n = 0, i = 0;
  
  procedure ML_tl_green(){
    \* Can think of this as either the BAP, or just variable assignment.
    ML_tl_green_action: ml_tl := green;
    il_tl := red;
    ml_pass := 0;
    return;
  }
  
  procedure IL_tl_green(){
    \* Can think of this as either the BAP, or just variable assignment.
    IL_tl_green_action: il_tl := green;
    ml_tl := red;
    il_pass := 0;
    return;
  }
  
  procedure ML_out_1(){
    \* Can think of this as either the BAP, or just variable assignment.
    ML_out_1_action: a := a + 1;
    n := n + 1;
    ml_pass := 1;
    return;
  }
  
  procedure ML_out_2(){
    \* Can think of this as either the BAP, or just variable assignment.
    ML_out_2_action: a := a + 1;
    n := n + 1;
    ml_tl := red;
    ml_pass := 1;
    return;
  }
  
  procedure ML_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    ML_in_action: c:= c - 1;
    n := n - 1;
    return;
  }
  
  procedure IL_out_1(){
    \* Can think of this as either the BAP, or just variable assignment.
    IL_out_1_action: b := b - 1;
    c := c + 1;
    il_pass := 1;
    return;
  }
  
  procedure IL_out_2(){
    \* Can think of this as either the BAP, or just variable assignment.
    IL_out_2_action: b := b - 1;
    c := c + 1;
    il_pass := 1;
    il_tl := red;
    return;
  }
  
  procedure IL_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    IL_in_action: a := a - 1;
    b := b + 1;
    return;
  }
  
  \* Main program
  {
    \* Number of iterations is equal to bound
    loop: while(i < bound) {
        \* We use the "choice" operator to simulate the selection of event execution by some central controller
        either { 
            ML_out_1_guard_condition: if((ml_tl = green) /\ ((a + b + 1) /= d)) { 
                call ML_out_1(); 
            }; 
        }
        or { 
            ML_out_2_guard_condition: if((ml_tl = green) /\ ((a + b + 1) = d)) { 
                call ML_out_2(); 
            }; 
        } 
        or { 
            ML_in_guard_condition: if(c > 0) { 
                call ML_in(); 
            }; 
        } 
        or { 
            IL_out_1_in_guard_condition: if( (il_tl = green) /\ (b /= 1) ) { 
                call IL_out_1(); 
            }; 
        }
        or { 
            IL_out_2_in_guard_condition: if( (il_tl = green) /\ (b = 1) ) { 
                call IL_out_2(); 
            }; 
        }
        or { 
            IL_in_guard_condition: if(a > 0) { 
                call IL_in(); 
            }; 
        }
        or { 
            IL_tl_green_guard_condition: if((il_tl = red ) /\ ( b > 0 ) /\ ( a = 0 ) /\ ( ml_pass = 1 )) { 
                call IL_tl_green(); 
            }; 
        }
        or { 
            ML_tl_green_guard_condition: if((ml_tl = red ) /\ ( (a + b) < d ) /\ ( c = 0 ) /\ ( il_pass = 1 )) { 
                call ML_tl_green(); 
            }; 
        };
        progress: i := i + 1;
    }
  }
  
}

*)
\* BEGIN TRANSLATION (chksum(pcal) = "3c7b1d29" /\ chksum(tla) = "7b53c501")
VARIABLES a, b, c, ml_tl, il_tl, ml_pass, il_pass, n, i, pc, stack

vars == << a, b, c, ml_tl, il_tl, ml_pass, il_pass, n, i, pc, stack >>

Init == (* Global variables *)
        /\ a = 0
        /\ b = 0
        /\ c = 0
        /\ ml_tl = red
        /\ il_tl = red
        /\ ml_pass = 1
        /\ il_pass = 1
        /\ n = 0
        /\ i = 0
        /\ stack = << >>
        /\ pc = "loop"

ML_tl_green_action == /\ pc = "ML_tl_green_action"
                      /\ ml_tl' = green
                      /\ il_tl' = red
                      /\ ml_pass' = 0
                      /\ pc' = Head(stack).pc
                      /\ stack' = Tail(stack)
                      /\ UNCHANGED << a, b, c, il_pass, n, i >>

ML_tl_green == ML_tl_green_action

IL_tl_green_action == /\ pc = "IL_tl_green_action"
                      /\ il_tl' = green
                      /\ ml_tl' = red
                      /\ il_pass' = 0
                      /\ pc' = Head(stack).pc
                      /\ stack' = Tail(stack)
                      /\ UNCHANGED << a, b, c, ml_pass, n, i >>

IL_tl_green == IL_tl_green_action

ML_out_1_action == /\ pc = "ML_out_1_action"
                   /\ a' = a + 1
                   /\ n' = n + 1
                   /\ ml_pass' = 1
                   /\ pc' = Head(stack).pc
                   /\ stack' = Tail(stack)
                   /\ UNCHANGED << b, c, ml_tl, il_tl, il_pass, i >>

ML_out_1 == ML_out_1_action

ML_out_2_action == /\ pc = "ML_out_2_action"
                   /\ a' = a + 1
                   /\ n' = n + 1
                   /\ ml_tl' = red
                   /\ ml_pass' = 1
                   /\ pc' = Head(stack).pc
                   /\ stack' = Tail(stack)
                   /\ UNCHANGED << b, c, il_tl, il_pass, i >>

ML_out_2 == ML_out_2_action

ML_in_action == /\ pc = "ML_in_action"
                /\ c' = c - 1
                /\ n' = n - 1
                /\ pc' = Head(stack).pc
                /\ stack' = Tail(stack)
                /\ UNCHANGED << a, b, ml_tl, il_tl, ml_pass, il_pass, i >>

ML_in == ML_in_action

IL_out_1_action == /\ pc = "IL_out_1_action"
                   /\ b' = b - 1
                   /\ c' = c + 1
                   /\ il_pass' = 1
                   /\ pc' = Head(stack).pc
                   /\ stack' = Tail(stack)
                   /\ UNCHANGED << a, ml_tl, il_tl, ml_pass, n, i >>

IL_out_1 == IL_out_1_action

IL_out_2_action == /\ pc = "IL_out_2_action"
                   /\ b' = b - 1
                   /\ c' = c + 1
                   /\ il_pass' = 1
                   /\ il_tl' = red
                   /\ pc' = Head(stack).pc
                   /\ stack' = Tail(stack)
                   /\ UNCHANGED << a, ml_tl, ml_pass, n, i >>

IL_out_2 == IL_out_2_action

IL_in_action == /\ pc = "IL_in_action"
                /\ a' = a - 1
                /\ b' = b + 1
                /\ pc' = Head(stack).pc
                /\ stack' = Tail(stack)
                /\ UNCHANGED << c, ml_tl, il_tl, ml_pass, il_pass, n, i >>

IL_in == IL_in_action

loop == /\ pc = "loop"
        /\ IF i < bound
              THEN /\ \/ /\ pc' = "ML_out_1_guard_condition"
                      \/ /\ pc' = "ML_out_2_guard_condition"
                      \/ /\ pc' = "ML_in_guard_condition"
                      \/ /\ pc' = "IL_out_1_in_guard_condition"
                      \/ /\ pc' = "IL_out_2_in_guard_condition"
                      \/ /\ pc' = "IL_in_guard_condition"
                      \/ /\ pc' = "IL_tl_green_guard_condition"
                      \/ /\ pc' = "ML_tl_green_guard_condition"
              ELSE /\ pc' = "Done"
        /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, il_pass, n, i, stack >>

progress == /\ pc = "progress"
            /\ i' = i + 1
            /\ pc' = "loop"
            /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, il_pass, n, stack >>

ML_out_1_guard_condition == /\ pc = "ML_out_1_guard_condition"
                            /\ IF (ml_tl = green) /\ ((a + b + 1) /= d)
                                  THEN /\ stack' = << [ procedure |->  "ML_out_1",
                                                        pc        |->  "progress" ] >>
                                                    \o stack
                                       /\ pc' = "ML_out_1_action"
                                  ELSE /\ pc' = "progress"
                                       /\ stack' = stack
                            /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                            il_pass, n, i >>

ML_out_2_guard_condition == /\ pc = "ML_out_2_guard_condition"
                            /\ IF (ml_tl = green) /\ ((a + b + 1) = d)
                                  THEN /\ stack' = << [ procedure |->  "ML_out_2",
                                                        pc        |->  "progress" ] >>
                                                    \o stack
                                       /\ pc' = "ML_out_2_action"
                                  ELSE /\ pc' = "progress"
                                       /\ stack' = stack
                            /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                            il_pass, n, i >>

ML_in_guard_condition == /\ pc = "ML_in_guard_condition"
                         /\ IF c > 0
                               THEN /\ stack' = << [ procedure |->  "ML_in",
                                                     pc        |->  "progress" ] >>
                                                 \o stack
                                    /\ pc' = "ML_in_action"
                               ELSE /\ pc' = "progress"
                                    /\ stack' = stack
                         /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                         il_pass, n, i >>

IL_out_1_in_guard_condition == /\ pc = "IL_out_1_in_guard_condition"
                               /\ IF (il_tl = green) /\ (b /= 1)
                                     THEN /\ stack' = << [ procedure |->  "IL_out_1",
                                                           pc        |->  "progress" ] >>
                                                       \o stack
                                          /\ pc' = "IL_out_1_action"
                                     ELSE /\ pc' = "progress"
                                          /\ stack' = stack
                               /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                               il_pass, n, i >>

IL_out_2_in_guard_condition == /\ pc = "IL_out_2_in_guard_condition"
                               /\ IF (il_tl = green) /\ (b = 1)
                                     THEN /\ stack' = << [ procedure |->  "IL_out_2",
                                                           pc        |->  "progress" ] >>
                                                       \o stack
                                          /\ pc' = "IL_out_2_action"
                                     ELSE /\ pc' = "progress"
                                          /\ stack' = stack
                               /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                               il_pass, n, i >>

IL_in_guard_condition == /\ pc = "IL_in_guard_condition"
                         /\ IF a > 0
                               THEN /\ stack' = << [ procedure |->  "IL_in",
                                                     pc        |->  "progress" ] >>
                                                 \o stack
                                    /\ pc' = "IL_in_action"
                               ELSE /\ pc' = "progress"
                                    /\ stack' = stack
                         /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                         il_pass, n, i >>

IL_tl_green_guard_condition == /\ pc = "IL_tl_green_guard_condition"
                               /\ IF (il_tl = red ) /\ ( b > 0 ) /\ ( a = 0 ) /\ ( ml_pass = 1 )
                                     THEN /\ stack' = << [ procedure |->  "IL_tl_green",
                                                           pc        |->  "progress" ] >>
                                                       \o stack
                                          /\ pc' = "IL_tl_green_action"
                                     ELSE /\ pc' = "progress"
                                          /\ stack' = stack
                               /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                               il_pass, n, i >>

ML_tl_green_guard_condition == /\ pc = "ML_tl_green_guard_condition"
                               /\ IF (ml_tl = red ) /\ ( (a + b) < d ) /\ ( c = 0 ) /\ ( il_pass = 1 )
                                     THEN /\ stack' = << [ procedure |->  "ML_tl_green",
                                                           pc        |->  "progress" ] >>
                                                       \o stack
                                          /\ pc' = "ML_tl_green_action"
                                     ELSE /\ pc' = "progress"
                                          /\ stack' = stack
                               /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, 
                                               il_pass, n, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == ML_tl_green \/ IL_tl_green \/ ML_out_1 \/ ML_out_2 \/ ML_in
           \/ IL_out_1 \/ IL_out_2 \/ IL_in \/ loop \/ progress
           \/ ML_out_1_guard_condition \/ ML_out_2_guard_condition
           \/ ML_in_guard_condition \/ IL_out_1_in_guard_condition
           \/ IL_out_2_in_guard_condition \/ IL_in_guard_condition
           \/ IL_tl_green_guard_condition \/ ML_tl_green_guard_condition
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
\* Adding Boolean properties for model checking invariants
inv2_1 == ml_tl \in COLOR
inv2_2 == il_tl \in COLOR
inv2_3 == ml_tl = green => /\ (a + b < d) /\ c = 0
inv2_4 == il_tl = green => /\ (b > 0) /\ a = 0
inv2_5 == \/ (ml_tl = red) \/ (il_tl  = red)
inv2_6 == ml_pass \in {0,1}
inv2_7 == il_pass \in {0,1}
inv2_8 == (ml_tl = red) => (ml_pass = 1)
inv2_9 == (il_tl = red) => (il_pass = 1)

\* Adding Boolean properties for model checking guard conditions for DLF

ML_out_1_event_guard == /\ (ml_tl = green) /\ ((a + b + 1) /= d)
ML_out_2_event_guard == /\ (ml_tl = green) /\ ((a + b + 1) = d)

IL_out_1_event_guard == /\ (il_tl = green) /\ (b /= 1)
IL_out_2_event_guard == /\ (il_tl = green) /\ (b = 1)

ML_in_event_guard == c > 0
IL_in_event_guard == a > 0

ML_tl_green_event_guard == /\ (ml_tl = red ) /\ ( (a + b) < d ) /\ ( c = 0 ) /\ ( il_pass = 1 )
IL_tl_green_event_guard == /\ (il_tl = red ) /\ ( b > 0 ) /\ ( a = 0 ) /\ ( ml_pass = 1 )

deadlock_free == \/ ML_out_1_event_guard \/ ML_out_2_event_guard \/ IL_out_1_event_guard 
\/ IL_out_2_event_guard \/ ML_in_event_guard \/ IL_in_event_guard \/ ML_tl_green_event_guard \/ IL_tl_green_event_guard



=============================================================================
\* Modification History
\* Last modified Sun Feb 05 19:52:04 EST 2023 by jorra04
\* Created Fri Feb 03 21:43:59 EST 2023 by jorra04
