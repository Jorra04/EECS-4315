--------------------------- MODULE IsSubsequence ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input1, input2

(*
--algorithm isSubsequence {
    variables i = 1, j = 1, output = FALSE, numbersEqual = FALSE;
    
    {
        while( i <= Len(input1)){
            j := 1;
            numbersEqual := ~(i + Len(input2) > Len(input1));
            while( j <= Len(input2) /\ ~(i + Len(input2) > Len(input1))) {
                numbersEqual := (input1[i+j] = input2[j]) /\ numbersEqual;
                j := j + 1;
            };
            
            if(numbersEqual = TRUE) {
                    output := TRUE;
                    i := Len(input1) + 1;
                    j := Len(input2) + 1;
                };
            
            
            i := i + 1;
        };
        
        assert
        (\E b \in 1..Len(input2) : (Len(input1) - b >= Len(input2)) /\ 
        (\A u \in 1..Len(input2) : (input1[u + b] = input2[u])) );
        
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "4ed4e5c5" /\ chksum(tla) = "a640b74b")
VARIABLES i, j, output, numbersEqual, pc

vars == << i, j, output, numbersEqual, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ j = 1
        /\ output = FALSE
        /\ numbersEqual = FALSE
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input1)
               THEN /\ j' = 1
                    /\ numbersEqual' = ~(i + Len(input2) > Len(input1))
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert((\E b \in 1..Len(input2) : (Len(input1) - b >= Len(input2)) /\
                              (\A u \in 1..Len(input2) : (input1[u + b] = input2[u])) ), 
                              "Failure of assertion at line 28, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << j, numbersEqual >>
         /\ UNCHANGED << i, output >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input2) /\ ~(i + Len(input2) > Len(input1))
               THEN /\ numbersEqual' = ((input1[i+j] = input2[j]) /\ numbersEqual)
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << i, output >>
               ELSE /\ IF numbersEqual = TRUE
                          THEN /\ output' = TRUE
                               /\ i' = Len(input1) + 1
                               /\ j' = Len(input2) + 1
                          ELSE /\ TRUE
                               /\ UNCHANGED << i, j, output >>
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED numbersEqual

Lbl_3 == /\ pc = "Lbl_3"
         /\ i' = i + 1
         /\ pc' = "Lbl_1"
         /\ UNCHANGED << j, output, numbersEqual >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sat Apr 01 21:04:28 EDT 2023 by jorra04
\* Created Fri Mar 31 18:52:10 EDT 2023 by jorra04
