---------------------------- MODULE isPalindrome ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm isPalindrome {
    variables i =1, j = Len(input), output = TRUE;
    
    {
        while(i < j) {
            if(input[i] # input[j]) {
                output := FALSE;
            };
            
            i := i + 1;
            j := j - 1;
        };
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "9cca32da" /\ chksum(tla) = "9f11e9dc")
VARIABLES i, j, output, pc

vars == << i, j, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = Len(input)
        /\ output = TRUE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i < j
               THEN /\ IF input[i] # input[j]
                          THEN /\ output' = FALSE
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ j' = j - 1
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << i, j, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 18:16:18 EDT 2023 by jorra04
\* Created Sun Apr 02 18:12:17 EDT 2023 by jorra04
