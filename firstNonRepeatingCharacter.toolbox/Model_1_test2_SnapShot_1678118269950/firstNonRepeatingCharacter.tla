--------------------- MODULE firstNonRepeatingCharacter ---------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm firstNonRepeating {

    variable i = 1, j = 1,k=1, firstNonRepeating = "", duplicateFound = FALSE;
    
    {
        while(i <= Len(input)) {
            while(j <= Len(input)) {
                if(input[i] = input[j] /\ (i # j)) {
                    duplicateFound := TRUE;
                };
                
                j := j + 1;
            };
            
            if(duplicateFound = FALSE) {
                firstNonRepeating := input[i];
                i:= Len(input);
            };
            
            i := i + 1;
        }
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "32d8fa9" /\ chksum(tla) = "6b89ae93")
VARIABLES i, j, k, firstNonRepeating, duplicateFound, pc

vars == << i, j, k, firstNonRepeating, duplicateFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ k = 1
        /\ firstNonRepeating = ""
        /\ duplicateFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
         /\ UNCHANGED << i, j, k, firstNonRepeating, duplicateFound >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ IF input[i] = input[j] /\ (i # j)
                          THEN /\ duplicateFound' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED duplicateFound
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, firstNonRepeating >>
               ELSE /\ IF duplicateFound = FALSE
                          THEN /\ firstNonRepeating' = input[i]
                               /\ i' = Len(input)
                          ELSE /\ TRUE
                               /\ UNCHANGED << i, firstNonRepeating >>
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED << j, duplicateFound >>
         /\ k' = k

Lbl_3 == /\ pc = "Lbl_3"
         /\ i' = i + 1
         /\ pc' = "Lbl_1"
         /\ UNCHANGED << j, k, firstNonRepeating, duplicateFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 10:57:12 EST 2023 by jorra04
\* Created Mon Mar 06 00:36:36 EST 2023 by jorra04
