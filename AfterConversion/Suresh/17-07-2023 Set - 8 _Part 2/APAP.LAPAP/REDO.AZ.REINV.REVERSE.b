* @ValidationCode : Mjo0OTc0MDAxMzpDcDEyNTI6MTY4OTI0ODQ3NjgyOTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 17:11:16
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
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*13/07/2023      Conversion tool            R22 Auto Conversion             Nochange
*13/07/2023      Suresh                     R22 Manual Conversion           Nochange
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.AZ.REINV.REVERSE(SEL.ID)

* Description: This is routine to remove the inactive / closed deposit reinvested account.
*
    $INSERT I_COMMON ;*R22 Auto Conversion - Start
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT.CLOSURE
    $INSERT I_REDO.AZ.REINV.REVERSE.COMMON ;*R22 Auto Conversion - End


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
******
    ACCT.ERR = ''; R.ACCOUNT = ''; YL.AC.AZ.ACC.REF = ''; YCATEG = ''; YRNV.VA = 0
    YOFS.COMPANY = ''; YREINV.VAL = ''; YFLG = 0; YSKIP.FLG = 0; YWORKBAL = ''; C.TMDEPT.POS = ''
RETURN
 
PROCESS:
********
    IF NOT(ISDIGIT(SEL.ID)) THEN
        RETURN
    END
    ACCT.ID = SEL.ID
    GOSUB READ.ACCOUNT
    YL.AC.AZ.ACC.REF = R.ACCOUNT<AC.LOCAL.REF,POS.AZ.ACC.REF>
    YCATEG = R.ACCOUNT<AC.CATEGORY>
    YOFS.COMPANY = R.ACCOUNT<AC.CO.CODE>

    IF (YCATEG GE '6013' AND YCATEG LE '6020') THEN
        GOSUB REINV.ACCT.CHECK
        YRNV.VA = 1
    END ELSE
        LOCATE YCATEG IN Y.AZ.CATEGORY SETTING C.TMDEPT.POS ELSE
            RETURN
        END
        GOSUB INV.ACCT.CHECK
    END
    IF R.AZ.ACCOUNT THEN
        R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,POS.AC.CAN.REASON.CLOSE> = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.AC.CAN.REASON.AZ>
        R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,POS.AC.OTH.REASON.CLOSE> = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.AC.OTH.REASON.AZ>
    END

    IF YSKIP.FLG EQ 1 THEN
        RETURN
    END

    IF (YFLG EQ 1 AND YREINV.VAL NE 'YES') THEN
        RETURN
    END

    YWORKBAL = R.ACCOUNT<AC.WORKING.BALANCE>
    IF YWORKBAL AND YWORKBAL NE 0 THEN
        R.ACCOUNT.CLOSURE<AC.ACL.CAPITAL.DATE> = TODAY
    END
    R.ACCOUNT.CLOSURE<AC.ACL.POSTING.RESTRICT> = '90'
    R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.MODE> = 'AUTO'
    R.ACCOUNT.CLOSURE<AC.ACL.CLOSE.ONLINE> = 'Y'
*    R.ACCOUNT.CLOSURE<AC.ACL.LOCAL.REF,POS.AZ.ACC.REF.CLOSE> = YL.AC.AZ.ACC.REF

    APPLICATION.NAME = 'ACCOUNT.CLOSURE'
    OFS.FUNCTION1 = 'I'
    PROCESS1 = 'PROCESS'
    OFS.VERSION1 = ''
    GTSMODE1 = ''
    NO.OF.AUTH1 = '0'
    OFS.RECORD1 = ''
    VERSION1 = 'ACCOUNT.CLOSURE,CLOSE'
    MSG.ID1 = ''
    OPTION1 = ''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,OFS.FUNCTION1,PROCESS1,VERSION1,GTSMODE1,NO.OF.AUTH1,SEL.ID,R.ACCOUNT.CLOSURE,OFS.ACC)
    MSG.ID = ''; ERR.OFS = ''
    CALL OFS.POST.MESSAGE(OFS.ACC,MSG.ID,AZ.OFS.SOURCE,ERR.OFS)
RETURN

REINV.ACCT.CHECK:
*****************
    IF NOT(YL.AC.AZ.ACC.REF) THEN
        YSKIP.FLG = 1
        RETURN
    END
    AZ.ACCT.ID = YL.AC.AZ.ACC.REF
    GOSUB READ.AZ.ACCT
    IF R.AZ.ACCOUNT THEN
        YSKIP.FLG = 1
        RETURN
    END
    YL.AC.AZ.ACC.REF.H = YL.AC.AZ.ACC.REF
    CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.H,YL.AC.AZ.ACC.REF.H,R.AZ.ACCOUNT,AZ.ERR)
    IF NOT(R.AZ.ACCOUNT) THEN
        YFLG = 1
        ACCT.ID = YL.AC.AZ.ACC.REF
        GOSUB READ.ACCOUNT
        IF NOT(R.ACCOUNT) THEN
            YL.AC.AZ.ACC.REF.H = ''; YL.AC.AZ.ACC.REF.H = YL.AC.AZ.ACC.REF
            CALL EB.READ.HISTORY.REC(F.ACCOUNT.H,YL.AC.AZ.ACC.REF.H,R.ACCOUNT,ACCT.ERR)
            YREINV.VAL = R.ACCOUNT<AC.LOCAL.REF,L.AC.REINVESTED.POS>
        END
    END
RETURN

INV.ACCT.CHECK:
***************
    AZ.ACCT.ID = SEL.ID
    GOSUB READ.AZ.ACCT
    IF R.AZ.ACCOUNT THEN
        YSKIP.FLG = 1
    END
    YL.AC.AZ.ACC.REF = SEL.ID
RETURN

READ.AZ.ACCT:
*************
    AZ.ERR = ''; R.AZ.ACCOUNT = ''
    CALL F.READ(FN.AZ.ACCOUNT,AZ.ACCT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)
RETURN

READ.ACCOUNT:
*************
    R.ACCOUNT = ''; ACCT.ERR = ''
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
RETURN
END
