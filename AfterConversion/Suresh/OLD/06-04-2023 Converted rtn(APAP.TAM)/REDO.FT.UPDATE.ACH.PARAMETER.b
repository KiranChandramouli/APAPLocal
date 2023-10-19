* @ValidationCode : Mjo2OTY1MjY0ODY6Q3AxMjUyOjE2ODA3ODI2NjYyMTM6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:34:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            FM TO @FM, VM TO @VM
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.FT.UPDATE.ACH.PARAMETER(Y.FT.ID,Y.FT.STATUS)
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.FT.UPDATE.ACH.PARAMETER.DETAIL
*------------------------------------------------------------------------------------------------------------------
*Description       :This routine updates REDO.ACH.DATE table on creation of FT for Standing orders
*Linked With       :
*In  Parameter     :
*Out Parameter     :
*ODR  Number       : 2010-08-0031
*-----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.DATES
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.REDO.ACH.PARAM
    $INSERT I_F.REDO.ACH.DATE

    IF Y.FT.STATUS EQ 'IHLD' THEN
        RETURN
    END
    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------
*********
INIT:
*********
*Initialising
    LOC.APPLICATION = 'FUNDS.TRANSFER'
    LOC.FIELDS = 'L.FT.ACH.DATE'
    LOC.POS = ''
RETURN
*-------------------------------------------------------------
*----------
OPEN.FILES:
*----------
    FN.REDO.ACH.PARAM = 'F.REDO.ACH.PARAM'
    F.REDO.ACH.PARAM = ''
    CALL OPF(FN.REDO.ACH.PARAM,F.REDO.ACH.PARAM)

    FN.REDO.INT.PARAM = 'F.REDO.INTERFACE.PARAM'
    F.REDO.INT.PARAM = ''
    CALL OPF(FN.REDO.INT.PARAM,F.REDO.INT.PARAM)

    FN.REDO.ACH.DATE = 'F.REDO.ACH.DATE'
    F.REDO.ACH.DATE = ''
    CALL OPF(FN.REDO.ACH.DATE,F.REDO.ACH.DATE)
    R.REDO.ACH.DATE = ''

    FN.REDO.DUP.ACH.DATE = 'F.REDO.DUP.ACH.DATE'
    F.REDO.DUP.ACH.DATE = ''
    CALL OPF(FN.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE)
    R.REDO.DUP.ACH.DATE = ''


    FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER=''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

RETURN
*-------
PROCESS:
*-------
    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,ERR)
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    LOC.ACH.DATE.POS = LOC.POS<1,1>
    VAR.FT.TXN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
    CALL CACHE.READ(FN.REDO.ACH.PARAM,"SYSTEM",R.REDO.ACH.PARAM,ERR.ACH.PARAM)
    IF R.REDO.ACH.PARAM THEN
        PARAM.TXN.TYPE = R.REDO.ACH.PARAM<REDO.ACH.PARAM.TXN.TYPE>
    END

    CHANGE @VM TO @FM IN PARAM.TXN.TYPE
    LOCATE VAR.FT.TXN.TYPE IN PARAM.TXN.TYPE SETTING FT.POS THEN
        VAR.REC.STATUS = R.FUNDS.TRANSFER<FT.RECORD.STATUS>
        GOSUB NORMAL.TXN
    END
RETURN
*------------------------------------------------------------------------------------------------------------
****************
NORMAL.TXN:
****************
*Getting the Debit value date and comparing with the Today
    VAR.DEBIT.VALUE.DATE = R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE>
    IF VAR.DEBIT.VALUE.DATE GT TODAY THEN
        R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.ACH.DATE.POS> = VAR.DEBIT.VALUE.DATE
    END

    IF VAR.DEBIT.VALUE.DATE LT TODAY THEN
        R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.ACH.DATE.POS> = TODAY
    END

    IF VAR.DEBIT.VALUE.DATE EQ TODAY THEN
        GOSUB CHECK.CUT.OFF.TIME
    END

    VAR.TXN.ID = R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.ACH.DATE.POS>
    CALL F.READ(FN.REDO.ACH.DATE,VAR.TXN.ID,R.REDO.ACH.DATE,F.REDO.ACH.DATE,Y.ERR.ACH.DATE)
    R.REDO.ACH.DATE<-1> = Y.FT.ID
    CALL F.WRITE(FN.REDO.ACH.DATE,VAR.TXN.ID,R.REDO.ACH.DATE)


    CALL F.READ(FN.REDO.DUP.ACH.DATE,VAR.TXN.ID,R.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE,REDO.DUP.ACH.DATE.ERR)
    R.REDO.DUP.ACH.DATE<-1> = ID.NEW
    CALL F.WRITE(FN.REDO.DUP.ACH.DATE,VAR.TXN.ID,R.REDO.DUP.ACH.DATE)
    Y.ID.NEW=ID.NEW

* PACS00313543 - STO Fix

* CALL REDO.STO.NCF(Y.ID.NEW,R.FUNDS.TRANSFER) ;*AUTO R22 CODE CONVERSION

* PACS00313543 - STO Fix

RETURN
*------------------------------------------------------------------------------------------------------------
*********************
CHECK.CUT.OFF.TIME:
*********************
*Get the cut-off time, this is in the field REP.TIME.RANGE of table REDO.ACH.PARAM, record 'ACH001'
    ACH.PARAM.ID = 'ACH001'
    VAR.NEXT.WORK.DAY=R.DATES(EB.DAT.NEXT.WORKING.DAY)
    CALL CACHE.READ(FN.REDO.INT.PARAM,ACH.PARAM.ID,R.REDO.INT.PARAM,ACH.PARAM.ERR)
    VAR.CUT.OFF.TIME = R.REDO.INT.PARAM<REDO.INT.PARAM.REP.TIME.RANGE>
    VAR.CUT.HR = VAR.CUT.OFF.TIME[1,2]
    VAR.CUT.MIN = VAR.CUT.OFF.TIME[3,2]
    LOC.TIME = TIMEDATE()
    LOC.HR = LOC.TIME[1,2]
    LOC.MIN = LOC.TIME[4,2]
    VAR.CUT.TOT.MIN = (VAR.CUT.HR*60) + VAR.CUT.MIN
    VAR.LOC.TOT.MIN = (LOC.HR * 60) + LOC.MIN
    IF VAR.LOC.TOT.MIN LE VAR.CUT.TOT.MIN THEN
        R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.ACH.DATE.POS> = TODAY
    END
    IF VAR.LOC.TOT.MIN GT VAR.CUT.TOT.MIN THEN
        R.FUNDS.TRANSFER<FT.LOCAL.REF,LOC.ACH.DATE.POS> = VAR.NEXT.WORK.DAY
    END
RETURN
END
