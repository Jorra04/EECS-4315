--------------------- MODULE firstNonRepeatingCharacter ---------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm firstNonRepeating {

    variable i = 1, j = 1, firstNonRepeating = "", seen = <<>>, duplicateFound = FALSE;
    
    {
        while(i <= Len(input)) {
            while(j <= Len(seen)) {
                if(input[i] = seen[j]){
                    duplicateFound := TRUE;
                };
                j := j + 1;
            };
            
            if(duplicateFound = FALSE) {
                firstNonRepeating := input[i];
                i := Len(input);
            };
            duplicateFound := FALSE;
            seen := Append(seen, input[i]);
            i := i + 1;
        }
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "df1590b6" /\ chksum(tla) = "d831fb0")
VARIABLES i, j, firstNonRepeating, seen, duplicateFound, pc

vars == << i, j, firstNonRepeating, seen, duplicateFound, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ firstNonRepeating = ""
        /\ seen = <<>>
        /\ duplicateFound = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
         /\ UNCHANGED << i, j, firstNonRepeating, seen, duplicateFound >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(seen)
               THEN /\ IF input[i] = seen[j]
                          THEN /\ duplicateFound' = TRUE
                          ELSE /\ TRUE
                               /\ UNCHANGED duplicateFound
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, firstNonRepeating, seen >>
               ELSE /\ IF duplicateFound = FALSE
                          THEN /\ firstNonRepeating' = input[i]
                               /\ i' = Len(input)
                          ELSE /\ TRUE
                               /\ UNCHANGED << i, firstNonRepeating >>
                    /\ duplicateFound' = FALSE
                    /\ seen' = Append(seen, input[i'])
                    /\ pc' = "Lbl_3"
                    /\ j' = j

Lbl_3 == /\ pc = "Lbl_3"
         /\ i' = i + 1
         /\ pc' = "Lbl_1"
         /\ UNCHANGED << j, firstNonRepeating, seen, duplicateFound >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 00:54:28 EST 2023 by jorra04
\* Created Mon Mar 06 00:36:36 EST 2023 by jorra04
