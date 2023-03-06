---------------------------- MODULE fibonnaciSeq ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm fibSeq {

    variable output = <<1,1,2>>,
    i = 3,
    result = -1;
    
    {
    
        if(input = 1 \/ input = 2 \/ input = 3) {
            result := output[input];
            i := i + 1;
        };
        
        while(i <= Len(input)) {
            output := Append(output,  output[i-1] + output[i-2]);
            result := output[Len(output)];
            i := i +1;
        }
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "1ddb913f" /\ chksum(tla) = "16b7040d")
VARIABLES output, i, result, pc

vars == << output, i, result, pc >>

Init == (* Global variables *)
        /\ output = <<1,1,2>>
        /\ i = 3
        /\ result = -1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF input = 1 \/ input = 2 \/ input = 3
               THEN /\ result' = output[input]
                    /\ i' = i + 1
               ELSE /\ TRUE
                    /\ UNCHANGED << i, result >>
         /\ pc' = "Lbl_2"
         /\ UNCHANGED output

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input)
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
\* Last modified Sun Mar 05 23:20:47 EST 2023 by jorra04
\* Created Sun Mar 05 23:08:21 EST 2023 by jorra04
