------------------ MODULE largestNumberAtLeastDoubleOthers ------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm largestAtLeastDouble {
    variable i = 1, output = TRUE, max = -1;
    
    {
        max := input[1];
        while(i <= Len(input)) {
            if(input[i] >= max) {
                max := input[i];
            };
            i := i + 1;
        };
        i := 1;
        while(i <= Len(input)) {
            if(~(max >= 2 * input[i])) {
                output := FALSE;
            };
        }
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "300d2efa" /\ chksum(tla) = "715a36e")
VARIABLES i, output, max, pc

vars == << i, output, max, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = TRUE
        /\ max = -1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ max' = input[1]
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ IF input[i] >= max
                          THEN /\ max' = input[i]
                          ELSE /\ TRUE
                               /\ max' = max
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ i' = 1
                    /\ pc' = "Lbl_3"
                    /\ max' = max
         /\ UNCHANGED output

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input)
               THEN /\ IF ~(max >= 2 * input[i])
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ pc' = "Lbl_3"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED output
         /\ UNCHANGED << i, max >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 22:50:22 EDT 2023 by jorra04
\* Created Mon Apr 03 22:17:26 EDT 2023 by jorra04
