* @ValidationCode : Mjo4ODgxNDgyNzpDcDEyNTI6MTY4MTIwNzk4MDg0Mjphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 15:43:00
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   VM to @VM , FM to @FM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.APAP.AUTH.UPDATE
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH
* Program Name  : REDO.APAP.AUTH.UPDATE
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
* Description   : REDO.APAP.AUTH.UPDATE is an authorisation routine for the version
*                 FOREX,REDO.APAP.SPOTDEAL and FOREX,REDO.APAP.FORWARDDEAL the routine updates  table
*                 local reference fields L.FX.INPUT.ID and L.FX.AUTH.ID with the fields INPUTER AND AUTHORISER
*                 respectively
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_RC.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.FX.DEAL.ID.LOG
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*
*****
INIT:
*****
*
    FN.FOREX = 'F.FOREX'
    F.FOREX  = ''
    CALL OPF(FN.FOREX, F.FOREX)
*
    FN.FX.DEAL.ID.LOG = 'F.FX.DEAL.ID.LOG'
    F.FX.DEAL.ID.LOG  = ''
    CALL OPF(FN.FX.DEAL.ID.LOG, F.FX.DEAL.ID.LOG)
*
    Y.LRF.APPL   = "FOREX"
    Y.LRF.FIELDS = 'L.FX.INPUT.ID':@VM:'L.FX.AUTH.ID'
    FIELD.POS    = ''
*
    CALL MULTI.GET.LOC.REF(Y.LRF.APPL, Y.LRF.FIELDS, FIELD.POS)
*
    Y.FX.INPUT.ID = FIELD.POS<1,1>
    Y.FX.AUTH.ID  = FIELD.POS<1,2>
    Y.ID          = ''
*
RETURN
*

********
PROCESS:
********
*
    IF R.NEW(FX.DEAL.TYPE) NE 'SP' AND R.NEW(FX.DEAL.TYPE) NE 'FW' THEN
        RETURN
    END
*
    IF V$FUNCTION EQ 'A' THEN
*
        Y.INPUT        = R.NEW(FX.INPUTTER)
        Y.AUTH.NAME    = OPERATOR
        Y.INPUT.NAME   = FIELD(Y.INPUT,'_',2)
        Y.CURR.NO      = R.NEW(FX.CURR.NO)
*
        R.NEW(FX.LOCAL.REF)<1, Y.FX.INPUT.ID, Y.CURR.NO> = Y.INPUT.NAME
*
        R.NEW(FX.LOCAL.REF)<1, Y.FX.AUTH.ID, Y.CURR.NO>  = Y.AUTH.NAME
*
        DEAL.SLIP.ID = 'FX.DEAL.TICKET'
        OFS$DEAL.SLIP.PRINTING = 1
        CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.ID)
        Y.DEAL.SLIP.ID = C$LAST.HOLD.ID
        CHANGE ',' TO @FM IN Y.DEAL.SLIP.ID
        IF LEN(Y.DEAL.SLIP.ID<1>) EQ '17' THEN
            Y.DEAL.SLIP.ID = Y.DEAL.SLIP.ID<1>
        END ELSE
            Y.DEAL.SLIP.ID = Y.DEAL.SLIP.ID<2>
        END
*
    END
*
    Y.ID = ID.NEW
*
    Y.COUNT.CURR.NO = Y.CURR.NO
    R.REC.FX.DEAL.ID.LOG = ''
    CALL F.READ(FN.FX.DEAL.ID.LOG, Y.ID, R.REC.FX.DEAL.ID.LOG, F.FX.DEAL.ID.LOG, Y.ERR.FX.DEAL.ID.LOG)
*
    R.REC.FX.DEAL.ID.LOG<DEAL.ID.FX.CURR.NO, Y.COUNT.CURR.NO>   = Y.CURR.NO
    R.REC.FX.DEAL.ID.LOG<DEAL.ID.DEAL.SLIP.ID, Y.COUNT.CURR.NO> = Y.DEAL.SLIP.ID
*
    CALL F.WRITE(FN.FX.DEAL.ID.LOG, Y.ID, R.REC.FX.DEAL.ID.LOG)
*
RETURN
*
END
