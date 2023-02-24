--------------------------- MODULE getAllSuffixes ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input
(*
--algorithm getAllSuffixes {
    variable result = <<>>, subresult = "", i = 1, j = 1;
    {
        assert Len(input) > 0;
        
        while(i < Len(input)) {
            subresult := "[";
            while(j < Len(input)) {
                if(j = Len(input) -1) {
                    subresult := Append(subresult, ToString(input[j]));
                } else {
                    subresult := Append(subresult, Append(ToString(input[j]), ", "))
                    
                };
                j := j + 1;
            };
            subresult := Append(subresult, "]");
            result:= Append(result, subresult);
            i := i + 1;
            j := i;
        };
        
        assert /\ (Len(input) = Len(result))
               /\ (result[1] = input)
               /\ (result[Len(result)] = input[Len(input)]);
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "491c598c" /\ chksum(tla) = "ed7c9528")
VARIABLES result, subresult, i, j, pc

vars == << result, subresult, i, j, pc >>

Init == (* Global variables *)
        /\ result = <<>>
        /\ subresult = ""
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ Assert(Len(input) > 0, 
                   "Failure of assertion at line 8, column 9.")
         /\ pc' = "Lbl_2"
         /\ UNCHANGED << result, subresult, i, j >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i < Len(input)
               THEN /\ subresult' = "["
                    /\ pc' = "Lbl_3"
               ELSE /\ Assert(/\ (Len(input) = Len(result))
                              /\ (result[1] = input)
                              /\ (result[Len(result)] = input[Len(input)]), 
                              "Failure of assertion at line 27, column 9.")
                    /\ pc' = "Done"
                    /\ UNCHANGED subresult
         /\ UNCHANGED << result, i, j >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF j < Len(input)
               THEN /\ IF j = Len(input) -1
                          THEN /\ subresult' = Append(subresult, ToString(input[j]))
                          ELSE /\ subresult' = Append(subresult, Append(ToString(input[j]), ", "))
                    /\ j' = j + 1
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED << result, i >>
               ELSE /\ subresult' = Append(subresult, "]")
                    /\ result' = Append(result, subresult')
                    /\ i' = i + 1
                    /\ j' = i'
                    /\ pc' = "Lbl_2"

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Fri Feb 24 04:25:47 EST 2023 by jorra04
\* Created Fri Feb 24 03:50:05 EST 2023 by jorra04
