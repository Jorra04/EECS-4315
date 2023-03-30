--------------------------- MODULE getAllPrefixes ---------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input

(*
--algorithm getAllPrefixes {
    variable output = <<>>, currentPrefix = <<>>, i = 1, j = 1;
    
    {
\*        while(i <= Len(input)) {
\*            j := 1;
\*            while(j <= i) {
\*                currentPrefix := Append(currentPrefix, input[j]);
\*                j := j + 1;
\*            };
\*            
\*            output := Append(output, currentPrefix);
\*            currentPrefix := <<>>;
\*            i := i + 1;
\*        };

while(i <= Len(input)) {
            j := 1;
            while(j <= Len(input)-i + 1) {
                currentPrefix := Append(currentPrefix, input[j]);
                j := j + 1;
            };
            
            output := Append(output, currentPrefix);
            currentPrefix := <<>>;
            i := i + 1;
        };
        
        \* Assert is for v1 of the algorithm
\*        assert (\A x \in 1..Len(input) : 
\*        (\A y \in 1..x :
\*        (output[x][y] = input[y])
\*        ));

\* Assert is for v2 of the algorithm
assert (\A x \in 1..Len(input) : 
        (\A y \in 1..(Len(input)-x + 1) :
        (output[x][y] = input[y])
        ));
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "78158ea1" /\ chksum(tla) = "c7651334")
VARIABLES output, currentPrefix, i, j, pc

vars == << output, currentPrefix, i, j, pc >>

Init == (* Global variables *)
        /\ output = <<>>
        /\ currentPrefix = <<>>
        /\ i = 1
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input)
               THEN /\ j' = 1
                    /\ pc' = "Lbl_2"
               ELSE /\ Assert((\A x \in 1..Len(input) :
                               (\A y \in 1..(Len(input)-x + 1) :
                               (output[x][y] = input[y])
                               )), 
                              "Failure of assertion at line 38, column 1.")
                    /\ pc' = "Done"
                    /\ j' = j
         /\ UNCHANGED << output, currentPrefix, i >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF j <= Len(input)-i + 1
               THEN /\ currentPrefix' = Append(currentPrefix, input[j])
                    /\ j' = j + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED << output, i >>
               ELSE /\ output' = Append(output, currentPrefix)
                    /\ currentPrefix' = <<>>
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
                    /\ j' = j

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Tue Mar 07 17:07:59 EST 2023 by jorra04
\* Created Mon Mar 06 11:50:20 EST 2023 by jorra04
