<<<<<<< Updated upstream
* @ValidationCode : Mjo4ODA4OTMxNDU6Q3AxMjUyOjE2OTAyNjQzOTg2NzQ6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:23:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationCode : MjotMTQzNzAyMzcxMzpDcDEyNTI6MTY4NDg1NDM4OTg0MzpJVFNTOi0xOi0xOjM3MToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 371
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
* Date                   who                   Reference
=======
* Date                   who                   Reference              
>>>>>>> Stashed changes
* 12-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND SM TO @SM AND ++ TO += 1
* 12-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_REDO.B.LOAN.CLOSURE.COMMON
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT
<<<<<<< Updated upstream
    $USING APAP.TAM
=======
>>>>>>> Stashed changes

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------

    ACC.ID = ''
<<<<<<< Updated upstream
*   CALL REDO.GET.TOTAL.OUTSTANDING(ARR.ID,PROP.AMT,TOTAL.AMT)
    APAP.TAM.redoGetTotalOutstanding(ARR.ID,PROP.AMT,TOTAL.AMT) ;*R22 Manual Code Conversion
=======
    CALL REDO.GET.TOTAL.OUTSTANDING(ARR.ID,PROP.AMT,TOTAL.AMT)
>>>>>>> Stashed changes
    IF TOTAL.AMT EQ 0 ELSE
        RETURN
    END

<<<<<<< Updated upstream
*   CALL REDO.CONVERT.ACCOUNT('',ARR.ID,ACC.ID,ERR.TEXT)
    APAP.TAM.redoConvertAccount('',ARR.ID,ACC.ID,ERR.TEXT) ;*;*R22 Manual Code Conversion
=======
    CALL REDO.CONVERT.ACCOUNT('',ARR.ID,ACC.ID,ERR.TEXT)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
*    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR) ;*R22 Manual Code Conversion
    
=======
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHRG.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
*       CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CHARGE,ERR.MSG)
        APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CHARGE,ERR.MSG) ;*R22 Manual Code Conversion
=======
        CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CHARGE,ERR.MSG)
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
*       CALL REDO.UPDATE.INSURANCE.DETAILS(Y.POL.NO)
        APAP.TAM.redoUpdateInsuranceDetails(Y.POL.NO) ;*R22 Manual Code Conversion
=======
        CALL REDO.UPDATE.INSURANCE.DETAILS(Y.POL.NO)

>>>>>>> Stashed changes
        Y.VAR2 += 1
    REPEAT
RETURN
END
