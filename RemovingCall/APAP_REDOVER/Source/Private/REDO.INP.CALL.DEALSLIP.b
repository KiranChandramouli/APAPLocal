* @ValidationCode : MjotMTE2NzIyNzMwNjpDcDEyNTI6MTY4MjQxMjMzMDA3MTpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CALL.DEALSLIP
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : Shankar Raju
*  ODR Number        : PACS00146445
*  Program   Name    : REDO.INP.CALL.DEALSLIP
*-----------------------------------------------------------------------------
* DESCRIPTION       : This is an input routine to trigger deal slip while disbursement
*-----------------------------------------------------------------------------

* 20 APR 2012       S.MARIMUTHU     PACS00146445     Deal slip printed only after overrides
* 09 JUL 2012       S.MARIMUTHU     PACS00203617     Charge deduction removed
*-----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion         VM TO @VM , If Condition added
*05-04-2023           Samaran T         Manual R22 Code Conversion        No Changes
*-------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.FC.FORM.DISB
    $INSERT I_EB.TRANS.COMMON
    $INSERT I_F.REDO.AA.DISBURSE.METHOD
    $INSERT I_DEAL.SLIP.COMMON
    $INSERT I_RC.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
*----
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
    R.REDO.CREATE.ARRANGEMENT  = ""
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

    FN.REDO.AA.DISBURSE.METHOD = 'F.REDO.AA.DISBURSE.METHOD'
    F.REDO.AA.DISBURSE.METHOD = ''
    CALL OPF(FN.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD)

    FN.REDO.STORE.DSB.DEAL.IDS = 'F.REDO.STORE.DSB.DEAL.IDS'
    F.REDO.STORE.DSB.DEAL.IDS = ''
    CALL OPF(FN.REDO.STORE.DSB.DEAL.IDS,F.REDO.STORE.DSB.DEAL.IDS)

    Y.LAST.VERSION = ""

RETURN

PROCESS:
*-------


    WVCR.TEMPLATE.ID = System.getVariable("CURRENT.Template.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
        WVCR.TEMPLATE.ID = ""  ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION

* Y.VALS.OVERRIDE = OFS$OVERRIDES<2>

*  LOCATE 'YES' IN Y.VALS.OVERRIDE<1,1> SETTING POS THEN

*  END ELSE
*      IF Y.VALS.OVERRIDE NE '' THEN
*          RETURN
*      END
*  END

    CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)
    Y.ARRNG.ID    = R.REDO.CREATE.ARRANGEMENT<REDO.FC.ID.ARRANGEMENT>
    WRCA.DIS.TYPE = R.REDO.CREATE.ARRANGEMENT<REDO.FC.DIS.TYPE>
    Y.TYP.CNT = DCOUNT(WRCA.DIS.TYPE,@VM)

    Y.LAST.DIS.TYP = WRCA.DIS.TYPE<1,Y.TYP.CNT>

    Y.VERSION.NOW = APPLICATION:PGM.VERSION

    CALL F.READ(FN.REDO.AA.DISBURSE.METHOD,Y.ARRNG.ID,R.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD,AA.ERR)
    Y.TYPE.PAY = R.REDO.AA.DISBURSE.METHOD<DIS.MET.TYPE.PAYMENT>
    Y.CNT = DCOUNT(Y.TYPE.PAY,@VM)
    WRCA.NEXT.VERSION = System.getVariable("CURRENT.WRCA.NEXT.VERSION")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
        WRCA.NEXT.VERSION = ""   ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION

*IF Y.CNT EQ Y.TYP.CNT THEN          ;* AND (OFS$OPERATION EQ 'PROCESS') THEN

    IF WRCA.NEXT.VERSION EQ 'NO' THEN
        Y.NO.OF.DISB = R.REDO.AA.DISBURSE.METHOD<DIS.MET.NO.OF.DISB>
        R.REDO.AA.DISBURSE.METHOD<DIS.MET.NO.OF.DISB> = R.REDO.AA.DISBURSE.METHOD<DIS.MET.NO.OF.DISB>+1
        CALL F.WRITE(FN.REDO.AA.DISBURSE.METHOD,Y.ARRNG.ID,R.REDO.AA.DISBURSE.METHOD)

        OFS$DEAL.SLIP.PRINTING = 1
        TEMP.ID.NEW = ID.NEW
        ID.NEW = Y.ARRNG.ID
        CALL PRODUCE.DEAL.SLIP('REDO.DISB.PAY')
        ID.NEW = TEMP.ID.NEW

        Y.HID = C$LAST.HOLD.ID
        CALL F.READ(FN.REDO.STORE.DSB.DEAL.IDS,Y.ARRNG.ID,R.REDO.STORE.DSB.DEAL.IDS,F.REDO.STORE.DSB.DEAL.IDS,STR.DE.ERR)

        IF R.REDO.STORE.DSB.DEAL.IDS THEN
            R.REDO.STORE.DSB.DEAL.IDS<-1> = Y.HID
            CALL F.WRITE(FN.REDO.STORE.DSB.DEAL.IDS,Y.ARRNG.ID,R.REDO.STORE.DSB.DEAL.IDS)
        END ELSE
            R.REDO.STORE.DSB.DEAL.IDS = Y.HID
            CALL F.WRITE(FN.REDO.STORE.DSB.DEAL.IDS,Y.ARRNG.ID,R.REDO.STORE.DSB.DEAL.IDS)
        END

    END

RETURN


END
