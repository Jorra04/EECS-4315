--------------------- MODULE firstNonRepeatingCharacter ---------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm firstNonRepeating {

    variable i = 1, j = 1, firstNonRepeating = "", repeatFound = FALSE;
    
    {
        while(i <= Len(input)) {
            while(j <= Len(input)) {
                if(input[i] = input[j] /\ (i # j)) {
                    repeatFound := TRUE;
                    j := Len(input);
                };
                j := j + 1;
                
            };
            if(repeatFound = FALSE) {
                firstNonRepeating := input[i];
                i := Len(input);
            };
            repeatFound := FALSE;
            i := i + 1;
        };
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "8a2d2627" /\ chksum(tla) = "d11337a8")
VARIABLES i, j, firstNonRepeating, repeatFound, pc

vars == << i, j, firstNonRepeating, repeatFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ firstNonRepeating = ""
        /\ repeatFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
         /\ UNCHANGED << i, j, firstNonRepeating, repeatFound >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF input[i] = input[j] /\ (i # j)
                          THEN /\ repeatFound' = TRUE
                               /\ j' = Len(input)
                          ELSE /\ TRUE
                               /\ UNCHANGED << j, repeatFound >>
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED << i, firstNonRepeating >>
               ELSE /\ IF repeatFound = FALSE
                          THEN /\ firstNonRepeating' = input[i]
                               /\ i' = Len(input)
                          ELSE /\ TRUE
                               /\ UNCHANGED << i, firstNonRepeating >>
                    /\ repeatFound' = FALSE
                    /\ pc' = "Lbl_4"
                    /\ j' = j

Lbl_3 == /\ pc = "Lbl_3"
         /\ j' = j + 1
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, firstNonRepeating, repeatFound >>

Lbl_4 == /\ pc = "Lbl_4"
         /\ i' = i + 1
         /\ pc' = "Lbl_1"
         /\ UNCHANGED << j, firstNonRepeating, repeatFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3 \/ Lbl_4
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 00:48:11 EST 2023 by jorra04
\* Created Mon Mar 06 00:36:36 EST 2023 by jorra04
