$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.GET.ACCT.LOC.AMT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.GET.ACCT.LOC.AMT
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the LOCKED AMOUNT
*                    from ACCOUNT and returns it to O.DATA
*Linked With       : Enquiry REDO.APAP.ENQ.S.ACCT.DYN.RPT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*--------------------------------------------------------------------------------------------------------
*Date                   Who                  Reference                        Description
*------                 -----                -------------                    -------------
* 15.11.2010     Sakthi Sellappillai         ODR-2010-08-0173                 Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM and ++ to +=
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    GOSUB PROCESS.PARA
    GOSUB GOEND
RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.ACCOUNT$HIS='F.ACCOUNT$HIS'
    F.ACCOUNT$HIS = ''
    CALL OPF(FN.ACCOUNT$HIS, F.ACCOUNT$HIS)
    R.ACCOUNT.HIS.REC = ''
    Y.ACCOUNT.HIS.ERR = ''
    R.ACCOUNT.REC = ''
    Y.ACCT.ERR = ''
    Y.ACCT.ID.VAL = O.DATA
    Y.AC.LOC.AMT.VAL = ''
    Y.LOC.AMT.VALUE = ''
    Y.LOC.AMT.INIT.CNT = 1
    Y.HIS.ACCT.ID = ''
    Y.HIS.SYM.VAL = FIELD(Y.ACCT.ID.VAL,';',2,1)
    IF Y.HIS.SYM.VAL THEN
        Y.HIS.ACCT.ID = FIELD(Y.ACCT.ID.VAL,';',1,1)
        CALL EB.READ.HISTORY.REC(F.ACCOUNT$HIS,Y.HIS.ACCT.ID,R.ACCOUNT.HIS.REC,Y.ACCOUNT.HIS.ERR)
        IF NOT(Y.ACCOUNT.HIS.ERR) THEN
            Y.AC.LOC.AMT.VAL = R.ACCOUNT.HIS.REC<AC.LOCKED.AMOUNT>
        END
    END ELSE
        CALL F.READ(FN.ACCOUNT,Y.ACCT.ID.VAL,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
        IF NOT(Y.ACCT.ERR) THEN
            Y.AC.LOC.AMT.VAL = R.ACCOUNT.REC<AC.LOCKED.AMOUNT>
        END
    END
    Y.LOC.AMT.CNT = DCOUNT(Y.AC.LOC.AMT.VAL,@VM)
    IF Y.LOC.AMT.CNT GT 1 THEN
        LOOP
            REMOVE Y.LOC.AMT.INT FROM Y.AC.LOC.AMT.VAL SETTING Y.LOC.LOC.AMT.POS
        WHILE Y.LOC.AMT.INIT.CNT LE Y.LOC.AMT.CNT
            IF NOT(Y.LOC.AMT.VALUE) THEN
                Y.LOC.AMT.VALUE = Y.LOC.AMT.INT
            END ELSE
                Y.LOC.AMT.VALUE += Y.LOC.AMT.INT
            END
            Y.LOC.AMT.INIT.CNT += 1
        REPEAT
    END ELSE
        Y.LOC.AMT.VALUE = Y.AC.LOC.AMT.VAL
    END
    IF Y.LOC.AMT.VALUE THEN
        O.DATA = Y.LOC.AMT.VALUE
    END ELSE
        O.DATA = ''
    END
RETURN
*--------------------------------------------------------------------------------------------------------
GOEND:
*--------------------------------------------------------------------------------------------------------
END
*-------------------------------------------*END OF SUBROUTINE*------------------------------------------
