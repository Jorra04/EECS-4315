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
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "b8ce5b22" /\ chksum(tla) = "64765260")
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
               ELSE /\ pc' = "Done"
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
\* Last modified Sun Mar 05 01:05:37 EST 2023 by jorra04
\* Created Sun Mar 05 00:41:17 EST 2023 by jorra04
