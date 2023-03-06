----------------------------- MODULE bubblesort -----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
    --algorithm bubbleSort {
        variable output = input,
        i = 1,
        j = 1,
        temp = -1;
        
        {
            while(i < Len(input) - 2) {
                while(j < Len(input) - i - 2) {
                    if(output[j] > output[j + 1]) {
                        temp := output[j];
                        output[j] := output[j+1];
                        output[j+1] := temp;
                    };
                    j := j + 1;
                };
                i := i + 1;
            };
            
            assert (\A x \in 1..Len(output)-1 : output[x] < output[x+1]);
        }
    }
*)
\* BEGIN TRANSLATION (chksum(pcal) = "88b2cd" /\ chksum(tla) = "405b849f")
VARIABLES output, i, j, temp, pc

vars == << output, i, j, temp, pc >>

Init == (* Global variables *)
        /\ output = input
        /\ i = 1
        /\ j = 1
        /\ temp = -1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i < Len(input) - 2
               THEN /\ pc' = "Lbl_2"
               ELSE /\ Assert((\A x \in 1..Len(output)-1 : output[x] < output[x+1]), 
                              "Failure of assertion at line 25, column 13.")
                    /\ pc' = "Done"
         /\ UNCHANGED << output, i, j, temp >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j < Len(input) - i - 2
               THEN /\ IF output[j] > output[j + 1]
                          THEN /\ temp' = output[j]
                               /\ output' = [output EXCEPT ![j] = output[j+1]]
                               /\ pc' = "Lbl_3"
                          ELSE /\ pc' = "Lbl_4"
                               /\ UNCHANGED << output, temp >>
                    /\ i' = i
               ELSE /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED << output, temp >>
         /\ j' = j

Lbl_4 == /\ pc = "Lbl_4"
         /\ j' = j + 1
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i, temp >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ output' = [output EXCEPT ![j+1] = temp]
         /\ pc' = "Lbl_4"
         /\ UNCHANGED << i, j, temp >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_4 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Mar 05 22:55:59 EST 2023 by jorra04
\* Created Sun Mar 05 22:45:38 EST 2023 by jorra04
