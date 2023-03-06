------------------------------ MODULE powArray ------------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input, pow

(*
--algorithm powArray {

    variable output = <<>>, i = 1;
    {
        (*
            here we want to assert that the input array is a non-empty array,
            that we start at the correct index, that the output array prior to start
            is empty, and finally, that the power that we are raising each element to
            is greater than or equal to zero (don't do negative powers).
        *)
        assert /\ (Len(input) > 0) /\ (i = 1) /\ (Len(output) = 0) /\ (pow >= 0);
        while(i <= Len(input)) {
            output := Append(output, input[i] ^ pow);
            i := i + 1;
        };
        
        assert (\A x \in 1..Len(input) : 
        ((input[x] ^ pow) = output[x])
        );
    }
    
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "fa919ae1" /\ chksum(tla) = "e938f6a0")
VARIABLES output, i, pc

vars == << output, i, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (Len(input) > 0) /\ (i = 1) /\ (Len(output) = 0) /\ (pow >= 0), 
                   "Failure of assertion at line 16, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
               THEN /\ output' = Append(output, input[i] ^ pow)
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              ((input[x] ^ pow) = output[x])
                              ), 
                              "Failure of assertion at line 22, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << output, i >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 11:45:31 EST 2023 by jorra04
\* Created Fri Mar 03 21:09:31 EST 2023 by jorra04
