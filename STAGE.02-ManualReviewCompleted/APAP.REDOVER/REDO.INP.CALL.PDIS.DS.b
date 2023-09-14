* @ValidationCode : MjotNTQzMzU4MjQ0OkNwMTI1MjoxNjgwNjkyMDMxNjU3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 16:23:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CALL.PDIS.DS
******************************************************************************
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : TAM
*  ODR Number        : PACS00236823
*  Program   Name    : REDO.INP.CALL.PDIS.DS
*-----------------------------------------------------------------------------
* DESCRIPTION       : This is an input routine to trigger deal slip while disbursement
*-----------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*05-04-2023       Conversion Tool        R22 Auto Code conversion          VM TO @VM, IF CONDITION ADDED
*05-04-2023       Samaran T              Manual R22 Code Conversion        No Changes
*----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
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

    FN.REDO.AA.PART.DISBURSE.FC = 'F.REDO.AA.PART.DISBURSE.FC'
    F.REDO.AA.PART.DISBURSE.FC = ''
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)

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
    END  ;*R22 AUTO CODE CONVERSION
    CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,WVCR.TEMPLATE.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,ERR.MSJ)
    Y.ARRNG.ID    = R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.ID.ARRANGEMENT>
    WRCA.DIS.TYPE = R.REDO.AA.PART.DISBURSE.FC<REDO.PDIS.DIS.TYPE>
    Y.TYP.CNT = DCOUNT(WRCA.DIS.TYPE,@VM)

    Y.LAST.DIS.TYP = WRCA.DIS.TYPE<1,Y.TYP.CNT>

    Y.VERSION.NOW = APPLICATION:PGM.VERSION

    CALL F.READ(FN.REDO.AA.DISBURSE.METHOD,Y.ARRNG.ID,R.REDO.AA.DISBURSE.METHOD,F.REDO.AA.DISBURSE.METHOD,AA.ERR)
    Y.TYPE.PAY = R.REDO.AA.DISBURSE.METHOD<DIS.MET.TYPE.PAYMENT>
    Y.CNT = DCOUNT(Y.TYPE.PAY,@VM)
    WRCA.NEXT.VERSION = System.getVariable("CURRENT.WRCA.NEXT.VERSION")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
        WRCA.NEXT.VERSION = ""  ;*R22 AUTO CODE CONVERSION
    END  ;*R22 AUTO CODE CONVERSION

    IF WRCA.NEXT.VERSION EQ 'NO' THEN
        Y.NO.OF.DISB = R.REDO.AA.DISBURSE.METHOD<DIS.MET.NO.OF.DISB>
        R.REDO.AA.DISBURSE.METHOD<DIS.MET.NO.OF.DISB> = R.REDO.AA.DISBURSE.METHOD<DIS.MET.NO.OF.DISB>+1
        CALL F.WRITE(FN.REDO.AA.DISBURSE.METHOD,Y.ARRNG.ID,R.REDO.AA.DISBURSE.METHOD)

        OFS$DEAL.SLIP.PRINTING = 1
        TEMP.ID.NEW = ID.NEW
        ID.NEW = Y.ARRNG.ID:'-':WVCR.TEMPLATE.ID
        CALL PRODUCE.DEAL.SLIP('REDO.PDISB.PAY')
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
