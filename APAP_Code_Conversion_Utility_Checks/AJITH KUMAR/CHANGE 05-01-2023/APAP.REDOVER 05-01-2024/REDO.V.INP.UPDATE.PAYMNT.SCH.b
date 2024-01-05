* @ValidationCode : MjotMTg1MTM1MTc4MDpDcDEyNTI6MTcwNDQzNzI1MzA0Mzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:17:33
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.UPDATE.PAYMNT.SCH
*---------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                        VM TO @VM, IF CONDITION ADDED
*12-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.STO.DUPLICATE
* $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.ACCOUNT
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_System
    $USING AA.Framework


MAIN:


    L.APPLN = 'AA.PRD.DES.PAYMENT.SCHEDULE'
    L.FIELDS = 'L.AA.PAY.METHD':@VM:'L.AA.DEBT.AC':@VM:'L.AA.PYMT.REF'
    POS.PS = ''
    CALL MULTI.GET.LOC.REF(L.APPLN,L.FIELDD,POS.PS)
    Y.POS.METHD  = POS.PS<1,1>
    Y.POS.DEB.AC = POS.PS<1,2>
    Y.AA.PMT.REF = POS.PS<1,3>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.ARC.DIR.DEB.LIST = 'F.ARC.DIR.DEB.LIST'
    F.ARC.DIR.DEB.LIST  = ''
    CALL OPF(FN.ARC.DIR.DEB.LIST,F.ARC.DIR.DEB.LIST)

    VAR.ARR.ID = R.NEW(REDO.SO.LOAN.ACCT.NO)
    Y.DEB.AC   = R.NEW(REDO.SO.ORIGIN.ACCT.NO)
    Y.START.DATE = R.NEW(REDO.SO.STO.START.DATE)

    CALL F.READ(FN.ACCOUNT,VAR.ARR.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    VAR.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    PROP.CLASS.ACC = 'PAYMENT.SCHEDULE'
*    CALL AA.GET.ARRANGEMENT.CONDITIONS(VAR.ARR.ID,PROP.CLASS.ACC,'','',returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(VAR.ARR.ID,PROP.CLASS.ACC,'','',returnIds, returnConditions, returnError);* R22 UTILITY AUTO CONVERSION

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    OFS.FUNCTION = 'I'
    PROCESS = 'PROCESS'
    OFS.SOURCE.ID = 'REDO.ARC.AUTO'
    OFSVERSION = 'AA.ARRANGEMENT.ACTIVITY,'
    GTSMODE = ''
    NO.OF.AUTH = '0'
    TRANSACTION.ID = ''
    R.APP.RECORD = ''
    OFS.STRING = ''
* R.APP.RECORD<AA.ARR.ACT.ARRANGEMENT> = VAR.ARR.ID
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActArrangement> = VAR.ARR.ID
*  R.APP.RECORD<AA.ARR.ACT.ACTIVITY> = 'LENDING-CHANGE-':returnIds
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActActivity> = 'LENDING-CHANGE-':returnIds
* R.APP.RECORD<AA.ARR.ACT.EFFECTIVE.DATE> = Y.START.DATE
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActEffectiveDate> = Y.START.DATE
*   R.APP.RECORD<AA.ARR.ACT.PRODUCT> = Y.PRODUCT.ID
*R.APP.RECORD<AA.ARR.ACT.PROPERTY> = returnIds
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActProperty> = returnIds
* R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,1> = 'L.AA.PAY.METHD'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldName,1,1> = 'L.AA.PAY.METHD'
* R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,1> = 'Direct Debit'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldValue,1,1> = 'Direct Debit'


    IF V$FUNCTION EQ 'R' THEN
        GOSUB REVERSE.FUNCTION.PARA
        RETURN
    END

* R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,2> = 'L.AA.DEBT.AC'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldName,1,2> = 'L.AA.DEBT.AC'
*R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,2> = Y.DEB.AC
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldValue,1,2> = Y.DEB.AC
*R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,3> = 'L.AA.PYMT.REF'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldName,1,3> = 'L.AA.PYMT.REF'
* R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,3> = ID.NEW
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldValue,1,3> = ID.NEW

    CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,OFS.MESSAGE)

    OFS.MSG.ID = ''
    OPTIONS = ''
    OFS.ERR = ''

    CALL OFS.POST.MESSAGE(OFS.MESSAGE,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN     ;*R22 AUTO CODE CONVERSION.START
        CUSTOMER.ID = ""    ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION.END

*    CALL F.READ(FN.ARC.DIR.DEB.LIST,CUSTOMER.ID,R.ARC.DIR.DEB.LIST,F.ARC.DIR.DEB.LIST,ARC.DIR.DEB.LIST.ERR)
    CALL F.READU(FN.ARC.DIR.DEB.LIST,CUSTOMER.ID,R.ARC.DIR.DEB.LIST,F.ARC.DIR.DEB.LIST,ARC.DIR.DEB.LIST.ERR,'');* R22 UTILITY AUTO CONVERSION
    R.ARC.DIR.DEB.LIST<-1> = ID.NEW
    CALL F.WRITE(FN.ARC.DIR.DEB.LIST,CUSTOMER.ID,R.ARC.DIR.DEB.LIST)

RETURN
**********************
REVERSE.FUNCTION.PARA:
**********************
*R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,1> = 'L.AA.PAY.METHD'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldName,1,1> = 'L.AA.PAY.METHD'
* R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,1> = 'Manual'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldValue,1,1> = 'Manual'
*R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,2> = 'L.AA.DEBT.AC'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldName,1,2> = 'L.AA.DEBT.AC'
* R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,2> = ''
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldValue,1,2> = ''
* R.APP.RECORD<AA.ARR.ACT.FIELD.NAME,1,3> = 'L.AA.PYMT.REF'
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldName,1,3> = 'L.AA.PYMT.REF'
* R.APP.RECORD<AA.ARR.ACT.FIELD.VALUE,1,3> = ID.NEW
    R.APP.RECORD<AA.Framework.ArrangementActivity.ArrActFieldValue,1,3> = ID.NEW

    CALL OFS.BUILD.RECORD(APP.NAME,OFS.FUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,TRANSACTION.ID,R.APP.RECORD,OFS.MESSAGE)

    OFS.MSG.ID = ''
    OPTIONS = ''
    OFS.ERR = ''

    CALL OFS.POST.MESSAGE(OFS.MESSAGE,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN   ;*R22 AUTO CODE CONVERSION.START
        CUSTOMER.ID = ""     ;*R22 AUTO CODE CONVERSION
    END    ;*R22 AUTO CODE CONVERSION.END

*    CALL F.READ(FN.ARC.DIR.DEB.LIST,CUSTOMER.ID,R.ARC.DIR.DEB.LIST,F.ARC.DIR.DEB.LIST,ARC.DIR.DEB.LIST.ERR)
    CALL F.READU(FN.ARC.DIR.DEB.LIST,CUSTOMER.ID,R.ARC.DIR.DEB.LIST,F.ARC.DIR.DEB.LIST,ARC.DIR.DEB.LIST.ERR,'');* R22 UTILITY AUTO CONVERSION
    LOCATE ID.NEW IN R.ARC.DIR.DEB.LIST SETTING STO.DUP.POS THEN
        DEL R.ARC.DIR.DEB.LIST<STO.DUP.POS>
        CALL F.WRITE(FN.ARC.DIR.DEB.LIST,CUSTOMER.ID,R.ARC.DIR.DEB.LIST)
    END

RETURN

END
