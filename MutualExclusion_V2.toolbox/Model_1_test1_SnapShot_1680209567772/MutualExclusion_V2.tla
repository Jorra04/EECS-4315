------------------------- MODULE MutualExclusion_V2 -------------------------
EXTENDS Integers
CONSTANT Procs
(*
--algorithm 1BitProtocol {
    variables flag = [i \in Procs |-> FALSE] ;
    fair process (P \in Procs) {
     ncs: - while (TRUE) {
            skip ; 
     enter: flag[self] := TRUE ; 
        e2: await ~ flag[1 - self] ;
        cs: skip ;
      exit: flag[self] := FALSE ;            
    }
  }
}
*)
\* BEGIN TRANSLATION (chksum(pcal) = "6d4a9177" /\ chksum(tla) = "42c2ca4c")
VARIABLES flag, pc

vars == << flag, pc >>

ProcSet == (Procs)

Init == (* Global variables *)
        /\ flag = [i \in Procs |-> FALSE]
        /\ pc = [self \in ProcSet |-> "ncs"]

ncs(self) == /\ pc[self] = "ncs"
             /\ TRUE
             /\ pc' = [pc EXCEPT ![self] = "enter"]
             /\ flag' = flag

enter(self) == /\ pc[self] = "enter"
               /\ flag' = [flag EXCEPT ![self] = TRUE]
               /\ pc' = [pc EXCEPT ![self] = "e2"]

e2(self) == /\ pc[self] = "e2"
            /\ ~ flag[1 - self]
            /\ pc' = [pc EXCEPT ![self] = "cs"]
            /\ flag' = flag

cs(self) == /\ pc[self] = "cs"
            /\ TRUE
            /\ pc' = [pc EXCEPT ![self] = "exit"]
            /\ flag' = flag

exit(self) == /\ pc[self] = "exit"
              /\ flag' = [flag EXCEPT ![self] = FALSE]
              /\ pc' = [pc EXCEPT ![self] = "ncs"]

P(self) == ncs(self) \/ enter(self) \/ e2(self) \/ cs(self) \/ exit(self)

Next == (\E self \in Procs: P(self))

Spec == /\ Init /\ [][Next]_vars
        /\ \A self \in Procs : WF_vars((pc[self] # "ncs") /\ P(self))

\* END TRANSLATION 
\* Invariant1, the Safety property.
MutualExclusion == (\A i,j \in Procs : (i # j) => ~((pc[i] = "cs")/\(pc[j] = "cs")))

=============================================================================
\* Modification History
\* Last modified Thu Mar 30 16:30:11 EDT 2023 by jorra04
\* Created Wed Mar 29 19:31:32 EDT 2023 by jorra04
