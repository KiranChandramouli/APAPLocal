SUBROUTINE REDO.B.LOAN.CLOSURE(ARR.ID)
*------------------------------------------------------------------------
* Description: This is a Batch routine which will run in COB
* and close the accounts of matured AA contracts
*------------------------------------------------------------------------
* Input Arg: ARR.ID -> Arrangement ID
* Ouput Arg: N/A
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE          DESCRIPTION
* 02-JAN-2012     H GANESH              PACS00174524 - B.43 Initial Draft
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_REDO.B.LOAN.CLOSURE.COMMON
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------

    ACC.ID = ''
    CALL REDO.GET.TOTAL.OUTSTANDING(ARR.ID,PROP.AMT,TOTAL.AMT)
    IF TOTAL.AMT EQ 0 ELSE
        RETURN
    END

    CALL REDO.CONVERT.ACCOUNT('',ARR.ID,ACC.ID,ERR.TEXT)
    IF ACC.ID ELSE
        RETURN
    END

    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    IF R.ACCOUNT ELSE
        RETURN
    END

    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>

*GOSUB UPDATE.INSURANCE.CHARGE

    R.ACCOUNT<AC.ARRANGEMENT.ID> = ''
    CALL F.WRITE(FN.ACCOUNT,ACC.ID,R.ACCOUNT)
    GOSUB POST.OFS


RETURN
*------------------------------------------------------------------------
POST.OFS:
*------------------------------------------------------------------------
    R.ACC.CLOSURE = ''
    R.ACC.CLOSURE<AC.ACL.POSTING.RESTRICT>='90'
    R.ACC.CLOSURE<AC.ACL.CLOSE.ONLINE>='Y'

    APP.NAME         = 'ACCOUNT.CLOSURE'
    OFSFUNCT         = 'I'
    PROCESS          = 'PROCESS'
    OFSVERSION       = 'ACCOUNT.CLOSURE,REDO.AA.ACC.CLOSE'
    GTSMODE          = ''
    TRANSACTION.ID   = ACC.ID
    OFSRECORD        = ''
    OFS.MSG.ID       = ''
    OFS.ERR          = ''
    OFS.SRC          = 'REDO.OFS.AZ.UPDATE'
    OPTIONS          = ''
    NO.OF.AUTH       = 0
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.ACC.CLOSURE,OFSRECORD)
    CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SRC,OPTIONS)

    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)
    R.REDO.CUSTOMER.ARRANGEMENT<CUS.ARR.CLOSED,-1> = ACC.ID
    CALL F.WRITE(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER,R.REDO.CUSTOMER.ARRANGEMENT)

RETURN

*------------------------------------------------------------------------
UPDATE.INSURANCE.CHARGE:
*------------------------------------------------------------------------

    Y.CHRG.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR)
    Y.PROPERTY.LIST = Y.CHRG.PROPERTY

    Y.CHARGE.PROP.CNT = DCOUNT(Y.PROPERTY.LIST,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.CHARGE.PROP.CNT

        EFF.DATE   = ''
        PROP.CLASS = 'CHARGE'
        PROPERTY   = Y.PROPERTY.LIST<Y.VAR1>
        R.CONDITION.CHARGE = ''
        ERR.MSG = ''
        CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CHARGE,ERR.MSG)
        Y.POLICY.NO = ''
        Y.POLICY.NO = R.CONDITION.CHARGE<AA.CHG.LOCAL.REF,POS.POL.NUMBER>

        IF Y.POLICY.NO THEN
            GOSUB WRITE.INSURANCE.DETAILS
        END
        Y.VAR1 += 1
    REPEAT

RETURN
*---------------------------------------------------------------------------------
WRITE.INSURANCE.DETAILS:
*---------------------------------------------------------------------------------

    Y.POLICY.NO.CNT = DCOUNT(Y.POLICY.NO,@SM)
    Y.VAR2 = 1

    LOOP
    WHILE Y.VAR2 LE Y.POLICY.NO.CNT

        Y.POL.NO = Y.POLICY.NO<1,1,Y.VAR2>
        CALL REDO.UPDATE.INSURANCE.DETAILS(Y.POL.NO)

        Y.VAR2 += 1
    REPEAT
RETURN
END
