--------------------- MODULE firstNonRepeatingCharacter ---------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm firstNonRepeating {

    variable i = 1, j = 1,k=1, firstNonRepeating = "", seen = <<>>, duplicateFound = FALSE;
    
    {
        while(i <= Len(input)) {
            seen := Append(seen, input[i]);
            j := i + 1;
            while(j <= Len(input) /\ duplicateFound = FALSE) {
                k := 1;
                while( k <= Len(seen) /\ duplicateFound = FALSE) {
                    if(input[j] = seen[k]) {
                        duplicateFound := TRUE;
                    };
                    k := k + 1;
                };
                
                j := j + 1;  
            };
            
            if(duplicateFound = FALSE) {
                firstNonRepeating := input[i];
                i := Len(input);
            };
            duplicateFound := FALSE;
            i := i + 1;
        }
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "3205f997" /\ chksum(tla) = "2cbbcdad")
VARIABLES i, j, k, firstNonRepeating, seen, duplicateFound, pc

vars == << i, j, k, firstNonRepeating, seen, duplicateFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ k = 1
        /\ firstNonRepeating = ""
        /\ seen = <<>>
        /\ duplicateFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ seen' = Append(seen, input[i])
                    /\ j' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << j, seen >>
         /\ UNCHANGED << i, k, firstNonRepeating, duplicateFound >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input) /\ duplicateFound = FALSE
               THEN /\ k' = 1
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED << i, firstNonRepeating, duplicateFound >>
               ELSE /\ IF duplicateFound = FALSE
                          THEN /\ firstNonRepeating' = input[i]
                               /\ i' = Len(input)
                          ELSE /\ TRUE
                               /\ UNCHANGED << i, firstNonRepeating >>
                    /\ duplicateFound' = FALSE
                    /\ pc' = "Lbl_4"
                    /\ k' = k
         /\ UNCHANGED << j, seen >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF k <= Len(seen) /\ duplicateFound = FALSE
               THEN /\ IF input[j] = seen[k]
                          THEN /\ duplicateFound' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED duplicateFound
                    /\ k' = k + 1
                    /\ pc' = "Lbl_3"
                    /\ j' = j
               ELSE /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << k, duplicateFound >>
         /\ UNCHANGED << i, firstNonRepeating, seen >>

Lbl_4 == /\ pc = "Lbl_4"
         /\ i' = i + 1
         /\ pc' = "Lbl_1"
         /\ UNCHANGED << j, k, firstNonRepeating, seen, duplicateFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3 \/ Lbl_4
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 01:05:32 EST 2023 by jorra04
\* Created Mon Mar 06 00:36:36 EST 2023 by jorra04
