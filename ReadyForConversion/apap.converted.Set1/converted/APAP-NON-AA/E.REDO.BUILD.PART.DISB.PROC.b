SUBROUTINE E.REDO.BUILD.PART.DISB.PROC(ENQ.DATA)
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.E.PART.DESEMBOLSO
* Attached as     : BUILD.ROUTINE
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : Sivakumar K
* Date            : 2013-03-19
*=======================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ARRANGEMENT
*************************************************************************

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

*==========
INITIALISE:
*==========

    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    CALL OPF(FN.AA.ARR,F.AA.ARR)

RETURN

*=======
PROCESS:
*=======

    LOCATE 'ID.ARRANGEMENT' IN ENQ.DATA<2,1> SETTING AA.POS THEN
        CALL F.READ(FN.AA.ARR,ENQ.DATA<4,1>,R.ARRANGEMENT,F.AA.ARR,AA.ARR.ERR)
        IF R.ARRANGEMENT THEN
            ENQ.DATA<2,1> = 'LOAN.AC'
            ENQ.DATA<4,1> = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        END
    END

RETURN

END
