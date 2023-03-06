--------------------------- MODULE getAllPrefixes ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm getAllPrefixes {
    variable output = <<>>, currentPrefix = <<>>, i = 1, j = 1;
    
    {
        while(i <= Len(input)) {
            j := 1;
            while(j <= i) {
                currentPrefix := Append(currentPrefix, input[j]);
                j := j + 1;
            };
            
            output := Append(output, currentPrefix);
            i := i + 1;
        };
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "ac7fb859" /\ chksum(tla) = "e6dedf8f")
VARIABLES output, currentPrefix, i, j, pc

vars == << output, currentPrefix, i, j, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ currentPrefix = <<>>
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ j' = 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ j' = j
         /\ UNCHANGED << output, currentPrefix, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= i
               THEN /\ currentPrefix' = Append(currentPrefix, input[j])
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << output, i >>
               ELSE /\ output' = Append(output, currentPrefix)
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << currentPrefix, j >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 11:57:04 EST 2023 by jorra04
\* Created Mon Mar 06 11:50:20 EST 2023 by jorra04
