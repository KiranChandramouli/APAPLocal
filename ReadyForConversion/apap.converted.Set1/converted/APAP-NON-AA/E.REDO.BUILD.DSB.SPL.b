SUBROUTINE E.REDO.BUILD.DSB.SPL(ENQ.DATA)
*
* =============================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.NV.E.BALANCE
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*
*=======================================================================
*
*    First Release : Joaquin Costa
*    Developed for : APAP
*    Developed by  : Joaquin Costa
*    Date          : 2011 - MAY - 13
*
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_F.ACCOUNT
*


    GOSUB INITIALISE
    GOSUB PROCESS

INITIALISE:

    FN.REDO.STORE.DSB.DEAL.IDS = 'F.REDO.STORE.DSB.DEAL.IDS'
    F.REDO.STORE.DSB.DEAL.IDS = ''
    CALL OPF(FN.REDO.STORE.DSB.DEAL.IDS,F.REDO.STORE.DSB.DEAL.IDS)

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

*
RETURN
*--------
PROCESS:
*--------
*

    Y.AA.ID = ENQ.DATA<4,1>
    CALL F.READ(FN.AC,Y.AA.ID,R.AC,F.AC,AC.ERR)
    IF R.AC THEN
        Y.AA.ID = R.AC<AC.ARRANGEMENT.ID>
    END

    CALL F.READ(FN.REDO.STORE.DSB.DEAL.IDS,Y.AA.ID,R.REDO.STORE.DSB.DEAL.IDS,F.REDO.STORE.DSB.DEAL.IDS,DSL.ERR)

    IF R.REDO.STORE.DSB.DEAL.IDS THEN
        R.REDO.STORE.DSB.DEAL.IDS = CHANGE(R.REDO.STORE.DSB.DEAL.IDS,@FM,' ')
        ENQ.DATA<4,1>  = R.REDO.STORE.DSB.DEAL.IDS
    END

RETURN

END
