------------------------------- MODULE twoSum -------------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, target


(*
--algorithm twoSum {

    variable output = <<>>,
    i= 1,
    j = 1;
    
    {
        while(i <= Len(input)) {
            while( j <= Len(input)) {
                j := 1;
                if((i /= j) /\ ((input[i] + input[j]) = target)) {
                    output := output \o <<i,j>>;
                };
                j := j + 1;
            };
            
            i := i + 1;
        };
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "f446bbd2" /\ chksum(tla) = "8a33ee01")
VARIABLES output, i, j, pc

vars == << output, i, j, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
         /\ UNCHANGED << output, i, j >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ j' = 1
                    /\ IF (i /= j') /\ ((input[i] + input[j']) = target)
                          THEN /\ output' = output \o <<i,j'>>
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ pc' = "Lbl_3"
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << output, j >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ j' = j + 1
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Mar 05 23:32:55 EST 2023 by jorra04
\* Created Sun Mar 05 23:25:37 EST 2023 by jorra04
