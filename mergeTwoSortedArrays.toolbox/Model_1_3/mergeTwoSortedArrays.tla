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
        
        assert Len(output) = (Len(input1) + Len(input2));
        assert \A k \in 1..(Len(output) -1) : output[k] <= output[k+1];
        assert \A k \in 1..Len(output) : (\E l \in 1..Len(input1) : input1[l] = output[k]) \/ (\E l \in 1..Len(input2) : input2[l] = output[k])
    }

}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "b9041127" /\ chksum(tla) = "14f02a9d")
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
               ELSE /\ Assert(Len(output) = (Len(input1) + Len(input2)), 
                              "Failure of assertion at line 30, column 9.")
                    /\ Assert(\A k \in 1..(Len(output) -1) : output[k] <= output[k+1], 
                              "Failure of assertion at line 31, column 9.")
                    /\ Assert(\A k \in 1..Len(output) : (\E l \in 1..Len(input1) : input1[l] = output[k]) \/ (\E l \in 1..Len(input2) : input2[l] = output[k]), 
                              "Failure of assertion at line 32, column 9.")
                    /\ pc' = "Done"
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
\* Last modified Mon Apr 03 17:43:02 EDT 2023 by jorra04
\* Created Mon Apr 03 17:25:20 EDT 2023 by jorra04
