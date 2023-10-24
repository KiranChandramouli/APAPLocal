* @ValidationCode : Mjo3ODE5NjE4OTU6Q3AxMjUyOjE2ODI2NjIwMTAzMzc6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 11:36:50
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
*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.UPD.FUND.DEP
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.UPD.FUND.DEP
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to post the ofs message based on teller.default record
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*28.10.2011  S SUDHARSANAN    CR.18           INITIAL CREATION
*05.01.2012  S SUDHARSANAN   PACS00167691     Modify the code
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.TELLER.DEFAULT
    $INSERT I_F.REDO.AZ.FUND.PARAM
    $INSERT I_F.REDO.TFS.PROCESS
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.T24.FUND.SERVICES

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------


    FN.REDO.TFS.PROCESS = 'F.REDO.TFS.PROCESS'
    F.REDO.TFS.PROCESS = ''
    CALL OPF(FN.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS)

    FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.DEFAULT = 'F.TELLER.DEFAULT'
    F.TELLER.DEFAULT = ''
    CALL OPF(FN.TELLER.DEFAULT,F.TELLER.DEFAULT)

    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)

    FN.REDO.AZ.FUND.PARAM = 'F.REDO.AZ.FUND.PARAM'

    LOC.REF.APPLICATION="T24.FUND.SERVICES":@FM:"TELLER"
    LOC.REF.FIELDS='L.TT.PROCESS':@FM:'T24.FS.REF':@VM:'L.TT.AZ.ACC.REF':@VM:'L.COMMENTS'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.TT.PROCESS=LOC.REF.POS<1,1>
    POS.T24.FS.REF = LOC.REF.POS<2,1>
    POS.L.TT.AZ.ACC.REF =  LOC.REF.POS<2,2>
    POS.L.COMMENTS = LOC.REF.POS<2,3>
    VAR.ID = 'SYSTEM'
    FINAL.PART = ''

    CALL CACHE.READ(FN.REDO.AZ.FUND.PARAM,VAR.ID,R.FUND.PARAM,FUND.ERR)

    Y.GENERIC.USER = R.FUND.PARAM<REDO.FUND.OFS.USER>

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    Y.PRIMARY.ACCOUNT = R.NEW(TFS.PRIMARY.ACCOUNT)<1,1>
    Y.REDO.TFS.PROCESS.ID = R.NEW(TFS.LOCAL.REF)<1,POS.L.TT.PROCESS>

    CALL F.READ(FN.REDO.TFS.PROCESS,Y.REDO.TFS.PROCESS.ID,R.REDO.TFS.PROCESS,F.REDO.TFS.PROCESS,PRO.ERR)

    VAR.PRIMARY.ACCOUNT = R.REDO.TFS.PROCESS<TFS.PRO.PRIMARY.ACCT>
    VAR.AMOUNT = R.REDO.TFS.PROCESS<TFS.PRO.TOTAL.AMOUNT>
    VAR.CURRENCY =  R.REDO.TFS.PROCESS<TFS.PRO.CURRENCY,1>
    R.AZ.ACCOUNT = '' ; AZ.ERR = ''
    CALL F.READ(FN.AZ.ACCOUNT,VAR.PRIMARY.ACCOUNT,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)

    IF R.AZ.ACCOUNT THEN
        GOSUB UPD.RECORD.ARR
        GOSUB UPD.OFS.PROCESS
    END
RETURN
*--------------------------------------------------------------------------------------------------
UPD.RECORD.ARR:
*--------------------------------------------------------------------------------------------------
    VAR.USER = OPERATOR
    CALL F.READ(FN.TELLER.USER,VAR.USER,R.TELL.USER,F.TELLER.USER,TELL.ERR)
*PACS00167691 - S
*VAR.CREATE.DATE = R.AZ.ACCOUNT<AZ.CREATE.DATE>
    VAR.CREATE.DATE = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    VAR.OUR.REF = VAR.PRIMARY.ACCOUNT:"*":VAR.CREATE.DATE
*PACS00167691 - E
    SEL.CMD = "SSELECT ":FN.TELLER.DEFAULT:" WITH @ID LIKE ":VAR.OUR.REF:"... AND TRANSACTION.REF EQ ''"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ER.REC)
    VAR.OUR.REF.ID = SEL.LIST<1>

    R.TELL = ''
    CCY.PARAM = R.FUND.PARAM<REDO.FUND.CURRENCY>
    CHANGE @VM TO @FM IN CCY.PARAM
    LOCATE VAR.CURRENCY IN CCY.PARAM SETTING CCY.POS THEN
        R.TELL<TT.TE.TRANSACTION.CODE> = R.FUND.PARAM<REDO.FUND.TRANSACTION.CODE,CCY.POS>
    END
    R.TELL<TT.TE.CURRENCY.1> = VAR.CURRENCY
    R.TELL<TT.TE.ACCOUNT.1> = Y.PRIMARY.ACCOUNT
    R.TELL<TT.TE.VALUE.DATE.1> = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    IF VAR.CURRENCY EQ LCCY THEN
        R.TELL<TT.TE.AMOUNT.LOCAL.1> = VAR.AMOUNT
    END ELSE
        R.TELL<TT.TE.AMOUNT.FCY.1> = VAR.AMOUNT
    END
    R.TELL<TT.TE.OUR.REFERENCE> = VAR.OUR.REF.ID
    R.TELL<TT.TE.VALUE.DATE.2> = R.AZ.ACCOUNT<AZ.VALUE.DATE>
    R.TELL<TT.TE.ACCOUNT.2> = VAR.PRIMARY.ACCOUNT
    R.TELL<TT.TE.LOCAL.REF,POS.T24.FS.REF> = ID.NEW
    R.TELL<TT.TE.LOCAL.REF,POS.L.TT.AZ.ACC.REF> = VAR.PRIMARY.ACCOUNT
    R.TELL<TT.TE.LOCAL.REF,POS.L.COMMENTS> = R.TELL.USER<1>

RETURN
*--------------------------------------------------------------------------------------------------
UPD.OFS.PROCESS:
*--------------------------------------------------------------------------------------------------
    APP.NAME = 'TELLER'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'TELLER,MULTI.PROCESS'
    VAR.GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''
    OFSRECORD = ''

    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'REDO.AZ.UPD'
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,VAR.GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.TELL,OFSRECORD)
********************PACS00205726-S***********************
    GOSUB UPD.FIN.COMP
    OFS.GENERIC.USER = Y.GENERIC.USER
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.GENERIC.USER)
********************PACS00205726-E***********************
RETURN
*--------------------------------------------------------------------------------------------------
UPD.FIN.COMP:
*--------------------------------------------------------------------------------------------------
    TOTAL.COMM.CNTR = DCOUNT(OFSRECORD,",")

    MODIFY.PART1 = FIELD(OFSRECORD,",",1,2)
    MODIFY.PART2 = FIELD(OFSRECORD,",",3,1)
    MODIFY.PART3 = FIELD(OFSRECORD,",",4,TOTAL.COMM.CNTR)

    TOT.MODIFY.CNT2 = DCOUNT(MODIFY.PART2,"/")

    FIRST.MOD.PART=FIELD(MODIFY.PART2,"/",1,2)
    SECOND.MOD.PART = FIELD(MODIFY.PART2,"/",3,1)
    SECOND.MOD.PART = R.COMPANY(EB.COM.FINANCIAL.COM)
    THIRD.MOD.PART=FIELD(MODIFY.PART2,"/",4,TOT.MODIFY.CNT2)
    UPD.FINAL.PART = FIRST.MOD.PART:"/":SECOND.MOD.PART:"/":THIRD.MOD.PART
    FINAL.PART = MODIFY.PART1:",":UPD.FINAL.PART:",":MODIFY.PART3

    OFSRECORD = FINAL.PART

RETURN
*--------------------------------------------------------------------------------------------------
END
