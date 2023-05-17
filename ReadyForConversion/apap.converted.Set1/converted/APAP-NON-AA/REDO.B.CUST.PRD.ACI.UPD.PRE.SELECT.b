SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.PRE.SELECT
****************************************************************
*  originally SUBROUTINE REDO.B.CUST.PRD.ACI.UPD.SELECT
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.CUST.PRD.ACI.UPD.SELECT
* ODR NO        : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.CUST.PRD.ACI.UPD

* 27/apr/2012 : Shek : Performance tuning
*             : Check account/redo records are moved to run routine,
*               to avoid multiple reads and multithreading the checks

* In parameter : None
* out parameter : None

*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.DATES
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.REDO.ACC.CR.INT
    $INSERT I_REDO.B.CUST.PRD.ACI.UPD.COMMON

    GOSUB PROCESS

RETURN
*--------------------------
PROCESS:
*--------------------------

    PREV.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    SEL.CMD = "SELECT ":FN.REDO.CUST.PRD.LIST:" WITH PROCESS.DATE EQ ":PREV.WORKING.DAY


    PROCESS.LIST = ''
    PROCESS.LIST<3> = SEL.CMD

    CALL BATCH.BUILD.LIST(PROCESS.LIST,"")

RETURN

END
