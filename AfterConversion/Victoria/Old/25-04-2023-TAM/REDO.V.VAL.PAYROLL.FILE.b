$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.PAYROLL.FILE
*-----------------------------------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.PAYROLL.FILE
*-----------------------------------------------------------------------------------------------------------
*DESCRIPTION       :It is the input routine to validate the credit and debit accounts
*
*
*LINKED WITH       :

* ----------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                     Reference            Description
*===========        ====================       ===============     ==================
* 29-12-2010        Sakthi Sellappillai        ODR-2010-08-0031     Initial Creation
* 05-06-2010       GANESH H                    PACS00072713         MODIFICATION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     F.READ TO CACHE.READ
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.EB.FILE.UPLOAD.TYPE
    $INSERT I_F.EB.FILE.UPLOAD.PARAM
    $INSERT I_F.EB.FILE.UPLOAD
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.ENTRY.PARAM
    $INSERT I_System
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER

    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------------------------------------

    APPL.ARRAY = "EB.FILE.UPLOAD":@FM:"ACCOUNT"
    FIELD.ARRAY = "L.PR.PMT.DATE":@VM:"L.PR.DEB.ACCT":@VM:"L.PR.PMT.CUR":@VM:"L.PR.TOT.AMT":@FM:"L.AC.AV.BAL":@VM:"L.AC.STATUS1"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.LOC.PR.PMT.DATE.POS = FIELD.POS<1,1>
    Y.LOC.PR.DEB.ACCT.POS = FIELD.POS<1,2>
    Y.LOC.PR.PMT.CUR.POS  = FIELD.POS<1,3>
    Y.LOC.PR.TOT.AMT.POS  = FIELD.POS<1,4>
    Y.LOC.AC.BAL.VAL.POS  = FIELD.POS<2,1>
    Y.LOC.AC.STAT.VAL.POS = FIELD.POS<2,2>

    Y.OFS.MSG.ID.VAL = ''

    FN.FILE.UP.TYPE='F.EB.FILE.UPLOAD.TYPE'
    F.FILE.UP.TYPE=''
    R.UP.TYPE = ''
    UP.TYPE.ERR = ''
    CALL OPF(FN.FILE.UP.TYPE,F.FILE.UP.TYPE)
    FN.EB.FILE.UPLOAD.PARAM = 'F.EB.FILE.UPLOAD.PARAM'
    F.EB.FILE.UPLOAD.PARAM = ''
    R.EB.FILE.UPLOAD.PARAM = ''
    Y.EB.FILE.UPLOAD.PARMA.ERR = ''
*CALL OPF(FN.EB.FILE.UPLOAD.PARAM,F.EB.FILE.UPLOAD.PARAM) ;*Tus S/E


    FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
    F.AI.REDO.ARCIB.PARAMETER  = ''
*CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER) ;*Tus S/E

*  CALL F.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER,AI.REDO.ARCIB.PARAMETER.ERR) ;*Tus Start
    CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,AI.REDO.ARCIB.PARAMETER.ERR) ; * Tus End
    Y.PAYROLL.PMT.DAYS  = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.PAYROLL.PMT.DAYS>
    Y.SUPPLIER.PMT.DAYS = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.SUPPLIER.PMT.DAYS>
    Y.FILE.DEST.PATH    = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.UPLOAD.PATH>

*  CALL F.READ(FN.EB.FILE.UPLOAD.PARAM,'SYSTEM',R.EB.FILE.UPLOAD.PARAM,F.EB.FILE.UPLOAD.PARAM,Y.EB.FILE.UPLOAD.PARMA.ERR) ;*Tus Start
    CALL CACHE.READ(FN.EB.FILE.UPLOAD.PARAM,'SYSTEM',R.EB.FILE.UPLOAD.PARAM,Y.EB.FILE.UPLOAD.PARMA.ERR) ; * Tus End
    IF NOT(Y.EB.FILE.UPLOAD.PARMA.ERR) THEN
        Y.UPLOAD.PARAM.VAL = R.EB.FILE.UPLOAD.PARAM<EB.UP.TC.UPLOAD.PATH>
    END


    Y.UPLOAD.FILE.TYPE.VAL = R.NEW(EB.UF.UPLOAD.TYPE)
    CALL CACHE.READ(FN.FILE.UP.TYPE, Y.UPLOAD.FILE.TYPE.VAL, R.UP.TYPE, UP.TYPE.ERR)
    IF NOT(UP.TYPE.ERR) THEN
        Y.UPLOAD.DIR.VAL = R.UP.TYPE<EB.UT.UPLOAD.DIR>
    END
    Y.SYMBOL.DIR = Y.UPLOAD.DIR.VAL[1,1]
    IF Y.SYMBOL.DIR NE '/' THEN
        Y.FILE.PATH = Y.UPLOAD.PARAM.VAL:"/":Y.UPLOAD.DIR.VAL
    END ELSE
        Y.FILE.PATH = Y.UPLOAD.PARAM.VAL:Y.UPLOAD.DIR.VAL
    END

    FN.FILE.PATH = Y.FILE.PATH
    F.FILE.PATH  =''
    CALL OPF(FN.FILE.PATH,F.FILE.PATH)
    R.FILE.PATH.REC = ''
    Y.FILE.PATH.ERR = ''
    Y.UPLOAD.FILE.NAME = R.NEW(EB.UF.SYSTEM.FILE.NAME)
    Y.UPLOAD.FILE.ID = Y.UPLOAD.FILE.NAME['|',1,1]
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AC.ENTRY.PARAM='F.AC.ENTRY.PARAM'
    R.ACCOUNT.REC = ''
    Y.ACCT.ERR = ''
    Y.CUST.ACCT.ERR = ''
    Y.CUSTOMER = ''
    Y.AMOUNT = ''
    Y.COMMISSION.AMT = ''
    Y.TOTAL.AMOUNT = ''

RETURN
*-----------------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------------

    CRLF = CHARX(013):CHARX(254)
    CALL F.READ(FN.FILE.PATH,Y.UPLOAD.FILE.ID,R.FILE.PATH.REC,F.FILE.PATH,Y.FILE.PATH.ERR)
    CHANGE CRLF TO @FM IN R.FILE.PATH.REC
    Y.TOT.FILE.RECS = R.FILE.PATH.REC
    Y.TOT.CNT.VAL = DCOUNT(Y.TOT.FILE.RECS,@FM)
    Y.PAY.DATE  = R.NEW(EB.UF.LOCAL.REF)<1,Y.LOC.PR.PMT.DATE.POS>
    Y.FILE.SRC.ACCT  = R.NEW(EB.UF.LOCAL.REF)<1,Y.LOC.PR.DEB.ACCT.POS>
    Y.FILE.CURRENCY  = R.NEW(EB.UF.LOCAL.REF)<1,Y.LOC.PR.PMT.CUR.POS>

    IF Y.PAY.DATE LT TODAY THEN
        AF = EB.UF.LOCAL.REF
        AV = Y.LOC.PR.PMT.DATE.POS
        ETEXT="EB-CHECK.PAY.DATE"
        CALL STORE.END.ERROR
    END

    Y.TOT.NUM.FILES = DCOUNT(R.FILE.PATH.REC,@FM)
    Y.UPLOAD.FILE=R.FILE.PATH.REC<1>

    Y.CNT.FILE.VALUES  = DCOUNT(Y.UPLOAD.FILE,',')

    BEGIN CASE
        CASE Y.CNT.FILE.VALUES EQ 7 AND PGM.VERSION EQ ',AI.REDO.ARC.UPLOAD'
            Y.NO.OF.DAYS = 'C'
            CALL CDD('',TODAY,Y.PAY.DATE,Y.NO.OF.DAYS)
            IF Y.PAYROLL.PMT.DAYS THEN
                IF Y.NO.OF.DAYS LE Y.PAYROLL.PMT.DAYS THEN
                    AF = EB.UF.LOCAL.REF
                    AV = Y.LOC.PR.PMT.DATE.POS
                    ETEXT="EB-CHECK.PAY.DATE"
                    CALL STORE.END.ERROR
                END
            END

        CASE Y.CNT.FILE.VALUES EQ 12  AND PGM.VERSION EQ ',AI.REDO.UPLOAD.EFILE'

            Y.NO.OF.DAYS = 'C'
            CALL CDD('',TODAY,Y.PAY.DATE,Y.NO.OF.DAYS)
            IF Y.SUPPLIER.PMT.DAYS THEN
                IF Y.NO.OF.DAYS LE Y.SUPPLIER.PMT.DAYS THEN
                    AF = EB.UF.LOCAL.REF
                    AV = Y.LOC.PR.PMT.DATE.POS
                    ETEXT="EB-CHECK.PAY.DATE"
                    CALL STORE.END.ERROR
                END
            END

        CASE 1
            AF = EB.UF.SYSTEM.FILE.NAME
            ETEXT = 'EB-INVALID.FILE'
            CALL STORE.END.ERROR
    END CASE


    GOSUB ACCOUNT.ACT.CHECK
    R.NEW(EB.UF.LOCAL.REF)<1,Y.LOC.PR.TOT.AMT.POS> = Y.TOTAL.AMOUNT
RETURN
*-----------------------------------------------------------------------------------------------------------
ACCOUNT.ACT.CHECK:
*-----------------------------------------------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,Y.FILE.SRC.ACCT,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
    IF NOT(Y.ACCT.ERR) THEN
        Y.AVAIL.AMT.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,Y.LOC.AC.BAL.VAL.POS>
        Y.AC.STATUS.VAL = R.ACCOUNT.REC<AC.LOCAL.REF,Y.LOC.AC.STAT.VAL.POS>
    END ELSE
        AF = EB.UF.LOCAL.REF
        AV = Y.LOC.PR.DEB.ACCT.POS
        ETEXT = 'EB-VALID.ACCOUNT'
        CALL STORE.END.ERROR
    END
    IF Y.AC.STATUS.VAL NE 'ACTIVE' THEN
        AF = EB.UF.LOCAL.REF
        AV = Y.LOC.PR.DEB.ACCT.POS
        ETEXT = 'EB-INACT.ACCOUNT'
        CALL STORE.END.ERROR
    END
RETURN
END
*---------------------------------------------*END OF SUBROUTINE*-------------------------------------------
