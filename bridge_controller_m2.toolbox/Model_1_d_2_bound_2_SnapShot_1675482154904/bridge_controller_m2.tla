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
    ml_tl := green;
    il_tl := red;
    ml_pass := 0;
    return;
  }
  
  procedure IL_tl_green(){
    \* Can think of this as either the BAP, or just variable assignment.
    il_tl := green;
    ml_tl := red;
    il_pass := 0;
    return;
  }
  
  procedure ML_out_1(){
    \* Can think of this as either the BAP, or just variable assignment.
    a := a + 1;
    n := n + 1;
    ml_pass := 1;
    return;
  }
  
  procedure ML_out_2(){
    \* Can think of this as either the BAP, or just variable assignment.
    a := a + 1;
    n := n + 1;
    ml_tl := red;
    ml_pass := 1;
    return;
  }
  
  procedure ML_in(){
    \* Can think of this as either the BAP, or just variable assignment.
    c:= c - 1;
    n := n - 1;
    return;
  }
  
  procedure IL_out_1(){
    \* Can think of this as either the BAP, or just variable assignment.
    b := b - 1;
    c := c + 1;
    il_pass := 1;
    return;
  }
  
  procedure IL_out_2(){
    \* Can think of this as either the BAP, or just variable assignment.
    b := b - 1;
    c := c + 1;
    il_pass := 1;
    il_tl := red;
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
            if((ml_tl = green) /\ ((a + b + 1) /= d)) { 
                call ML_out_1(); 
            }; 
        }
        or { 
            if((ml_tl = green) /\ ((a + b + 1) = d)) { 
                call ML_out_2(); 
            }; 
        } 
        or { 
            if(c > 0) { 
                call ML_in(); 
            }; 
        } 
        or { 
            if( (il_tl = green) /\ (b /= 1) ) { 
                call IL_out_1(); 
            }; 
        }
        or { 
            if( (il_tl = green) /\ (b = 1) ) { 
                call IL_out_2(); 
            }; 
        }
        or { 
            if(a > 0) { 
                call IL_in(); 
            }; 
        }
        or { 
            if((il_tl = red ) /\ ( b > 0 ) /\ ( a = 0 ) /\ ( ml_pass = 1 )) { 
                call IL_tl_green(); 
            }; 
        }
        or { 
            if((ml_tl = green ) /\ ( (a + b) < d ) /\ ( c = 0 ) /\ ( il_pass = 1 )) { 
                call ML_tl_green(); 
            }; 
        };
        i := i + 1;
    }
  }
  
}

*)
\* BEGIN TRANSLATION (chksum(pcal) = "2e0d9628" /\ chksum(tla) = "52582cb0")
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
        /\ pc = "Lbl_9"

Lbl_1 == /\ pc = "Lbl_1"
         /\ ml_tl' = green
         /\ il_tl' = red
         /\ ml_pass' = 0
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << a, b, c, il_pass, n, i >>

ML_tl_green == Lbl_1

Lbl_2 == /\ pc = "Lbl_2"
         /\ il_tl' = green
         /\ ml_tl' = red
         /\ il_pass' = 0
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << a, b, c, ml_pass, n, i >>

IL_tl_green == Lbl_2

Lbl_3 == /\ pc = "Lbl_3"
         /\ a' = a + 1
         /\ n' = n + 1
         /\ ml_pass' = 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << b, c, ml_tl, il_tl, il_pass, i >>

ML_out_1 == Lbl_3

Lbl_4 == /\ pc = "Lbl_4"
         /\ a' = a + 1
         /\ n' = n + 1
         /\ ml_tl' = red
         /\ ml_pass' = 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << b, c, il_tl, il_pass, i >>

ML_out_2 == Lbl_4

Lbl_5 == /\ pc = "Lbl_5"
         /\ c' = c - 1
         /\ n' = n - 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << a, b, ml_tl, il_tl, ml_pass, il_pass, i >>

ML_in == Lbl_5

Lbl_6 == /\ pc = "Lbl_6"
         /\ b' = b - 1
         /\ c' = c + 1
         /\ il_pass' = 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << a, ml_tl, il_tl, ml_pass, n, i >>

IL_out_1 == Lbl_6

Lbl_7 == /\ pc = "Lbl_7"
         /\ b' = b - 1
         /\ c' = c + 1
         /\ il_pass' = 1
         /\ il_tl' = red
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << a, ml_tl, ml_pass, n, i >>

IL_out_2 == Lbl_7

Lbl_8 == /\ pc = "Lbl_8"
         /\ a' = a - 1
         /\ b' = b + 1
         /\ pc' = Head(stack).pc
         /\ stack' = Tail(stack)
         /\ UNCHANGED << c, ml_tl, il_tl, ml_pass, il_pass, n, i >>

IL_in == Lbl_8

Lbl_9 == /\ pc = "Lbl_9"
         /\ IF i < bound
               THEN /\ \/ /\ IF (ml_tl = green) /\ ((a + b + 1) /= d)
                                THEN /\ stack' = << [ procedure |->  "ML_out_1",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_3"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
                       \/ /\ IF (ml_tl = green) /\ ((a + b + 1) = d)
                                THEN /\ stack' = << [ procedure |->  "ML_out_2",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_4"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
                       \/ /\ IF c > 0
                                THEN /\ stack' = << [ procedure |->  "ML_in",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_5"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
                       \/ /\ IF (il_tl = green) /\ (b /= 1)
                                THEN /\ stack' = << [ procedure |->  "IL_out_1",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_6"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
                       \/ /\ IF (il_tl = green) /\ (b = 1)
                                THEN /\ stack' = << [ procedure |->  "IL_out_2",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_7"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
                       \/ /\ IF a > 0
                                THEN /\ stack' = << [ procedure |->  "IL_in",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_8"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
                       \/ /\ IF (il_tl = red ) /\ ( b > 0 ) /\ ( a = 0 ) /\ ( ml_pass = 1 )
                                THEN /\ stack' = << [ procedure |->  "IL_tl_green",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_2"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
                       \/ /\ IF (ml_tl = green ) /\ ( (a + b) < d ) /\ ( c = 0 ) /\ ( il_pass = 1 )
                                THEN /\ stack' = << [ procedure |->  "ML_tl_green",
                                                      pc        |->  "Lbl_10" ] >>
                                                  \o stack
                                     /\ pc' = "Lbl_1"
                                ELSE /\ pc' = "Lbl_10"
                                     /\ stack' = stack
               ELSE /\ pc' = "Done"
                    /\ stack' = stack
         /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, il_pass, n, i >>

Lbl_10 == /\ pc = "Lbl_10"
          /\ i' = i + 1
          /\ pc' = "Lbl_9"
          /\ UNCHANGED << a, b, c, ml_tl, il_tl, ml_pass, il_pass, n, stack >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == ML_tl_green \/ IL_tl_green \/ ML_out_1 \/ ML_out_2 \/ ML_in
           \/ IL_out_1 \/ IL_out_2 \/ IL_in \/ Lbl_9 \/ Lbl_10
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

ML_tl_green_event_guard == /\ (ml_tl = green ) /\ ( (a + b) < d ) /\ ( c = 0 ) /\ ( il_pass = 1 )
IL_tl_green_event_guard == /\ (il_tl = red ) /\ ( b > 0 ) /\ ( a = 0 ) /\ ( ml_pass = 1 )

deadlock_free == \/ ML_out_1_event_guard \/ ML_out_2_event_guard \/ IL_out_1_event_guard 
\/ IL_out_2_event_guard \/ ML_in_event_guard \/ IL_in_event_guard \/ ML_tl_green_event_guard \/ IL_tl_green_event_guard



=============================================================================
\* Modification History
\* Last modified Fri Feb 03 22:38:50 EST 2023 by jorra04
\* Created Fri Feb 03 21:43:59 EST 2023 by jorra04
