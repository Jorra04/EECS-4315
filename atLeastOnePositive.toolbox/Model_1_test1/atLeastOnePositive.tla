------------------------- MODULE atLeastOnePositive -------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm atLeastOnePositive {
    variable atLeastOnePos = FALSE, i = 1;
    
    {
        while(i <= Len(input)) {
            if(input[i] > 0) {
                atLeastOnePos := TRUE;
            };
            i := i + 1;
        };
        
        assert (atLeastOnePos => (\E x \in 1..Len(input) :
            (input[x] > 0)
        ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "be80e7f3" /\ chksum(tla) = "b291bc65")
VARIABLES atLeastOnePos, i, pc

vars == << atLeastOnePos, i, pc >>

Init == (* Global variables *)
        /\ atLeastOnePos = FALSE
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] > 0
                          THEN /\ atLeastOnePos' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED atLeastOnePos
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ Assert(       (atLeastOnePos => (\E x \in 1..Len(input) :
                                  (input[x] > 0)
                              )), 
                              "Failure of assertion at line 17, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << atLeastOnePos, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 21:20:01 EST 2023 by jorra04
\* Created Mon Mar 06 21:14:15 EST 2023 by jorra04
