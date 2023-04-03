------------------------ MODULE mergeTwoSortedArrays ------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input1, input2

(*
--algorithm mergeTwoSorted {
    variable i = 1, j = 1, output = <<>>;
    
    {
        while(i <= Len(input1) /\ j <= Len(input2)) {
            if(input1[i] >= input2[j]) {
                output := Append(output, input2[j]);
                j := j + 1;
            } else {
                output := Append(output, input1[i]);
                i := i + 1;
            };
        };
        
        while(i <= Len(input1)) {
            output := Append(output, input1[i]);
            i := i + 1;
        };
        
        while(j <= Len(input2)) {
            output := Append(output, input2[j]);
            j := j + 1;
        };
    }

}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "a9a9b9b8" /\ chksum(tla) = "34928355")
VARIABLES i, j, output, pc

vars == << i, j, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = <<>>
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input1) /\ j <= Len(input2)
               THEN /\ IF input1[i] >= input2[j]
                          THEN /\ output' = Append(output, input2[j])
                               /\ j' = j + 1
                               /\ i' = i
                          ELSE /\ output' = Append(output, input1[i])
                               /\ i' = i + 1
                               /\ j' = j
                    /\ pc' = "Lbl_1"
               ELSE /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, j, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input1)
               THEN /\ output' = Append(output, input1[i])
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Lbl_3"
                    /\ UNCHANGED << i, output >>
         /\ j' = j

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF j <= Len(input2)
               THEN /\ output' = Append(output, input2[j])
                    /\ j' = j + 1
                    /\ pc' = "Lbl_3"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << j, output >>
         /\ i' = i

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Apr 03 17:36:03 EDT 2023 by jorra04
\* Created Mon Apr 03 17:25:20 EDT 2023 by jorra04
