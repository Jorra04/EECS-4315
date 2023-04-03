---------------------------- MODULE sortByParity ----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm sortByParity {
    variable i = 1, output = <<>>, odds = <<>>, evens = <<>>, evenIndex = 1, oddIndex = 1;
    
    {
        while(i <= Len(input)) {
            if((input[i] % 2) = 0) {
                evens := Append(evens, input[i]); 
            } else {
                odds := Append(odds, input[i]);
            };
            
            output := Append(output, 0);
            
            i := i + 1;
        };
       i := 1;
        while(i <= Len(output)) {
            if((i % 2) = 0) {
                output[i] := odds[oddIndex];
                oddIndex := oddIndex + 1;
            } else {
                output[i] := evens[evenIndex];
                evenIndex := evenIndex + 1;
            };
            i:= i + 1;
        };
        
        assert \A a \in 1..Len(output) : 
        IF (a % 2) = 0
        THEN (output[a] % 2) = 0
        ELSE (output[a] % 2) # 0;
        
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "a6bd68f1" /\ chksum(tla) = "11196a90")
VARIABLES i, output, odds, evens, evenIndex, oddIndex, pc

vars == << i, output, odds, evens, evenIndex, oddIndex, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = <<>>
        /\ odds = <<>>
        /\ evens = <<>>
        /\ evenIndex = 1
        /\ oddIndex = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ IF (input[i] % 2) = 0
                          THEN /\ evens' = Append(evens, input[i])
                               /\ odds' = odds
                          ELSE /\ odds' = Append(odds, input[i])
                               /\ evens' = evens
                    /\ output' = Append(output, 0)
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ i' = 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << output, odds, evens >>
         /\ UNCHANGED << evenIndex, oddIndex >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(output)
               THEN /\ IF (i % 2) = 0
                          THEN /\ output' = [output EXCEPT ![i] = odds[oddIndex]]
                               /\ oddIndex' = oddIndex + 1
                               /\ UNCHANGED evenIndex
                          ELSE /\ output' = [output EXCEPT ![i] = evens[evenIndex]]
                               /\ evenIndex' = evenIndex + 1
                               /\ UNCHANGED oddIndex
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert(       \A a \in 1..Len(output) :
                              IF (a % 2) = 0
                              THEN (output[a] % 2) = 0
                              ELSE (output[a] % 2) # 0, 
                              "Failure of assertion at line 33, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED << i, output, evenIndex, oddIndex >>
         /\ UNCHANGED << odds, evens >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Apr 02 22:40:06 EDT 2023 by jorra04
\* Created Sun Apr 02 22:12:56 EDT 2023 by jorra04
