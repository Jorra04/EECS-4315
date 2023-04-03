--------------------------- MODULE IsSubsequence ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input1, input2

(*
--algorithm isSubsequence {
    variables i = 1, j = 1, output = FALSE, numbersEqual = FALSE;
    
    {
        while( i <= Len(input1)){
            j := 1;
            numbersEqual := TRUE;
            while( j <= Len(input2) /\ ~(i + Len(input2) > Len(input1))) {
                numbersEqual := (input1[i+j] = input2[j]) /\ numbersEqual;
                j := j + 1;
                if(numbersEqual = TRUE) {
                    output := TRUE;
                    i := Len(input1) + 1;
                    j := Len(input2) + 1;
                };
            };
            
            
            i := i + 1;
        };
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "833c5ea8" /\ chksum(tla) = "a619ba8d")
VARIABLES i, j, output, numbersEqual, pc

vars == << i, j, output, numbersEqual, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = FALSE
        /\ numbersEqual = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input1)
               THEN /\ j' = 1
                    /\ numbersEqual' = TRUE
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << j, numbersEqual >>
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input2) /\ ~(i + Len(input2) > Len(input1))
               THEN /\ numbersEqual' = ((input1[i+j] = input2[j]) /\ numbersEqual)
                    /\ j' = j + 1
                    /\ IF numbersEqual' = TRUE
                          THEN /\ output' = TRUE
                               /\ i' = Len(input1) + 1
                               /\ pc' = "Lbl_3"
                          ELSE /\ pc' = "Lbl_2"
                               /\ UNCHANGED << i, output >>
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << j, output, numbersEqual >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ j' = Len(input2) + 1
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, output, numbersEqual >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Mar 31 19:34:16 EDT 2023 by jorra04
\* Created Fri Mar 31 18:52:10 EDT 2023 by jorra04
