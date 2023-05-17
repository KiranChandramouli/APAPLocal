SUBROUTINE REDO.CHANGE.CHEQ.STATUS.SELECT
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : HARISH.Y
* PROGRAM NAME : REDO.CHANGE.CHEQ.STATUS.SELECT
*----------------------------------------------------------
* DESCRIPTION : It will be required to create REDO.CHANGE.CHEQ.STATUS.SELECT
* as a SELECT routine for BATCH

*------------------------------------------------------------

*    LINKED WITH : REDO.CHANGE.CHEQ.STATUS
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*03.04.2010      HARISH.Y     ODR-2009-12-0275  INITIAL CREATION

*-------------------------------------------------------------
*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CHEQUE.ISSUE
    $INSERT I_F.REDO.H.SOLICITUD.CK
    $INSERT I_F.REDO.H.CHEQ.CHANGE.PARAM
    $INSERT I_REDO.CHANGE.CHEQ.STATUS.COMMON

    GOSUB PERFORM.SELECT
RETURN

*-------------------------------------------------------------
PERFORM.SELECT:
*-------------------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.H.SOLICITUD.CK :" WITH CHEQUE.STATUS EQ 40"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,CK.ERR)
    CALL BATCH.BUILD.LIST('', SEL.LIST)
RETURN
END
