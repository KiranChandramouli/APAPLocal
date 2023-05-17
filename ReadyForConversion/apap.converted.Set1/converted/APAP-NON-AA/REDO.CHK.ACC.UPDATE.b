SUBROUTINE REDO.CHK.ACC.UPDATE
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION :   This routine will be executed at check Record Routine for the account closure versions
* It is used to update the cancel reason from deposit account
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.CHK.ACC.UPDATE
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO               REFERENCE         DESCRIPTION
* 23-11-2011     Sudharsanan S      PACS00164586    Initial Creation
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.CUSTOMER
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.AZ.FUND.PARAM
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-------------------------------------------------------------------------------
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT = ''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.ACCOUNT.HIS = 'F.AZ.ACCOUNT$HIS'
    F.AZ.ACCOUNT.HIS = ''
    CALL OPF(FN.AZ.ACCOUNT.HIS,F.AZ.ACCOUNT.HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.AZ.FUND.PARAM = 'F.REDO.AZ.FUND.PARAM'

    LOC.REF.APP = 'ACCOUNT.CLOSURE':@FM:'AZ.ACCOUNT':@FM:'ACCOUNT'
    LOC.REF.FIELD = 'L.ACL.WAIVE.CHG':@VM:'L.AC.AZ.ACC.REF':@VM:'L.AC.CAN.REASON':@VM:'L.AC.OTH.REASON':@VM:'L.CLOSE.MODE':@FM:'L.AC.CAN.REASON':@VM:'L.AC.OTH.REASON':@FM:'L.AC.AZ.ACC.REF':@VM:'L.AC.STATUS2'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APP,LOC.REF.FIELD,LOC.REF.POS)
    POS.WAIVE.CHG.CLOSE     = LOC.REF.POS<1,1>
    POS.AZ.ACC.REF.CLOSE    = LOC.REF.POS<1,2>
    POS.AC.CAN.REASON.CLOSE = LOC.REF.POS<1,3>
    POS.AC.OTH.REASON.CLOSE = LOC.REF.POS<1,4>
    POS.CLOSE.MODE        = LOC.REF.POS<1,5>
    POS.AC.CAN.REASON.AZ    = LOC.REF.POS<2,1>
    POS.AC.OTH.REASON.AZ    = LOC.REF.POS<2,2>
    POS.AZ.ACC.REF          = LOC.REF.POS<3,1>
    POS.STATUS2             = LOC.REF.POS<3,2>

    VAR.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.AZ.FUND.PARAM,VAR.ID,R.FUND.PARAM,FUND.ERR)

RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------
* This is the main para used to check the category and update the charge related fields
    VAR.ACC.ID = ID.NEW
    CALL F.READ(FN.ACCOUNT,VAR.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    VAR.CUSTOMER.NO = R.ACCOUNT<AC.CUSTOMER>
    VAR.CURRENCY    = R.ACCOUNT<AC.CURRENCY>

****PACS00249339-S

** THIS PART IS MODIFIED FOR DIFFERENTIATE THE AZ AND ACCOUNT.CLOSURE INTERNAL ACCOUNTS IN THE PARAM. TABLE

* CCY.PARAM = R.FUND.PARAM<REDO.FUND.CURRENCY>
* CHANGE VM TO FM IN CCY.PARAM
* LOCATE VAR.CURRENCY IN CCY.PARAM SETTING CCY.POS THEN
*     VAR.ACCT.NUM = R.FUND.PARAM<REDO.FUND.ACCT.NUMBER,CCY.POS>
* END

    IF VAR.CURRENCY EQ LCCY THEN
        VAR.ACCT.NUM = R.FUND.PARAM<REDO.FUND.ACL.LCY.ACCT>
    END ELSE
        VAR.ACCT.NUM = R.FUND.PARAM<REDO.FUND.ACL.FCY.ACCT>
    END

****PACS00249339 - E

    CALL F.READ(FN.CUSTOMER,VAR.CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    VAR.CUST.STATUS = R.CUSTOMER<EB.CUS.CUSTOMER.STATUS>

    IF VAR.CUST.STATUS EQ '3' THEN
        E = 'EB-REDO.AC.DECESED'
        RETURN
    END

    VAR.ACCT.STATUS = R.ACCOUNT<AC.LOCAL.REF,POS.STATUS2>
    CHANGE @SM TO @FM IN VAR.ACCT.STATUS
    LOCATE 'DECEASED' IN VAR.ACCT.STATUS SETTING POS THEN
        E = 'EB-REDO.AC.DECESED'
        RETURN
    END

    VAR.AZ.ACC.REF = R.ACCOUNT<AC.LOCAL.REF,POS.AZ.ACC.REF>
    IF PGM.VERSION EQ ',REDO.TELLER' THEN
*R.NEW(AC.ACL.CLOSE.MODE) = 'TELLER'
        R.NEW(AC.ACL.CLOSE.MODE) = 'AUTO'
        R.NEW(AC.ACL.SETTLEMENT.ACCT) = VAR.ACCT.NUM
        R.NEW(AC.ACL.LOCAL.REF)<1,POS.CLOSE.MODE> = 'TELLER'
    END ELSE
        R.NEW(AC.ACL.CLOSE.MODE) = 'AUTO'
        R.NEW(AC.ACL.LOCAL.REF)<1,POS.CLOSE.MODE> = 'FT'
    END

    IF VAR.AZ.ACC.REF THEN
        R.AZ.ACC = ''
        CALL F.READ(FN.AZ.ACCOUNT,VAR.AZ.ACC.REF,R.AZ.ACC,F.AZ.ACCOUNT,AZ.ERR)
        IF R.AZ.ACC EQ '' THEN
            CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HIS,VAR.AZ.ACC.REF,R.AZ.ACC.HIS,YERR)
            R.NEW(AC.ACL.LOCAL.REF)<1,POS.AC.CAN.REASON.CLOSE> = R.AZ.ACC.HIS<AZ.LOCAL.REF,POS.AC.CAN.REASON.AZ>
            R.NEW(AC.ACL.LOCAL.REF)<1,POS.AC.OTH.REASON.CLOSE> = R.AZ.ACC.HIS<AZ.LOCAL.REF,POS.AC.OTH.REASON.AZ>
        END ELSE
            R.NEW(AC.ACL.LOCAL.REF)<1,POS.AC.CAN.REASON.CLOSE> = R.AZ.ACC<AZ.LOCAL.REF,POS.AC.CAN.REASON.AZ>
            R.NEW(AC.ACL.LOCAL.REF)<1,POS.AC.OTH.REASON.CLOSE> = R.AZ.ACC<AZ.LOCAL.REF,POS.AC.OTH.REASON.AZ>
        END
    END

RETURN
*---------------------------------------------------------------------------------------------------------------
END
