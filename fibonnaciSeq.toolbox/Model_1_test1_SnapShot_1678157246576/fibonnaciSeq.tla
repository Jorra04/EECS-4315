---------------------------- MODULE fibonnaciSeq ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm fibSeq {

    variable output = <<1,1,2>>,
    i = 4,
    result = -1;
    
    {
    
        if(input = 1 \/ input = 2 \/ input = 3) {
            result := output[input];
        };
        
        while(i <= input) {
            output := Append(output,  output[i-1] + output[i-2]);
            result := output[Len(output)];
            i := i +1;
        };
        
\*        assert (\A x \in 3..Len(output)-1: 
\*        (output[i] = (output[i-1] + output[i-2]))
\*        );
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "9271bf62" /\ chksum(tla) = "da74b47d")
VARIABLES output, i, result, pc

vars == << output, i, result, pc >>

Init == (* Global variables *)
        /\ output = <<1,1,2>>
        /\ i = 4
        /\ result = -1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF input = 1 \/ input = 2 \/ input = 3
               THEN /\ result' = output[input]
               ELSE /\ TRUE
                    /\ UNCHANGED result
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= input
               THEN /\ output' = Append(output,  output[i-1] + output[i-2])
                    /\ result' = output'[Len(output')]
                    /\ i' = i +1
                    /\ pc' = "Lbl_2"
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << output, i, result >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 21:47:13 EST 2023 by jorra04
\* Created Sun Mar 05 23:08:21 EST 2023 by jorra04
