-------------------------- MODULE practiceTest_q2 --------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input1

(*
--algorithm keepMultiplesOfThree {

    variable output = <<>>,
    i =1;
    
    {
        assert /\ (i = 1 /\ Len(output) = 0);
        
        while(i <= Len(input1)) {
            if((input1[i] % 3) = 0) {
                output := Append(output, input1[i]);
            };
            i := i + 1;
        };
        
        assert (\A x \in 1..Len(output) : (\E y \in 1..Len(input1) : (output[x] = input1[y])  ));
        assert (\A x \in 1..Len(output) : ((output[x] % 3) = 0));
    }
    
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "e3bf4dff" /\ chksum(tla) = "e381af18")
VARIABLES output, i, pc

vars == << output, i, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ i = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(/\ (i = 1 /\ Len(output) = 0), 
                   "Failure of assertion at line 12, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << output, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input1)
               THEN /\ IF (input1[i] % 3) = 0
                          THEN /\ output' = Append(output, input1[i])
                          ELSE /\ TRUE
                               /\ UNCHANGED output
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert((\A x \in 1..Len(output) : (\E y \in 1..Len(input1) : (output[x] = input1[y])  )), 
                              "Failure of assertion at line 21, column 9.")
                    /\ Assert((\A x \in 1..Len(output) : ((output[x] % 3) = 0)), 
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
\* Last modified Fri Mar 03 18:10:30 EST 2023 by jorra04
\* Created Fri Mar 03 17:49:00 EST 2023 by jorra04
