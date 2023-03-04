-------------------------- MODULE practiceTest_q1 --------------------------
EXTENDS Integers, Sequences, TLC

CONSTANTS input1, input2


(*
--algorithm keepAll {

    variable i = 1, 
    output = <<>>;
    
    
    
    {
    assert /\ (Len(output) = 0) /\ (i=1);
        while( i <= Len(input1)) {
            if(input1[i] /= input2) {
                output := Append(output, input1[i]);
            }; 
            i := i + 1;
        };

    assert /\ (\A x \in 1..Len(output) : (1=1))

    }
    
    
    

}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "aa02d638" /\ chksum(tla) = "d1165dfd")
VARIABLES i, output, pc

vars == << i, output, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = <<>>
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (Len(output) = 0) /\ (i=1), 
                   "Failure of assertion at line 16, column 5.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input1)
               THEN /\ IF input1[i] /= input2
                          THEN /\ output' = Append(output, input1[i])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(/\ (\A x \in 1..Len(output) : (1=1)), 
                              "Failure of assertion at line 24, column 5.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Thu Mar 02 17:55:26 EST 2023 by jorra04
\* Created Thu Mar 02 16:53:29 EST 2023 by jorra04
