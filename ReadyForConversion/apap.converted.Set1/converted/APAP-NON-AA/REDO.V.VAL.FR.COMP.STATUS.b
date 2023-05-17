SUBROUTINE REDO.V.VAL.FR.COMP.STATUS
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : A Validation routine is written to update the STATUS Field based on the SER.AGR.PERF
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.VAL.COMP.STATUS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* *01-MAR-2010     PRABHU           HD1100464
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FRONT.COMPLAINTS
    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****

    FN.REDO.ISSUE.COMPLAINTS = 'F.REDO.ISSUE.COMPLAINTS'
    F.REDO.ISSUE.COMPLAINTS  = ''
    CALL OPF(FN.REDO.ISSUE.COMPLAINTS,F.REDO.ISSUE.COMPLAINTS)
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------

    VAR.SER.AGR.PERF = COMI
    R.NEW(FR.CM.STATUS) = VAR.SER.AGR.PERF
RETURN
*----------------------------------------------------------------------------------------------
END
