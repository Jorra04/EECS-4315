------------------------- MODULE getAllSuffixes_v2 -------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm getAllSuffixes_v2 {
    variable currentSuffix = <<>>,
    allSuffixes = <<>>,
    i = 1,
    j = 1;
    
    {
        while( i <= Len(input)) {
            while(j <= Len(input)) {
                currentSuffix := Append(currentSuffix, input[j]);
                j := j + 1;
            };
            
            allSuffixes := Append(allSuffixes, currentSuffix);
            currentSuffix := <<>>;
            i := i + 1;
            j := i;
        };
        
        (*
            for all x in range 1..Len(input), for all y in range 1..Len(input) - x + 1
        *)
        assert (\A x \in 1..Len(input) : 
        (\A y \in x..Len(input) : (allSuffixes[x][y] = input[y]))
        );
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "1be1fb8" /\ chksum(tla) = "89563c1")
VARIABLES currentSuffix, allSuffixes, i, j, pc

vars == << currentSuffix, allSuffixes, i, j, pc >>

Init == (* Global variables *)
        /\ currentSuffix = <<>>
        /\ allSuffixes = <<>>
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ pc' = "Lbl_2"
               ELSE /\ Assert(       (\A x \in 1..Len(input) :
                              (\A y \in x..Len(input) : (allSuffixes[x][y] = input[y]))
                              ), 
                              "Failure of assertion at line 28, column 9.")
                    /\ pc' = "Done"
         /\ UNCHANGED << currentSuffix, allSuffixes, i, j >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)
               THEN /\ currentSuffix' = Append(currentSuffix, input[j])
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << allSuffixes, i >>
               ELSE /\ allSuffixes' = Append(allSuffixes, currentSuffix)
                    /\ currentSuffix' = <<>>
                    /\ i' = i + 1
                    /\ j' = i'
                    /\ pc' = "Lbl_1"

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Sun Mar 05 01:14:38 EST 2023 by jorra04
\* Created Sun Mar 05 00:41:17 EST 2023 by jorra04
