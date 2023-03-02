------------------------- MODULE simpleLoopExample -------------------------
EXTENDS Integers, Sequences, TLC

CONSTANT bound

(*
--algorithm simpleLoop {
    variable i = 0,
    currentValue = 0;
    
    {
        assert /\ (currentValue = 0 /\ i = 0);
        while( i < bound) {
            currentValue := currentValue + 1;
        };
        
        assert (currentValue = bound);
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "eb18a586" /\ chksum(tla) = "9f167309")
VARIABLES i, currentValue, pc

vars == << i, currentValue, pc >>

Init == (* Global variables *)
        /\ i = 0
        /\ currentValue = 0
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (currentValue = 0 /\ i = 0), 
                   "Failure of assertion at line 12, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, currentValue >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i < bound
               THEN /\ currentValue' = currentValue + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert((currentValue = bound), 
                              "Failure of assertion at line 17, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED currentValue
         /\ i' = i

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Thu Mar 02 11:13:54 EST 2023 by jorra04
\* Created Thu Mar 02 10:34:16 EST 2023 by jorra04
