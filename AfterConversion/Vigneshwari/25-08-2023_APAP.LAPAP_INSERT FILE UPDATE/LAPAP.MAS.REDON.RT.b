* @ValidationCode : MjotMTk4MzM2NjY5NDpDcDEyNTI6MTY5Mjk2NTAwOTkzNTp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Aug 2023 17:33:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE		AUTHOR			      Modification                     DESCRIPTION
*25/08/2023	 VIGNESHWARI	    MANUAL R22 CODE CONVERSION	     NOCHANGE
*25/08/2023	 CONVERSION TOOL    AUTO R22 CODE CONVERSION	   T24.BP,BP,LAPAP.BP is removed in insertfile
*-----------------------------------------------------------------------------------------------------------------------
    SUBROUTINE LAPAP.MAS.REDON.RT(Y.ROUNDUP)
    $INSERT  I_EQUATE ;*AUTO R22 CODE CONVERSION-START - T24.BP is removed in insertfile
    $INSERT  I_COMMON
    $INSERT  I_GTS.COMMON
    $INSERT  I_System
    $INSERT  I_F.DATES ;*AUTO R22 CODE CONVERSION-END
    $INCLUDE  I_F.ST.LAPAP.CRC.ROUNDUP.DET  ;*AUTO R22 CODE CONVERSION-START -BP is removed in insertfile
    $INCLUDE  I_F.ST.LAPAP.CRC.ROUNDUP  ;*AUTO R22 CODE CONVERSION-END
    $INSERT  I_LAPAP.MAS.REDON.RT.COMMON  ;*AUTO R22 CODE CONVERSION - LAPAP.BP is removed in insertfile
    $INSERT  I_F.FUNDS.TRANSFER   ;*AUTO R22 CODE CONVERSION - T24.BP is removed in insertfile

    GOSUB DO.PROCESS

    RETURN

DO.PROCESS:


    CALL OCOMO("ROUNDUP TO PROCESS : " : Y.ROUNDUP)
    GOSUB DO.READ

    RETURN

DO.READ:

    CALL F.READ(FN.CRC.ROUNDUP.DET,Y.ROUNDUP,R.CRC.ROUNDUP.DET,F.CRC.ROUNDUP.DET,ERR.CRC.ROUNDUP.DET)

    IF (R.CRC.ROUNDUP.DET) THEN
        GOSUB DO.FORM.ARRAY
    END

    RETURN



DO.FORM.ARRAY:

    R.FT = ''
    R.FT<FT.TRANSACTION.TYPE> = Y.TRANSACTION.TYPE
    R.FT<FT.DEBIT.ACCT.NO> = Y.DR.ACCT.NO
    R.FT<FT.CREDIT.CURRENCY> = R.CRC.ROUNDUP.DET<ST.LAP50.CREDIT.CCY>
    R.FT<FT.CREDIT.ACCT.NO> = R.CRC.ROUNDUP.DET<ST.LAP50.CREDIT.ACCOUNT>
    R.FT<FT.CREDIT.AMOUNT> = R.CRC.ROUNDUP.DET<ST.LAP50.CREDIT.AMOUNT>
    R.FT<FT.LOCAL.REF,Y.L.COMMENTS.POS> = R.CRC.ROUNDUP.DET<ST.LAP50.COMMENTS>
    R.FT<FT.LOCAL.REF,Y.L.ROUNDUP.DET.POS> = Y.ROUNDUP

    GOSUB DO.FORM.OFS

    RETURN

DO.FORM.OFS:
    Y.TRANS.ID = ''
    Y.APP.NAME = "FUNDS.TRANSFER"
    Y.VER.NAME = Y.APP.NAME :",LAPAP.ROUNDUP"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = "3"
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    OFS.MSG.ID = ''
    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.FT,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,"CR.CTA.OFS.GL",'')
    Y.OFS.ID = OFS.MSG.ID

    GOSUB DO.UPDATE.ROUNDUP.DET
    RETURN

DO.UPDATE.ROUNDUP.DET:
    Y.TRANS.ID = Y.ROUNDUP
    Y.APP.NAME = "ST.LAPAP.CRC.ROUNDUP.DET"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = ""
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""
    OFS.MSG.ID = ''

    R.DET = ''
    R.DET<ST.LAP50.TXN.OFS.DET.ID> = Y.OFS.ID
    R.DET<ST.LAP50.STATUS> = 'CONFIRMING'
    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.DET,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,OFS.MSG.ID,"CR.CTA.OFS.GL",'')
    RETURN




END
