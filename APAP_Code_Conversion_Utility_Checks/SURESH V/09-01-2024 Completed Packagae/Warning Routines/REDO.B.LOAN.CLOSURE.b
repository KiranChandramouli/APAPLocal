* @ValidationCode : MjotMTA5MDM3NDU5MzpDcDEyNTI6MTcwNDE3NjI2Mzc0NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jan 2024 11:47:43
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
$PACKAGE APAP.REDOBATCH
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
* Date                   who                   Reference
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND SM TO @SM AND ++ TO += 1
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*02/01/2024         Suresh                R22 Manual Conversion   Change F.READ to F.READU
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_REDO.B.LOAN.CLOSURE.COMMON
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
    $USING APAP.TAM

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------

    ACC.ID = ''
*   CALL REDO.GET.TOTAL.OUTSTANDING(ARR.ID,PROP.AMT,TOTAL.AMT)
    APAP.TAM.redoGetTotalOutstanding(ARR.ID,PROP.AMT,TOTAL.AMT) ;*R22 Manual Code Conversion
    IF TOTAL.AMT EQ 0 ELSE
        RETURN
    END

*   CALL REDO.CONVERT.ACCOUNT('',ARR.ID,ACC.ID,ERR.TEXT)
    APAP.TAM.redoConvertAccount('',ARR.ID,ACC.ID,ERR.TEXT) ;*;*R22 Manual Code Conversion
    IF ACC.ID ELSE
        RETURN
    END

*    CALL F.READ(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    CALL F.READU(FN.ACCOUNT,ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR,"") ;*R22 Manual Conversion

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

*    CALL F.READ(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR)
    CALL F.READU(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER,R.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT,CUS.ARR.ERR,"") ;*R22 Manual Conversion
    
    R.REDO.CUSTOMER.ARRANGEMENT<CUS.ARR.CLOSED,-1> = ACC.ID
    CALL F.WRITE(FN.REDO.CUSTOMER.ARRANGEMENT,Y.CUSTOMER,R.REDO.CUSTOMER.ARRANGEMENT)

RETURN

*------------------------------------------------------------------------
UPDATE.INSURANCE.CHARGE:
*------------------------------------------------------------------------

    Y.CHRG.PROPERTY = ''
*    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR) ;*R22 Manual Code Conversion
    
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
*       CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CHARGE,ERR.MSG)
        APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CHARGE,ERR.MSG) ;*R22 Manual Code Conversion
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
*       CALL REDO.UPDATE.INSURANCE.DETAILS(Y.POL.NO)
        APAP.TAM.redoUpdateInsuranceDetails(Y.POL.NO) ;*R22 Manual Code Conversion
        Y.VAR2 += 1
    REPEAT
RETURN
END
