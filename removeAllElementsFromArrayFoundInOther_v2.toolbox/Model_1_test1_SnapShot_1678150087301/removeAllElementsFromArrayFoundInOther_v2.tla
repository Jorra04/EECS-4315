------------- MODULE removeAllElementsFromArrayFoundInOther_v2 -------------
EXTENDS Integers, Sequences, TLC
CONSTANT input1, input2

(*
--algorithm removeAllElemsInBothTuples {
    variable i = 1, output = <<>>, input1Set = {}, input2Set = {}, complementSet = {};
    
    {
        while(i <= Len(input1)) {
        input1Set := input1Set \union {input1[i]};
        i := i + 1;
    };
    i:=1;
    while(i <= Len(input2)) {
        input2Set := input2Set \union {input2[i]};
        i := i + 1;
    };
    
    complementSet := input1Set \ input2Set;
    i := 1;
    
    while(i <= Len(input1)) {
      if(input1[i] \in complementSet) {
        output := Append(output, input1[i]);
        i := i + 1;
      };  
      };
      
      output:= Seq(complementSet);
      
      
      assert (\A x \in 1..Len(output) : 
        (\E y \in 1..Len(input1) : (output[x] = input1[y]))
        );
        \* next assert is to ensure that all elements in the output are not present in input2
        assert (\A x \in 1..Len(output) : 
        ~(\E y \in 1..Len(input2) : output[x] = input2[y])
        );
    }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "cc0873a3" /\ chksum(tla) = "67c6dc60")
VARIABLES i, output, input1Set, input2Set, complementSet, pc

vars == << i, output, input1Set, input2Set, complementSet, pc >>

Init == (* Global variables *)
        /\ i = 1
        /\ output = <<>>
        /\ input1Set = {}
        /\ input2Set = {}
        /\ complementSet = {}
        /\ pc = "Lbl_1"

Lbl_1 == /\ pc = "Lbl_1"
         /\ IF i <= Len(input1)
               THEN /\ input1Set' = (input1Set \union {input1[i]})
                    /\ i' = i + 1
                    /\ pc' = "Lbl_1"
               ELSE /\ i' = 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED input1Set
         /\ UNCHANGED << output, input2Set, complementSet >>

Lbl_2 == /\ pc = "Lbl_2"
         /\ IF i <= Len(input2)
               THEN /\ input2Set' = (input2Set \union {input2[i]})
                    /\ i' = i + 1
                    /\ pc' = "Lbl_2"
                    /\ UNCHANGED complementSet
               ELSE /\ complementSet' = input1Set \ input2Set
                    /\ i' = 1
                    /\ pc' = "Lbl_3"
                    /\ UNCHANGED input2Set
         /\ UNCHANGED << output, input1Set >>

Lbl_3 == /\ pc = "Lbl_3"
         /\ IF i <= Len(input1)
               THEN /\ IF input1[i] \in complementSet
                          THEN /\ output' = Append(output, input1[i])
                               /\ i' = i + 1
                          ELSE /\ TRUE
                               /\ UNCHANGED << i, output >>
                    /\ pc' = "Lbl_3"
               ELSE /\ output' = Seq(complementSet)
                    /\ Assert(     (\A x \in 1..Len(output') :
                              (\E y \in 1..Len(input1) : (output'[x] = input1[y]))
                              ), 
                              "Failure of assertion at line 33, column 7.")
                    /\ Assert(       (\A x \in 1..Len(output') :
                              ~(\E y \in 1..Len(input2) : output'[x] = input2[y])
                              ), 
                              "Failure of assertion at line 37, column 9.")
                    /\ pc' = "Done"
                    /\ i' = i
         /\ UNCHANGED << input1Set, input2Set, complementSet >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Lbl_1 \/ Lbl_2 \/ Lbl_3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

=============================================================================
\* Modification History
\* Last modified Mon Mar 06 19:47:58 EST 2023 by jorra04
\* Created Mon Mar 06 19:12:36 EST 2023 by jorra04
