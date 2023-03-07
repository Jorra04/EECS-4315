------------------------ MODULE firstAndLastSwapped ------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm firstLastSwap {
    variable output = input, temp = -1;
    
    {
        temp := output[1];
        output[1] := output[Len(input)];
        output[Len(input)] := temp; 
        
        (*
        these two asserts ensure that the first and last elements have been swapped while everything else remains the same.
        *)
        assert /\ (input[1] = output[Len(output)]) /\ (input[Len(input)] = output[1]);
        assert (\A x \in 2..(Len(input)-1) : 
            (input[x] = output[x])
        );
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "970bb2fe" /\ chksum(tla) = "6c85c5a7")
VARIABLES output, temp, pc

vars == << output, temp, pc >>

Init == (* Global variables *)
        /\ output = input
        /\ temp = -1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ temp' = output[1]
         /\ output' = [output EXCEPT ![1] = output[Len(input)]]
         /\ pc' = "Lbl_2"

Lbl_2 == /\ pc = "Lbl_2"
         /\ output' = [output EXCEPT ![Len(input)] = temp]
         /\ Assert(/\ (input[1] = output'[Len(output')]) /\ (input[Len(input)] = output'[1]), 
                   "Failure of assertion at line 17, column 9.")
         /\ Assert(       (\A x \in 2..(Len(input)-1) :
                       (input[x] = output'[x])
                   ), "Failure of assertion at line 18, column 9.")
         /\ pc' = "Done"
         /\ temp' = temp

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 21:34:32 EST 2023 by jorra04
\* Created Mon Mar 06 21:30:02 EST 2023 by jorra04
