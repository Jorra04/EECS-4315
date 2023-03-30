----------------------------- MODULE PT2_Task2 -----------------------------
EXTENDS Integers, Sequences, TLC
CONSTANT input
(*
--algorithm getGroupedNumbers {
    variables numberOfMultiplesOf3 = 0,
    numberOfMultiplesOf3Plus1 = 0,
    numberOfMultiplesOf3Plus2 = 0,
    temp0 = <<>>, temp1 = <<>>, temp2 = <<>>,
    output = <<>>,
    i = 1, remainder = 0, j = 1;
    {
\*        while (i <= Len(input)) {
\*        remainder := input[i] % 3;
\*        if(remainder = 0) {
\*            temp0 := temp0 \o <<input[i]>>;
\*            numberOfMultiplesOf3 := numberOfMultiplesOf3 + 1;
\*        }
\*        else if(remainder = 1) {
\*            temp1 := temp1 \o <<input[i]>>;
\*            numberOfMultiplesOf3Plus1 := numberOfMultiplesOf3Plus1 + 1;
\*        }
\*        else { \* remainder = 2
\*            temp2 := temp2 \o <<input[i]>>;
\*            numberOfMultiplesOf3Plus2 := numberOfMultiplesOf3Plus2 + 1;
\*        };
\*            i := i + 1;
\*        };
\*        while (j <= Len(temp0)) {
\*            output := output \o <<temp0[j]>>;
\*            j := j + 1;
\*        };
\*        j := 1;
\*        while (j <= Len(temp1)) {
\*            output := output \o <<temp1[j]>>;
\*            j := j + 1;
\*        };
\*        j := 1;
\*        while (j <= Len(temp2)) {
\*            output := output \o <<temp2[j]>>;
\*            j := j + 1;
\*        };
            output := input;
        
        (*
        For these assertions, we know that if it satisfies property 1, then all elements prior should too.
        if it satisfies property 2, then all elements prior should satisfy property 1 or property 2
        if it satisfied property 3, then all elements prior should satisfy property 1, property 2 or property 3.
        *)
        
        \* Assertion 1
\*        assert (\A k \in 1..Len(input) : 
\*        (input[k] % 3 = 0) => (\A l \in 1..k) : (input[l] % 3 = 0));

\*            assert (\A k \in 1..Len(input) :
\*            (input[k] % 3 = 0) => ((\A l \in 1..k) : (input[l] % 3 = 0))
\*            ); 
        assert (\A k \in 1..Len(input) :
        (output[k] % 3 = 0) => ((\A l \in 1..k : output[l] % 3 = 0))
        );
        
        assert (\A k \in 1..Len(input) :
        (output[k] % 3 = 1) => ((\A l \in 1..k : ((output[l] % 3 = 0) \/ (output[l] % 3 = 1) )))
        );
        assert (\A k \in 1..Len(input) :
        (output[k] % 3 = 2) => ((\A l \in 1..k : ((output[l] % 3 = 0) \/ (output[l] % 3 = 1) \/ (output[l] % 3 = 2) )))
        );           
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "e475fcc2" /\ chksum(tla) = "7b2ef08a")
VARIABLES numberOfMultiplesOf3, numberOfMultiplesOf3Plus1, 
          numberOfMultiplesOf3Plus2, temp0, temp1, temp2, output, i, 
          remainder, j, pc

vars == << numberOfMultiplesOf3, numberOfMultiplesOf3Plus1, 
           numberOfMultiplesOf3Plus2, temp0, temp1, temp2, output, i, 
           remainder, j, pc >>

Init == (* Global variables *)
        /\ numberOfMultiplesOf3 = 0
        /\ numberOfMultiplesOf3Plus1 = 0
        /\ numberOfMultiplesOf3Plus2 = 0
        /\ temp0 = <<>>
        /\ temp1 = <<>>
        /\ temp2 = <<>>
        /\ output = <<>>
        /\ i = 1
        /\ remainder = 0
        /\ j = 1
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ output' = input
         /\ Assert(       (\A k \in 1..Len(input) :
                   (output'[k] % 3 = 0) => ((\A l \in 1..k : output'[l] % 3 = 0))
                   ), "Failure of assertion at line 58, column 9.")
         /\ Assert(       (\A k \in 1..Len(input) :
                   (output'[k] % 3 = 1) => ((\A l \in 1..k : ((output'[l] % 3 = 0) \/ (output'[l] % 3 = 1) )))
                   ), "Failure of assertion at line 62, column 9.")
         /\ Assert(       (\A k \in 1..Len(input) :
                   (output'[k] % 3 = 2) => ((\A l \in 1..k : ((output'[l] % 3 = 0) \/ (output'[l] % 3 = 1) \/ (output'[l] % 3 = 2) )))
                   ), "Failure of assertion at line 65, column 9.")
         /\ pc' = "Done"
         /\ UNCHANGED << numberOfMultiplesOf3, numberOfMultiplesOf3Plus1, 
                         numberOfMultiplesOf3Plus2, temp0, temp1, temp2, i, 
                         remainder, j >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Thu Mar 30 17:50:22 EDT 2023 by jorra04
\* Created Thu Mar 30 17:19:39 EDT 2023 by jorra04
