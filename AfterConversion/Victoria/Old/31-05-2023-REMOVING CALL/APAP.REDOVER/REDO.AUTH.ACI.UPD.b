* @ValidationCode : MjotOTM1NzIwOTE5OkNwMTI1MjoxNjgyNDEyMzI3NjIwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:27
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
*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.AUTH.ACI.UPD
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.AUTH.ACI.UPD
* ODR Number    : ODR-2009-10-0317
*-----------------------------------------------------------------------------
* Description :This validation routine REDO.AUTH.ACI.UPD which will be executed during
* authorization of version record.When the status changes the system will determine what
* interest conditions should be applied (effective from the time the status changed).The
* interest conditions will be defined in the new template. The information relating to new
* interest rate, status and date of status changed will be record for audit purposed.These
* new fields will only be updated if a condition for the new status exists on the new template
* If no new condition exists then the interest rate will not be changed and the status
* applicable for interest will not be changed When the manually update field is set to yes
* this routine will automatically update the ACCOUNTs (ACI) record

* Linked with: ACCOUNT,TEST
* In parameter : None
* out parameter : None
**---------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO           REFERENCE                  DESCRIPTION
*08.09.2010  S SUDHARSANAN      HD1036878                  INITIAL CREATION
*28-03-2011  S SUDHARSANAN   PACS00033264/65              Check the status1 value based on EB.LOOKUP ID
*16-06-2011  S SUDHARSANAN     PACS00024017              Comment the lines based on issue
*16-08-2011  SHANKAR RAJU      PACS00101170                Adding check to restrict updating ACI while creating account
*04-04-2023  Conversion Tool  R22 Auto Code conversion      No Changes
*04-04-2023  Samaran T        Manual R22 Code Conversion    VM TO @VM ,SM TO @SM

*----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.REDO.ACC.CR.INT
*
    GOSUB INIT
    GOSUB PROCESS
RETURN
*
*----------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------
*
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ACCOUNT.CREDIT.INT='F.ACCOUNT.CREDIT.INT'
    F.ACCOUNT.CREDIT.INT=''
    CALL OPF(FN.ACCOUNT.CREDIT.INT,F.ACCOUNT.CREDIT.INT)

    FN.REDO.ACC.CR.INT='F.REDO.ACC.CR.INT'
    F.REDO.ACC.CR.INT=''
    CALL OPF(FN.REDO.ACC.CR.INT,F.REDO.ACC.CR.INT)

    FN.BASIC.INTEREST='F.BASIC.INTEREST'
    F.BASIC.INTEREST=''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    LREF.APP='ACCOUNT'
    LREF.FIELD='L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.STAT.INT.RATE':@VM:'L.DATE.INT.UPD':@VM:'L.AC.MAN.UPD' ;*R22 MANUAL CODE CONVERSION
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.L.AC.STATUS1=LREF.POS<1,1>
    POS.L.AC.STATUS2=LREF.POS<1,2>
    POS.L.STAT.INT.RATE=LREF.POS<1,3>
    POS.L.DATE.INT.UPD=LREF.POS<1,4>
    POS.L.AC.MAN.UPD=LREF.POS<1,5>

RETURN
*
*----------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
*

    Y.STATUS2=R.NEW(AC.LOCAL.REF)<1,POS.L.AC.STATUS2>
    Y.MANUAL.UPD=R.NEW(AC.LOCAL.REF)<1,POS.L.AC.MAN.UPD>
    Y.ACCT.NO=ID.NEW

    SM.CNT=DCOUNT(Y.STATUS2,@SM) ;*R22 MANUAL CODE CONVERSION

*PACS00033264 - S
    IF R.NEW(AC.LOCAL.REF)<1,POS.L.AC.STATUS2,SM.CNT> NE R.OLD(AC.LOCAL.REF)<1,POS.L.AC.STATUS2,SM.CNT> THEN
        Y.NEW.STATUS=R.NEW(AC.LOCAL.REF)<1,POS.L.AC.STATUS2,SM.CNT>
    END ELSE
        IF R.NEW(AC.LOCAL.REF)<1,POS.L.AC.STATUS1> NE R.OLD(AC.LOCAL.REF)<1,POS.L.AC.STATUS1> THEN
            Y.NEW.STATUS=R.NEW(AC.LOCAL.REF)<1,POS.L.AC.STATUS1>
        END
    END
    Y.CATEGORY=R.NEW(AC.CATEGORY)
* Y.UPD.STATUS=TRIM(Y.UPD.STATUS," ","A")
    Y.UPD.STATUS = Y.NEW.STATUS
    IF Y.UPD.STATUS EQ 'ACTIVE' THEN
        R.NEW(AC.WAIVE.LEDGER.FEE) = ''
    END
*PACS00033264 - E


*PACS00101170 - S
    Y.REC.STAT = R.NEW(AC.RECORD.STATUS)
    Y.CURR.NO  = R.NEW(AC.CURR.NO)

    IF Y.CURR.NO GT 1 THEN
        Y.REDO.ACI.ID=Y.CATEGORY:'.':Y.UPD.STATUS
        R.REDO.ACC.CR.INT=''
        REDO.ACI.ERR=''
        CALL F.READ(FN.REDO.ACC.CR.INT,Y.REDO.ACI.ID,R.REDO.ACC.CR.INT,F.REDO.ACC.CR.INT,REDO.ACI.ERR)
        IF R.REDO.ACC.CR.INT NE '' THEN
            IF Y.MANUAL.UPD NE 'YES' THEN
                Y.DATE=TODAY
                GOSUB ACI.UPD
            END
        END
    END
*PACS00101170 - E

RETURN
*--------------------------------------------------------------------------------
ACI.UPD:
*---------------------------------------------------------------------------------

    Y.ACI.ID=Y.ACCT.NO:'-':Y.DATE

    R.ACI.RECORD<IC.ACI.INTEREST.DAY.BASIS>=R.REDO.ACC.CR.INT<ACI.INTEREST.DAY.BASIS>
    R.ACI.RECORD<IC.ACI.TAX.KEY>=R.REDO.ACC.CR.INT<ACI.TAX.KEY>
    R.ACI.RECORD<IC.ACI.CR.BALANCE.TYPE>=R.REDO.ACC.CR.INT<ACI.CR.BALANCE.TYPE>
    R.ACI.RECORD<IC.ACI.CR.CALCUL.TYPE>=R.REDO.ACC.CR.INT<ACI.CR.CALCUL.TYPE>
    R.ACI.RECORD<IC.ACI.CR.MINIMUM.BAL>=R.REDO.ACC.CR.INT<ACI.CR.MINIMUM.BAL>
    R.ACI.RECORD<IC.ACI.CR.OFFSET.ONLY>=R.REDO.ACC.CR.INT<ACI.CR.OFFSET.ONLY>

    BEGIN CASE
        CASE R.REDO.ACC.CR.INT<ACI.CR.BASIC.RATE> NE ''
            CNT = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR.BASIC.RATE>,@VM) ;*R22 MANUAL CODE CONVERSION
        CASE R.REDO.ACC.CR.INT<ACI.CR.INT.RATE> NE ''
            CNT = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR.INT.RATE>,@VM) ;*R22 MANUAL CODE CONVERSION
    END CASE

    FOR BAS.CNT = 1 TO CNT
        R.ACI.RECORD<IC.ACI.CR.BASIC.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.BASIC.RATE,BAS.CNT>
        R.ACI.RECORD<IC.ACI.CR.INT.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.INT.RATE,BAS.CNT>
        R.ACI.RECORD<IC.ACI.CR.MARGIN.OPER,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.MARGIN.OPER,BAS.CNT>
        R.ACI.RECORD<IC.ACI.CR.MAX.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.MAX.RATE,BAS.CNT>
        R.ACI.RECORD<IC.ACI.CR.MARGIN.RATE,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.MARGIN.RATE,BAS.CNT>
        R.ACI.RECORD<IC.ACI.CR.LIMIT.AMT,BAS.CNT>=R.REDO.ACC.CR.INT<ACI.CR.LIMIT.AMT,BAS.CNT>
    NEXT BAS.CNT

    R.ACI.RECORD<IC.ACI.CR2.BALANCE.TYPE>=R.REDO.ACC.CR.INT<ACI.CR2.BALANCE.TYPE>
    R.ACI.RECORD<IC.ACI.CR2.CALCUL.TYPE>=R.REDO.ACC.CR.INT<ACI.CR2.CALCUL.TYPE>
    R.ACI.RECORD<IC.ACI.CR2.MINIMUM.BAL>=R.REDO.ACC.CR.INT<ACI.CR2.MINIMUM.BAL>
    R.ACI.RECORD<IC.ACI.CR2.OFFSET.ONLY>=R.REDO.ACC.CR.INT<ACI.CR2.OFFSET.ONLY>

    BEGIN CASE
        CASE R.REDO.ACC.CR.INT<ACI.CR2.BASIC.RATE> NE ''
            CNT1 = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR2.BASIC.RATE>,@VM) ;*R22 MANUAL CODE CONVERSION
        CASE R.REDO.ACC.CR.INT<ACI.CR2.INT.RATE> NE ''
            CNT1 = DCOUNT(R.REDO.ACC.CR.INT<ACI.CR2.INT.RATE>,@VM) ;*R22 MANUAL CODE CONVERSION
    END CASE

    FOR BAS2.CNT=1 TO CNT1
        R.ACI.RECORD<IC.ACI.CR2.BASIC.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.BASIC.RATE,BAS2.CNT>
        R.ACI.RECORD<IC.ACI.CR2.INT.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.INT.RATE,BAS2.CNT>
        R.ACI.RECORD<IC.ACI.CR2.MARGIN.OPER,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.MARGIN.OPER,BAS2.CNT>
        R.ACI.RECORD<IC.ACI.CR2.MAX.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.MAX.RATE,BAS2.CNT>
        R.ACI.RECORD<IC.ACI.CR2.MAX.RATE,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.MARGIN.RATE,BAS2.CNT>
        R.ACI.RECORD<IC.ACI.CR2.LIMIT.AMT,BAS2.CNT>=R.REDO.ACC.CR.INT<ACI.CR2.LIMIT.AMT,BAS2.CNT>
    NEXT BAS2.CNT ;*R22 MANUAL CODE CONVERSION

    R.ACI.RECORD<IC.ACI.INTEREST.TAX.MIN>=R.REDO.ACC.CR.INT<ACI.INTEREST.TAX.MIN>
    R.ACI.RECORD<IC.ACI.NET.TAX>=R.REDO.ACC.CR.INT<ACI.NET.TAX>
    R.ACI.RECORD<IC.ACI.CR.MIN.BAL.ST.DTE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.BAL.ST.DTE>
    R.ACI.RECORD<IC.ACI.CR.MIN.BAL.ED.DTE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.BAL.ED.DTE>
    R.ACI.RECORD<IC.ACI.CR.ACCR.OPEN.AC>=R.REDO.ACC.CR.INT<ACI.CR.ACCR.OPEN.AC>
    R.ACI.RECORD<IC.ACI.CR.ACCR.CLOSE.AC>=R.REDO.ACC.CR.INT<ACI.CR.ACCR.CLOSE.AC>
    R.ACI.RECORD<IC.ACI.CR2.MIN.BAL.ST.DTE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.BAL.ST.DTE>
    R.ACI.RECORD<IC.ACI.CR2.MIN.BAL.ED.DTE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.BAL.ED.DTE>
    R.ACI.RECORD<IC.ACI.CR2.ACCR.OPEN.AC>=R.REDO.ACC.CR.INT<ACI.CR2.ACCR.OPEN.AC>
    R.ACI.RECORD<IC.ACI.CR2.ACCR.CLOSE.AC>=R.REDO.ACC.CR.INT<ACI.CR2.ACCR.CLOSE.AC>
    R.ACI.RECORD<IC.ACI.CR.MIN.VALUE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.VALUE>
    R.ACI.RECORD<IC.ACI.CR.MIN.WAIVE>=R.REDO.ACC.CR.INT<ACI.CR.MIN.WAIVE>
    R.ACI.RECORD<IC.ACI.CR2.MIN.VALUE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.VALUE>
    R.ACI.RECORD<IC.ACI.CR2.MIN.WAIVE>=R.REDO.ACC.CR.INT<ACI.CR2.MIN.WAIVE>
    R.ACI.RECORD<IC.ACI.CR.ZERO.INT.BAL>=R.REDO.ACC.CR.INT<ACI.CR.ZERO.INT.BAL>
    R.ACI.RECORD<IC.ACI.CR.ZERO.INT.OC>=R.REDO.ACC.CR.INT<ACI.CR.ZERO.INT.OC>
    R.ACI.RECORD<IC.ACI.CR2.ZERO.INT.BAL>=R.REDO.ACC.CR.INT<ACI.CR2.ZERO.INT.BAL>
    R.ACI.RECORD<IC.ACI.CR2.ZERO.INT.OC>=R.REDO.ACC.CR.INT<ACI.CR2.ZERO.INT.OC>
    R.ACI.RECORD<IC.ACI.NEGATIVE.RATES>=R.REDO.ACC.CR.INT<ACI.NEGATIVE.RATES>
    R.ACI.RECORD<IC.ACI.COMPOUND.TYPE>=R.REDO.ACC.CR.INT<ACI.COMPOUND.TYPE>

    APP.NAME = 'ACCOUNT.CREDIT.INT'
    OFSFUNCT = 'I'
    PROCESS  = 'PROCESS'
    OFSVERSION = 'ACCOUNT.CREDIT.INT,'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = Y.ACI.ID
    OFSRECORD = ''

    OFS.MSG.ID =''
    OFS.SOURCE.ID = 'REDO.OFS.ACI.UPDATE'
    OFS.ERR = ''

    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.ACI.RECORD,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN
*
*-------------------------------------------------------------------------
END
