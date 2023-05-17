SUBROUTINE REDO.APAP.CONV.LAST.TRANS.DATE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.LAST.TRANS.DATE
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to fetch the value of LAST.TRANS.DATE from ACCOUNT
*Linked With  :
*In Parameter : O.DATA
*Out Parameter: O.DATA
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  Date            Who                        Reference                    Description
* ------          ------                      -------------                -------------
* 12-11-2010      Sakthi Sellappillai         ODR-2010-08-0173 N.73       Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN
*---------------------------
INITIALISE:
*---------------------------
    Y.ACCOUNT.ID = O.DATA
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    R.ACCOUNT.REC = ''
    Y.ACCT.ERR = ''
    FN.ACCOUNT$HIS = 'F.ACCOUNT$HIS'
    F.ACCOUNT$HIS = ''
    CALL OPF(FN.ACCOUNT$HIS,F.ACCOUNT$HIS)
    R.ACCOUNT.HIS.REC = ''
    Y.ACCOUNT.HIS.ERR = ''
    Y.ACT.DATE = ''
    Y.LAST.CRD.DATE = ''
    Y.LAST.DBT.DATE = ''
    Y.ACT.DATE.VAL = ''
RETURN
*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
    Y.HIS.ACCT.ID = ''
    Y.HIS.SYM.VAL = FIELD(Y.ACCOUNT.ID,';',2,1)
    IF Y.HIS.SYM.VAL THEN
        Y.HIS.ACCT.ID = FIELD(Y.ACCOUNT.ID,';',1,1)
        CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,Y.HIS.ACCT.ID,R.ACCOUNT.HIS.REC,Y.ACCOUNT.HIS.ERR)
        IF NOT(Y.ACCOUNT.HIS.ERR) THEN
            Y.LAST.CRD.DATE = R.ACCOUNT.HIS.REC<AC.DATE.LAST.CR.CUST>
            Y.LAST.DBT.DATE = R.ACCOUNT.HIS.REC<AC.DATE.LAST.DR.CUST>
        END
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
        IF NOT(Y.ACCT.ERR) THEN
            Y.LAST.CRD.DATE = R.ACCOUNT.REC<AC.DATE.LAST.CR.CUST>
            Y.LAST.DBT.DATE = R.ACCOUNT.REC<AC.DATE.LAST.DR.CUST>
        END
    END
    IF Y.LAST.CRD.DATE NE '' AND Y.LAST.DBT.DATE NE '' THEN
        IF Y.LAST.CRD.DATE GE Y.LAST.DBT.DATE THEN
            Y.ACT.DATE  = Y.LAST.CRD.DATE
*Y.ACT.DATE = ICONV(Y.ACT.DATE, "DI")
*Y.ACT.DATE = OCONV(Y.ACT.DATE, "D4")
            Y.ACT.DATE.VAL = Y.ACT.DATE
        END ELSE
            Y.ACT.DATE = Y.LAST.DBT.DATE
*Y.ACT.DATE = ICONV(Y.ACT.DATE, "DI")
*Y.ACT.DATE = OCONV(Y.ACT.DATE, "D4")
            Y.ACT.DATE.VAL = Y.ACT.DATE
        END
    END
    IF Y.LAST.CRD.DATE EQ '' THEN
        IF Y.LAST.DBT.DATE THEN
            Y.ACT.DATE = Y.LAST.DBT.DATE
*Y.ACT.DATE = ICONV(Y.ACT.DATE, "DI")
*Y.ACT.DATE = OCONV(Y.ACT.DATE, "D4")
            Y.ACT.DATE.VAL = Y.ACT.DATE
        END
    END
    IF Y.LAST.DBT.DATE EQ '' THEN
        IF Y.LAST.CRD.DATE THEN
            Y.ACT.DATE = Y.LAST.CRD.DATE
*Y.ACT.DATE = ICONV(Y.ACT.DATE, "DI")
*Y.ACT.DATE = OCONV(Y.ACT.DATE, "D4")
            Y.ACT.DATE.VAL = Y.ACT.DATE
        END
    END

    IF Y.ACT.DATE.VAL THEN
        O.DATA = Y.ACT.DATE.VAL
    END ELSE
        O.DATA = ''
    END
RETURN
*-------------------------------------------------------------------------------------
END
