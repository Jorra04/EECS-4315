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
            
        }
    }
    
    
}
*)

=============================================================================
\* Modification History
\* Last modified Fri Mar 03 21:13:41 EST 2023 by jorra04
\* Created Fri Mar 03 21:09:31 EST 2023 by jorra04
