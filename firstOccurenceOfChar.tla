------------------------ MODULE firstOccurenceOfChar ------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, ch

(*
--algorithm firstOccurence {
    variable output = -1, i = 1, hasBeenFound = FALSE;
    
    {
        while(i <= Len(input)) {
            if(/\ hasBeenFound = FALSE) {
                output := i;
                hasBeenFound := TRUE;
            };
            i:= i + 1;
        };
        
\*        assert
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "9fe46a0" /\ chksum(tla) = "b17227e2")
VARIABLES output, i, hasBeenFound, pc

vars == << output, i, hasBeenFound, pc >>

Init == (* Global variables *)
        /\ output = -1
        /\ i = 1
        /\ hasBeenFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ IF /\ hasBeenFound = FALSE
                          THEN /\ output' = i
                               /\ hasBeenFound' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED << output, hasBeenFound >>
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << output, i, hasBeenFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 00:25:16 EST 2023 by jorra04
\* Created Mon Mar 06 00:13:34 EST 2023 by jorra04
