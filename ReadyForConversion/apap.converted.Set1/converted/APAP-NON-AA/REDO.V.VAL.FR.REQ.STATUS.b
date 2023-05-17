SUBROUTINE REDO.V.VAL.FR.REQ.STATUS
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
* PROGRAM NAME : REDO.V.VAL.REQ.STATUS
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE         DESCRIPTION
* 27.07.2010      SUDHARSANAN S     ODR-2009-12-0283  INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FRONT.REQUESTS
*    GOSUB INIT
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    FN.REDO.FRONT.REQUESTS = 'F.REDO.FRONT.REQUESTS'
    F.REDO.FRONT.REQUESTS  = ''
    CALL OPF(FN.REDO.FRONT.REQUESTS,F.REDO.FRONT.REQUESTS)
RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------------------------------

    VAR.SER.AGR.PERF      = COMI
    R.NEW(FR.CM.STATUS) = VAR.SER.AGR.PERF
RETURN
*----------------------------------------------------------------------------------------------
END
