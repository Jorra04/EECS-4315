---------------------------- MODULE getAllPairs ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANTS input

(*
--algorithm getAllPairs {
    variable output = <<>>,
    currPair = <<>>,
    i = 1,
    j = 1;
    
    {
        while( i <= Len(input)) {
        while(j <= Len(input)) {
            currPair := <<>>;
            if(i /= j) {
                currPair := Append(currPair, input[i]);
                currPair := Append(currPair, input[j]);
            };
            if(Len(currPair) > 0) {
                output := Append(output, currPair);
            };
            
            j := j + 1;
        };
        
        i := i + 1;
        j := 1;
    }; 
        (*
            for all elements x in the array, for all elements y in the array, there exists an entry in the output that is equal to (x,y)
        *)
       assert (\A x \in 1..Len(input) : 
       (\A y \in 1..Len(input) : 
       (x /= y) => (\E z \in 1..Len(output) : 
       output[z] = <<input[x], input[y]>> )));

    
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "3dd56de" /\ chksum(tla) = "37f28360")
VARIABLES output, currPair, i, j, pc

vars == << output, currPair, i, j, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ currPair = <<>>
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              (\A y \in 1..Len(input) :
                              (x /= y) => (\E z \in 1..Len(output) :
                              output[z] = <<input[x], input[y]>> ))), 
                              "Failure of assertion at line 33, column 8.")
                    /\ pc' = "Done"
         /\ UNCHANGED << output, currPair, i, j >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ currPair' = <<>>
                    /\ IF i /= j
                          THEN /\ pc' = "Lbl_3"
                          ELSE /\ pc' = "Lbl_5"
                    /\ UNCHANGED << i, j >>
               ELSE /\ i' = i + 1
                    /\ j' = 1
                    /\ pc' = "Lbl_1"
                    /\ UNCHANGED currPair
         /\ UNCHANGED output

Lbl_5 == /\ pc = "Lbl_5"
         /\ IF Len(currPair) > 0
               THEN /\ output' = Append(output, currPair)
               ELSE /\ TRUE
                    /\ UNCHANGED output
         /\ j' = j + 1
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << currPair, i >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ currPair' = Append(currPair, input[i])
         /\ pc' = "Lbl_4"
         /\ UNCHANGED << output, i, j >>

Lbl_4 == /\ pc = "Lbl_4"
         /\ currPair' = Append(currPair, input[j])
         /\ pc' = "Lbl_5"
         /\ UNCHANGED << output, i, j >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_5 \/ Lbl_3 \/ Lbl_4
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
=============================================================================
\* Modification History
\* Last modified Sat Mar 04 23:31:54 EST 2023 by jorra04
\* Created Sat Mar 04 22:57:27 EST 2023 by jorra04
